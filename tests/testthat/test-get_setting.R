
library(stringr)

# Extract Maximum Grades --------------------------------------------------



test_that("test regex to extract max grade", {

  regex_setting_grade_max <- "[:digit:]+\\.?[:digit:]*"

  # Usual Case
  str_extract("Grade/9.00", regex_setting_grade_max) %>% expect_equal("9.00")
  # Acceptable Variant
  str_extract("Grade/9", regex_setting_grade_max) %>% expect_equal("9")
  str_extract("Grade/ 12.34", regex_setting_grade_max) %>% expect_equal("12.34")
  str_extract("Grade/ 12.34 ", regex_setting_grade_max) %>% expect_equal("12.34")

  # Un-typical case will fail silently
  str_extract("2 Grade/ 12.34 ", regex_setting_grade_max) %>% expect_equal("2")
  # No Numeric will get NA
  str_extract("Grade", regex_setting_grade_max) %>% expect_equal(NA_character_)
})


test_that("get_setting_grade_max() works", {

  df1 <- data.frame("Grade/12.34" = c(1:2))
  df2 <- data.frame("Grade / 12" = c(1:2))

  expect_equal(get_setting_grade_max(grades_df), 9)
  expect_equal(get_setting_grade_max(df1), 12.34)
  expect_equal(get_setting_grade_max(df2), 12)

})


# Question No and Max -----------------------------------------------------



test_that("test regex to extract question number & max score",{

  ## Test Extract Question Number
  as.numeric(str_extract("Q. 2 /1.00", "[:digit:]+")) %>% expect_equal(2)

  ## Test Extract after back slash
  as.numeric(str_extract("Q. 3 /1", "(?<=/)(.+)")) %>% expect_equal(1)
  as.numeric(str_extract("Q. 3 /2.38", "(?<=/)(.+)")) %>% expect_equal(2.38)
  as.numeric(str_extract("Q. 3 / 2.38 ", "(?<=/)(.+)")) %>% expect_equal(2.38)


})

test_that("get_setting_questions_no_max() works",{
  ## Test: Even though Q.xx column arranged differently, we will still get correct correct question Max
  q_swab_order <- c(letters[1:3]) %>%
    setNames(c("Q. 1 /2.00", "Q. 3/6.00", "Q. 2/4.00"))

  get_setting_questions_no_max(q_swab_order) %>% expect_equal(c(Q1 = 2,Q3 = 6,Q2 = 4))

  ## Test: Grades Report (Internal Data)
  q_no_max <- get_setting_questions_no_max(moodleStats:::grades_df2_nyg)

  expect_named(q_no_max, paste0("Q",1:6))
  expect_equal(unname(q_no_max), c(6, 3, 4,  1,  2,  4))

})


#get_setting_questions_no_max(grades_df)
#get_setting_questions_no_max(moodleStats:::grades_df2_nyg)

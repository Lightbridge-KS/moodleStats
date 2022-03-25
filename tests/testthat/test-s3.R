

library(dplyr)

# MoodleQuizReport --------------------------------------------------------


test_that("test create_MoodleQuizReport()",{

  gr1 <- create_MoodleQuizReport(grades_df)
  resp1 <- create_MoodleQuizReport(moodleStats:::responses_df)

  expect_s3_class(gr1, "MoodleQuizReport")
  expect_s3_class(resp1, "MoodleQuizReport")

  expect_equal(attr(gr1, "quiz_setting"), list(grade_max = 9))
  expect_equal(attr(resp1, "quiz_setting"), list(grade_max = 20))

  # Error
  expect_error(create_MoodleQuizReport(iris))
})


#attributes( create_MoodleQuizReport(grades_df))
#attributes( create_MoodleQuizReport(moodleStats:::responses_df))


# Grades Report ------------------------------------------------------------



test_that("test create_GradesReport()",{

  gr1 <- grades_df %>%
    create_MoodleQuizReport() %>%
    create_GradesReport()

  expect_named(attr(gr1, "quiz_setting"), c("grade_max", "questions_max"))


})

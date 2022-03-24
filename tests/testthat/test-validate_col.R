

test_that("is_some_grade_numeric() works",{
  # Grade column has some numeric
  expect_true(is_some_grade_numeric(grades_df))
  # Grade column has no numeric (INTERNAL)
  expect_false(is_some_grade_numeric(moodleStats:::grades_df2_nyg))
})


test_that("is_some_grade_nyg() works", {

  # Grade column has "Not yet graded"
  expect_true(is_some_grade_nyg(moodleStats:::grades_df2_nyg))
  # Grade column has no "Not yet graded"
  expect_false(is_some_grade_nyg(grades_df))

})

# moodleStats:::grades_df2_nyg %>% pull(`Grade/20.00`) %>% unique()

# grades_df %>% pull(`Grade/9.00`) %>% unique()

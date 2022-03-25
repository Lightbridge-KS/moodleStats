

# Get Filter by -----------------------------------------------------------



test_that("get_filter_by() works",{

  gr_report <- get_filter_by(prep_grades_report(grades_df))
  expect_type(gr_report, "list")

})


# Get Quiz Setting --------------------------------------------------------



test_that("get_quiz_setting() works", {

  setting_gr <- get_quiz_setting(grades_df)
  setting_resp <- get_quiz_setting(moodleStats:::responses_df)

  # Named List for Grades
  expect_named(setting_gr, c("grade_max", "questions_max"))
  # Named List for Responses
  expect_named(setting_resp, c("grade_max"))

  # Error
  expect_error(get_quiz_setting(iris))

})




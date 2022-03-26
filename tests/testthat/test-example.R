



test_that("moodleStats_example() works",{

  grades_df_path <- moodleStats_example("grades_report.csv")
  expect_true(file.exists(grades_df_path))

})

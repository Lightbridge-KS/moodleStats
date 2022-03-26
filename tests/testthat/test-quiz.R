

grades_df_preped <- prep_grades_report(grades_df)


test_that("summary_quiz() works",{

  df <- summary_quiz(grades_df_preped)
  expect_equal(dim(df), c(1, 14))
  expect_named(df, c("n", "min", "max", "max_quiz", "median",
                     "Q1", "Q3", "IQR", "MAD", "mean", "SD",
                     "skewness", "kurtosis", "Cronbach_Alpha"))

})


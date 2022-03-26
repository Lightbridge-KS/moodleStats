

grades_df_preped <- prep_grades_report(grades_df)


test_that("summary_questions() works", {

  df_sum <- summary_questions(grades_df_preped)

  expect_s3_class(df_sum, "data.frame")
  expect_equal(dim(df_sum), c(9, 11))

})


test_that("questions_stats() works", {

  df_stats <- questions_stats(grades_df_preped)
  expect_equal(dim(df_stats), c(9, 13))

})

test_that("item_discrim() works",{

  df_item <- item_discrim(grades_df_preped)

  expect_equal(dim(df_item), c(9, 10))
  expect_named(df_item,
               c("Questions", "estimate", "statistic", "p.value", "parameter",
                 "conf.low", "conf.high", "method", "alternative", "p.signif")
  )

})

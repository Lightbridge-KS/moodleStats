
library(dplyr)



test_that("summarise_stats_var() works",{

  stat_df <- summarise_stats_var(iris, Sepal.Length)

  # 1 Row DF
  expect_s3_class(stat_df, "data.frame")
  expect_equal(nrow(stat_df), 1)

  stat_df_grp <- iris %>%
    group_by(Species) %>%
    summarise_stats_var(Sepal.Length)

  # Groupd DF
  expect_equal(nrow(stat_df_grp), 3)

})

# summarise_stats_var(iris, Sepal.Length)

# iris %>%
#   group_by(Species) %>%
#   summarise_stats_var(Sepal.Length)


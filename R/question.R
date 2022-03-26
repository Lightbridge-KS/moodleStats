

# Summary Questions -------------------------------------------------------



#' Questions Summary of Moodle Grade Report
#'
#' @description Calculate questions summary and item analysis of [Moodle Grade Report](https://docs.moodle.org/311/en/Quiz_reports#Grades_report) (See **Details**).
#'
#' @details [summary_questions()] calculate overall summary grouped by each questions of Moodle Grade Report, and return the result as a data frame.
#' The data frame has a column "Questions" for questions number in the quiz. Other columns are the followings.
#'
#' **Basic summary statistic**
#' * \strong{n}: number of students who answered each questions.
#' * \strong{min}: student's minimum score of each questions.
#' * \strong{max}: student's maximum score of each questions.
#' * \strong{max_setting}: maximum score possible of each questions (from the quiz setting).
#' * \strong{mean}: mean score of each questions.
#' * \strong{SD}: standard deviation of each questions score.
#'
#' **Item analysis**
#' * \strong{Difficulty_Index}: Item Difficulty Index (p) is a measure of the \emph{proportion} of examinees who answered the item correctly.
#'   It ranges between 0.0 and 1.0, \emph{higher} value indicate \emph{lower} question difficulty, and vice versa.
#' * \strong{Discrimination_Index}: Item Discrimination Index (r) is a measure of how well an item is able to distinguish between examinees who are knowledgeable and those who are not.
#'   It is a pairwise **point-biserial correlation** between the *score of each questions* ("Q" columns) and *total score of the quiz* ("Grade" column).
#'   It range between -1.0 to 1.0. Negative values suggest a problem, indicating that score of the particular question is negatively correlated with total quiz score; therefore, revision of the question is suggested.
#' * \strong{p.value}: A level of significant (p-value) of `Discrimination_Index`.
#' * \strong{p.signif}: A Symbol indicating level of significant of `Discrimination_Index`.
#'
#' @seealso
#' * [summary_quiz()] for quiz summary statistics
#' * [questions_stats()] for question summary statistics with more parameters.
#' * [item_discrim()] for Item discrimination index with more parameters.
#'
#' @references
#' * [How to interpret an item analysis](https://www.proftesting.com/test_topics/steps_9.php)
#'
#' @param data (GradesReport) A data frame of class "GradesReport"
#' @param cor_method (Character) A character string indicating which correlation coefficient is to be used for calculating `Discrimination_Index`.
#' Default is Pearson's correlation ("pearson"). Other types can be specified such as "kendall", or "spearman", can be abbreviated.
#'
#' @return a data frame of overall summary per questions
#'
#' @export
#'
#' @examples
#' # Prepare
#' grades_df_preped <- prep_grades_report(grades_df)
#'
#' # Question Summary
#' summary_questions(grades_df_preped)
summary_questions <- function(data,
                              cor_method = c("pearson", "kendall", "spearman")
){

  # Validate
  stopifnot_GradesReport(data)

  # Question's Max Setting to Data Frame
  q_no_max_df <- attr(data, "quiz_setting")[["questions_max"]] %>%
    tibble::enframe("Questions", "max_setting")
  # Quiz Max Setting
  gr_max <- attr(data, "quiz_setting")[["grade_max"]]

  # Calc Item Statistic (including `Difficulty_Index`)
  q_stats_df <- questions_stats(data,
                                show = c("n", "min", "max", "mean", "SD")) %>%
    ## Join with Setting's Maximum of Each Questions
    dplyr::left_join(q_no_max_df, by = "Questions") %>%
    dplyr::relocate("max_setting", .after = "max") %>%
    ## Item Difficulty Index
    dplyr::mutate(Difficulty_Index = mean/max_setting)

  # Calc Item Discrimination
  items_discrim_df <- item_discrim(data,
                                   cor_method = cor_method,
                                   conf.level = 0.95) %>%
    # Select some cols
    dplyr::select(Questions, Discrimination_Index = estimate, p.value, p.signif)

  # Join to Table
  dplyr::left_join(q_stats_df, items_discrim_df, by = "Questions")

}

# Question Stats ----------------------------------------------------------


#' Question Stats of Moodle Grade Report
#'
#' @description Calculate summary statistics for each questions of [Moodle Grade Report](https://docs.moodle.org/311/en/Quiz_reports#Grades_report) (See **Details**).
#'
#' @details [questions_stats()] calculate grouped summary statistics by questions ("Q").
#' You can specify which parameters to calculate by `show` argument.
#'
#' @param data (GradesReport) A data frame of class "GradesReport"
#' @param show If `NULL`, show every parameters.
#' Otherwise, specify which summary statistics you want to show as a character vector, any of:
#' "n", "min", "max", "median", "Q1", "Q3", "IQR", "MAD", "mean", "SD", "skewness", and "kurtosis" (for *excess* kurtosis).
#'
#' @return a data frame of summary statistics
#' @export
#'
#' @examples
#' library(moodleStats)
#' # Prepare
#' grades_df_preped <- prep_grades_report(grades_df)
#'
#' # Calculate
#' questions_stats(grades_df_preped, show = c("n", "min", "max", "mean"))
questions_stats <- function(data,
                            show = NULL
){


  # Validate
  stopifnot_GradesReport(data)
  # Pivot
  df_long <- data %>%
    tidyr::pivot_longer(cols = tidyselect::starts_with("Q"),
                        names_to = "Questions", values_to = "Mark")
  # Summary Stats
  df_long %>%
    dplyr::group_by(Questions) %>%
    summarise_stats_var(Mark, show = show)

}

# Item Discrimination (r) -------------------------------------------------


#' Item Discrimination of Moodle Grade Report
#'
#' @description
#' Calculate [Item Discrimination Index](https://www.proftesting.com/test_topics/steps_9.php) of [Moodle Grade Report](https://docs.moodle.org/311/en/Quiz_reports#Grades_report)
#' (see **Details**).
#'
#' @details
#' **Item discrimination index (r)** is a measure of how well an item is able to distinguish between examinees who are knowledgeable and those who are not.
#' It is a pairwise **point-biserial correlation** between the *score of each questions* ("Q" columns) and *total score of the quiz* ("Grade" column).
#'
#' [item_discrim()] calculate the correlation by [stats::cor.test()] function using Pearson's correlation coefficient (by default),
#' then summarize each parameters into a data frame by [broom::tidy()]. Different types of correlation can be specified by `cor_method` argument.
#'
#' @param data (GradesReport) A data frame of class "GradesReport"
#' @param cor_method (Character) A character string indicating which correlation coefficient is to be used for the test. One of "pearson", "kendall", or "spearman", can be abbreviated.
#' @param conf.level (Numeric) Confidence level for the returned confidence interval. Currently only used for the Pearson product moment correlation coefficient if there are at least 4 complete pairs of observations.
#'
#' @return A data frame of Item Discrimination Index for each questions.
#' @export
#'
#' @references
#' * What is [Item Discrimination Index](https://www.proftesting.com/test_topics/steps_9.php).
#'
#' @examples
#' library(moodleStats)
#' # Prepare
#' grades_df_preped <- prep_grades_report(grades_df)
#'
#' # Calculate
#' item_discrim(grades_df_preped)
item_discrim <- function(
    data,
    cor_method = c("pearson", "kendall", "spearman"),
    conf.level = 0.95
){

  # Validate
  stopifnot_GradesReport(data)
  # Pivot
  df_long <- data %>%
    tidyr::pivot_longer(cols = tidyselect::starts_with("Q"),
                        names_to = "Questions", values_to = "Mark")
  # Nest by Questions
  df_nested <- df_long %>%
    dplyr::group_by(Questions) %>%
    dplyr::group_nest()

  # Compute Correlation btw "Mark" and "Grade"
  df_nested %>%
    dplyr::mutate(cor = purrr::map(
      data,
      ~ stats::cor.test(.x[["Mark"]], .x[["Grade"]],
                        method = cor_method, conf.level = conf.level
      )
    )) %>%
    dplyr::mutate(tidied = purrr::map(cor, broom::tidy)) %>%
    dplyr::select(-data, -cor) %>%
    tidyr::unnest(cols = tidied) %>%
    # Add Signif
    rstatix::add_significance(p.col = "p.value", output.col = "p.signif")


}

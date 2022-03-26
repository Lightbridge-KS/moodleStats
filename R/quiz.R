


# Summary Quiz ------------------------------------------------------------


#' Quiz Summary of Moodle Grade Report
#'
#' @description Calculate quiz summary statistics of [Moodle Grade Report](https://docs.moodle.org/311/en/Quiz_reports#Grades_report) (See **Details**).
#'
#' @details [summary_quiz()] is a generic function that calculate quiz summary statistics
#' of "GradesReport" data frame.
#'
#' The result is one row data frame with the following columns:
#' * \strong{n}: number of students in the quiz
#' * \strong{min}: student's minimum score
#' * \strong{max}: student's maximum score
#' * \strong{max_quiz}: maximum score possible (from the quiz setting)
#' * \strong{median}: student's median score
#' * \strong{Q1}: 1st quartile of student's score (see [stats::quantile()])
#' * \strong{Q3}: 3rd quartile of student's score (see [stats::quantile()])
#' * \strong{IQR}: Interquartile range of student's score (see [stats::IQR()])
#' * \strong{MAD}: Median Absolute Deviation of student's score (see [stats::mad()])
#' * \strong{mean}: student's mean score
#' * \strong{SD}: standard deviation of student's score
#' * \strong{skewness}: a measure of asymmetry, \emph{positive} values indicate that the tail is on the \emph{right}, whereas \emph{negative} values indicate that the tail is on the \emph{left}  (see [moments::skewness()]).
#' * \strong{kurtosis}: \emph{excess kurtosis}, \emph{positive} values (leptokurtic) indicate that score distribution has a \emph{fatter} tails (more outliers), whereas \emph{negative} values (platykurtic) indicate that score distribution has a \emph{thinner} tails (less outliers).
#'   Please note that `excess kurtosis = kurtosis - 3`. (see [moments::skewness()] for Pearson's measure of kurtosis).
#' * \strong{Cronbach_Alpha}: a measure of internal consistency reliability of quiz. It is an average correlation of all question's score ("Q" column). Higher value indicates good overall correlation, and vice versa. (see [DescTools::CronbachAlpha()])
#'
#' @seealso
#' * [summary_questions()] for question's summary statistics.
#'
#' @param data (GradesReport) A data frame of class "GradesReport" (May expand this to other class in the future)
#'
#' @return a one-row data frame of quiz summary statistics
#' @export
#'
#' @examples
#' # Prepare Quiz
#' grades_df_preped <- prep_grades_report(grades_df)
#'
#' # Quiz Summary Statistics
#' summary_quiz(grades_df_preped)
summary_quiz <- function(data){
  UseMethod("summary_quiz")
}


# Method: GradesReport ----------------------------------------------------



#' @export
summary_quiz.GradesReport <- function(data){

  # Check Duplicate Name (or not)
  check_duplicated_Name(data)
  # Setting Max Grade
  gr_max_setting <- attr(data, "quiz_setting")[["grade_max"]]

  # Summarize Quiz Stats from "Grade" column
  stats_gr_dfr <- summarise_stats_var(data, "Grade")

  # Cronbach Alpha
  alpha <- data %>%
    dplyr::select(tidyselect::starts_with("Q")) %>%
    DescTools::CronbachAlpha(na.rm = TRUE, conf.level = NA)

  # Bind Cols
  out_dfr <- dplyr::bind_cols(
    stats_gr_dfr[ ,1:3],
    list(max_quiz = gr_max_setting),
    stats_gr_dfr[ ,4:length(stats_gr_dfr)],
    list(Cronbach_Alpha = alpha)
  )

  out_dfr

}


# Check Duplicate "Name" --------------------------------------------------


#' Check Duplicate "Name"
#'
#' @param data Moodle Quiz Report to Test
#' @param quiet `TRUE` not display message
#'
#' @return a message if found duplication in "Name" column
#' @noRd
check_duplicated_Name <- function(data, quiet = FALSE){

  dup_lgls <- duplicated(data[["Name"]])
  dup_no <- sum(dup_lgls, na.rm = TRUE)
  dup_name <- any(dup_lgls)

  if(dup_name && !quiet){
    message("Found ", dup_no, " duplicated student name in `Name` column, please interprete the result carefully.")
  }

}

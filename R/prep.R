

# Prepare: Grades Report --------------------------------------------------


#' Prepare Moodle Grades Report for Analysis
#'
#' @description
#' Prepare a [Moodle Grades Report](https://docs.moodle.org/311/en/Quiz_reports) data frame
#' for further analysis (see **Details**).
#'
#' @details
#' Steps to prepare a [Moodle Grades Report](https://docs.moodle.org/311/en/Quiz_reports) data frame:
#' * Clean some column names.
#' * Get rid of the last row which contains "Overall average".
#' * Join "First name" and "Surname" into "Name" by `sep_name`.
#' * Format "Grade/x.xx" column to numeric ("Not yet graded" and "-" will be `NA`).
#' * Format "Q. x /x.xx" column to numeric ("Requires grading" and "-" will be `NA`).
#' * Rename and format `Started on` to `Started` column with "POSIXct" class.
#' * Filter a "State" column by `choose_state`.
#' * Filter a "Grade" column by `choose_grade` (after `choose_state` has been applied).
#' * Filter a "Started on" or "Started" column by `choose_time` (after `choose_grade` has been applied).
#'
#'
#' @param data (Data Frame) A data frame of [Moodle Grades Report](https://docs.moodle.org/311/en/Quiz_reports)
#' @param sep_name (Character) Separator of "First name" and "Surname" column.
#' @param choose_state (Character) Options to filter a "State" column, must be one of:
#' * \strong{Finished:} (default) choose only the "Finished" attempts.
#' * \strong{In progress:} choose only the "In progress" attempts.
#' * \strong{all:} no filter applied, choose all attempts.
#' @param choose_grade (Character) Options to filter a "Grade/x.xx" column, must be one of:
#' * \strong{max:} (default) choose attempts that has maximum score of each students
#' * \strong{min:} choose attempts that has minimum score of each students
#' * \strong{all:} no filter applied, choose all attempts.
#' @param choose_time (Character) Options to filter a "Started on" or "Started" column, must be one of:
#' * \strong{first:} (default) choose the first attempt of each students
#' * \strong{last:} choose the last attempt of each students
#' * \strong{all:} no filter applied, choose all attempts.
#'
#' @return A cleaned and (optionally) filtered data frame with class "GradesReport" and "MoodleQuizReport".
#' @export
#'
#' @examples
#' prep_grades_report(grades_df)
prep_grades_report <- function(data,
                               sep_name = " ",
                               choose_state = c("Finished", "In progress", "all"),
                               choose_grade = c("max", "min", "all"),
                               choose_time = c("first", "last", "all")
){

  choose_state <- rlang::arg_match(choose_state)
  choose_grade <- rlang::arg_match(choose_grade)
  choose_time <- rlang::arg_match(choose_time)

  ## Validate Grades Report
  stopifnot_grades_report(data)

  # Extract Attributes
  ## Quiz Maximum Grades
  gr_max <- get_setting_grade_max(data)
  ## Question Number & Maximum Score
  q_no_max <- get_setting_questions_no_max(data)

  # Clean
  df_cleaned <-
    ## Base Cleaning
    proc_clean_quiz(
      data = data,
      sep_name = sep_name,
      force_gr_numeric = TRUE
    ) %>%
    ## Extra Clean for Grades Report
    proc_clean_gr(force_q_numeric = TRUE)

  # Filter State & Grade
  df_filtered <- df_cleaned %>%
    proc_filter_State_col(choose_state = choose_state) %>%
    proc_filter_Grade_col(choose_grade = choose_grade) %>%
    proc_filter_Started_col(choose_time = choose_time)

  # Set Class & Attributes
  df_out <- df_filtered %>%
    create_MoodleQuizReport(gr_max = gr_max) %>%
    create_GradesReport(q_no_max = q_no_max,
                        filter_by = list(state = choose_state,
                                         grade = choose_grade,
                                         time = choose_time)
    )

  df_out

}

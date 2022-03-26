

#' Get Moodle Quiz Metadata
#'
#' Display Moodle quiz report metadata to R console.
#'
#' This function displays
#' * \strong{Moodle Quiz Setting:} a quiz setting in Moodle such as maximum grades possible of the quiz
#' and maximum score possible of each question (if it is a Moodle Grades Report).
#' * \strong{Data Frame Filtering:} If Moodle Quiz was passed to `prep_` function family,
#' this will show what filters have been applied to the data frame.
#'
#' @param data a Moodle Quiz Report data frame
#'
#' @return Information printed to R console, and a list that has elements corresponding to each information (invisibly).
#' @export
#'
#' @examples
#' # Quiz Settings
#' quiz_meta(grades_df)
#' # Quiz Settings with Filtering
#' grades_df_preped <- prep_grades_report(grades_df)
#' quiz_meta(grades_df_preped)
quiz_meta <- function(data) {

  q_meta <- list(
    quiz_setting = get_quiz_setting(data),
    filter_by = get_filter_by(data)
  )
  new_MoodleQuizMeta(q_meta)
}


# Print: MoodleQuizMeta ---------------------------------------------------



#' @export
print.MoodleQuizMeta <- function(x, ...){

  q_set <- x[["quiz_setting"]]
  q_filt_by <- x[["filter_by"]]

  # Quiz Setting
  gr_max <- q_set[["grade_max"]]

  cli::cli_h2("Moodle Quiz Setting")
  cli::cli_li("Maximum grades of quiz: {.strong {.field {gr_max}}}")

  if ("questions_max" %in% names(q_set)) {
    q_no_max <- q_set[["questions_max"]]
    cli::cli_li("Maximum score of questions:")
    cli::cli_text("\n")
    print(q_no_max)
  }
  # Quiz Filter by
  if(!is.null(q_filt_by)){

    state <- q_filt_by[["state"]]
    grade <- q_filt_by[["grade"]]
    time <- q_filt_by[["time"]]

    cli::cli_h2("Data Frame Filtering")
    cli::cli_text("Data frame was filtered by the following orders:")
    cli::cli_ol(c("Choose {.val {state}} responses by 'State' column.",
                  "Choose {.field {grade}} grades of each students.",
                  "Choose {.field {time}} attempt(s) of each student by 'Started on' column."
    ))
  }
  invisible(x)
}

# Get filter_by -----------------------------------------------------------


#' Get filter by attribute
#'
#' get `filter_by` attribute
#'
#' @param data any data
#'
#' @return If `data` is "GradesReport", return `filter_by` attribute
#' @noRd
get_filter_by <- function(data) {

  q_meta <- if (is_GradesReport(data)) {
    attr(data, "filter_by")
  } else {
    NULL
  }
  q_meta
}

# Get Quiz Setting --------------------------------------------------------


#' Get Moodle Quiz Setting
#'
#' Get moodle quiz report settings such as maximum "Grade" possible of the quiz
#' and maximum score possible for each questions.
#'
#' @param data A Moodle quiz report data frame.
#'
#' @return Return list of the followings:
#' * \strong{grade_max:} maximum grade of the quiz
#' * \strong{questions_max:} (Maybe) numeric vector of maximum score of each questions.
#' @noRd
get_quiz_setting <- function(data){

  q_set <- if (is_MoodleQuizReport(data)) {
    # If is MoodleQuizReport object just get attribute (Faster)
    attr(data, "quiz_setting")
  } else if(is_grades_report(data)){
    # If grade report get grade max & question max
    list(
      grade_max = get_setting_grade_max(data),
      questions_max = get_setting_questions_no_max(data)
    )
  } else if(is_responses_report(data)){
    # If response report, just get grade max
    list(
      grade_max = get_setting_grade_max(data)
    )
  } else {
    stop("`data` must be a Moodle Quiz Report.", call. = FALSE)
  }
  q_set
}






# Get Max Grades ----------------------------------------------------------



#' Get Maximum Grade of Quiz Settting
#'
#' Get a maximum grade setting of any Moodle quiz report.
#'
#' @param df_raw A data.frame of Moodle Quiz report
#'
#' @return Numeric vector of length 1 indicate maximum quiz grade
#' @noRd
#'
get_setting_grade_max <- function(df_raw) {

  # Every moodle report has Maximum Grade in Grade column name
  nm <- names(df_raw)
  gr_colnm <- stringr::str_subset(nm, "Grade")
  # Extract digits (including decimal)
  max_gr <- stringr::str_extract(gr_colnm, "[:digit:]+\\.?[:digit:]*")
  as.numeric(max_gr)

}


# Questions Number & Max --------------------------------------------------


#' Get Question Number & Maximum Score
#'
#' For Moodle Grades file, get a question's maximum score corresponding to question's number.
#'
#' @param df_gr A data.frame of Moodle Grades report
#'
#' @return A numeric vector represents maximum score of each questions
#' @noRd
#'
get_setting_questions_no_max <- function(df_gr) {

  nm <- names(df_gr)
  q_colnm <- stringr::str_subset(nm, "Q\\.")
  # Question No: Extract first set of digits before /
  q_number <- as.integer(stringr::str_extract(q_colnm, "[:digit:]+"))
  # Question Max: Extract everything after /
  q_max <- as.numeric(stringr::str_extract(q_colnm, "(?<=/)(.+)"))

  names(q_max) <- paste0("Q", q_number)
  q_max
}

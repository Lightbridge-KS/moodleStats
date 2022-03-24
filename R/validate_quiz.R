

# Column Regex -------------------------------------------------------------



#' Regular Expression to Match Moodle Quiz Column Names
#'
#' @return A list of Regex
#' @noRd
report_col_regex <- function() {

  regex_check_Q_cols <- stringr::regex(
    # Q followed by dot; digits; back slash; digits and then may be dot with digits
    "Q\\.[:blank:]*\\d+[:blank:]*/[:blank:]*\\d+\\.?\\d*"
  )
  # Return list of Regex
  list(
    quiz_report = c("Surname", "First name", "Email address", "State"),
    grades_report = c(
      "Surname", "First name", "Email address", "State",
      "Grade", regex_check_Q_cols
    ),
    responses_report = c("Surname", "First name", "Email address", "State", "Response")
  )
}


# Test: Quiz Report -------------------------------------------------------



#' Stop if it is not Moodle Quiz Report
#'
#' @param data A data frame to test
#'
#' @return If not pass Error, else `NULL`
#' @noRd
stopifnot_quiz_report <- function(data){

  if(!is_quiz_report(data)) stop("`data` must be a moodle quiz report.", call. = F)
  invisible()
}


#' Is it Moodle Quiz Report
#'
#' Testing by column names
#'
#' @param data A data frame to test
#'
#' @return logical
#' @noRd
is_quiz_report <- function(data) {

  if(!is.data.frame(data)) stop("`data` must be a data.frame", call. = F)
  all(is_regex_in_names(data, report_col_regex()[["quiz_report"]]))
}



# Test: Grades Report -----------------------------------------------------


#' Stop if it is not Moodle Grades Report
#'
#' @param data A data frame to test
#'
#' @return If not pass Error, else `NULL`
#' @noRd
stopifnot_grades_report <- function(data){

  if(!is_grades_report(data)) stop("`data` must be a moodle grades report.", call. = F)
  invisible()
}

#' Is it Moodle Grades Report
#'
#' Testing by column names
#'
#' @param data A data frame to test
#'
#' @return logical
#' @noRd
is_grades_report <- function(data) {

  if(!is.data.frame(data)) stop("`data` must be a data.frame", call. = F)
  all(is_regex_in_names(data, report_col_regex()[["grades_report"]]))

}

# Test: Reponse Report ----------------------------------------------------

#' Stop if it is not Moodle Response Report
#'
#' @param data A data frame to test
#'
#' @return If not pass Error, else `NULL`
#' @noRd
stopifnot_responses_report <- function(data){

  if(!is_responses_report(data)) stop("`data` must be a moodle responses report.", call. = F)
  invisible()
}

#' Is it Moodle Response Report
#'
#' Testing by column names
#'
#' @param data A data frame to test
#'
#' @return logical
#' @noRd
is_responses_report <- function(data) {

  if(!is.data.frame(data)) stop("`data` must be a data.frame", call. = F)
  all(is_regex_in_names(data, report_col_regex()[["responses_report"]]))

}


# Helper: Is Regex in Names -----------------------------------------------



#' Is Regular Expressions presented in object names
#'
#' Vectorized testing for regular expressions.
#' Are all of the regular expression can be matched to any object names or not?
#'
#' @param x An object to test
#' @param regex Character vector, specify regular expressions
#' @param verbose If `TRUE`, message you that in which components of the object names is/are not match by `regex`
#'
#' @return Logical, if `TRUE` all of the `regex` can be matched to at least one element of names of `x`.
#' @noRd
#'
is_regex_in_names <- function(x,
                              regex,
                              verbose = FALSE
){

  nm <- names(x)
  lgl_ls <- purrr::map(nm, ~stringr::str_detect(.x, regex))
  lgl_ls_t <- purrr::map(purrr::transpose(lgl_ls), ~unlist(.x, recursive = F))
  lgl_vctr <- purrr::map_lgl(lgl_ls_t, any)

  if(verbose && !all(lgl_vctr)){
    no_match <- regex[which(!lgl_vctr)]
    message("The following `regex` not presented in `x`:")
    print_messages(no_match, sep = ", ", prefix = "'", suffix = "'")
  }

  lgl_vctr

}

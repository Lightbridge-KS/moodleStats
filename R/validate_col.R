

# Is some Grade Numeric ---------------------------------------------------



#' Is some Grade Numeric
#'
#' Test whether there are any numeric values in "Grade_xx" column
#'
#' @param data a Moodle Quiz Report Data Frame
#'
#' @return `TRUE` if found some numeric digits, else `FALSE`
#' @noRd
is_some_grade_numeric <- function(data){

  data %>%
    dplyr::select(tidyselect::starts_with("Grade")) %>%
    unique() %>%
    dplyr::pull() %>%
    # Detect one or more digits
    stringr::str_detect("[:digit:]+") %>%
    any()

}


#' Is some Grade "Not yet graded"
#'
#' Detect whether any "Not yet graded" presented in the "Grade_xx" column
#'
#' @param data a Moodle Quiz Report Data Frame
#'
#' @return `TRUE` if found any "Not yet graded", else `FALSE`
#' @noRd
is_some_grade_nyg <- function(data){

  data %>%
    dplyr::select(tidyselect::starts_with("Grade")) %>%
    unique() %>%
    dplyr::pull() %>%
    # Detect any "Not yet graded"
    stringr::str_detect("Not yet graded") %>%
    any()

}



# MoodleQuizReport --------------------------------------------------------


#' Create MoodleQuizReport
#'
#' Create "MoodleQuizReport" object from a Moodle Quiz Report Data.Frame(Validated)
#' and set "quiz_setting" attribute
#'
#' @param x A data frame of Moodle Quiz Report
#' @param gr_max Maximum grade of the Quiz. If `NULL`, default, will get from the Grades column.
#'
#' @return "MoodleQuizReport" object with "quiz_setting" attribute
#' @noRd
create_MoodleQuizReport <- function(x,
                                    gr_max = NULL
){
  stopifnot(is_quiz_report(x)) # Validate

  x <- new_MoodleQuizReport(x) # Append Class
  # Set Attribute
  attr(x, "quiz_setting") <- if(is.null(gr_max)){
    # If not supply `gr_max`, get it from raw df
    list(grade_max = get_setting_grade_max(x))
  } else {
    list(grade_max = gr_max)
  }

  x
}

#' New MoodleQuizReport
#'
#' Append "MoodleQuizReport" class to existing Data Frame
#'
#' @param x a data.frame
#'
#' @return "MoodleQuizReport" object
#'
#' @noRd
new_MoodleQuizReport <- function(x = data.frame()){

  stopifnot(is.data.frame(x))

  if(inherits(x, "MoodleQuizReport")) return(x) # Already inherits: return

  # Assign "MoodleQuizReport" as child
  class(x) <- c("MoodleQuizReport", class(x))
  x

}

#' Check if object is MoodleQuizReport
#'
#' @param x object
#'
#' @return logical
#' @noRd
is_MoodleQuizReport <- function(x){
  inherits(x, "MoodleQuizReport")
}



# GradesReport ------------------------------------------------------------



#' Create GradesReport
#'
#' 1.  Validate grades report
#' 2.  Append "GradesReport" class to existing "MoodleQuizReport"
#' 3.  Add "questions_max" to "quiz_setting" attribute
#'
#' @param x a MoodleQuizReport data.frame
#' @param q_no_max (Numeric vector) Maximum score of each question with
#' names corresponding to question number. If `NULL` (default), get from input data frame.
#'
#' @return An object of "GradesReport" subclass of class "MoodleQuizReport"
#' with "quiz_setting" attribute which have
#' * $grade_max
#' * $questions_max
#' @noRd
create_GradesReport <- function(x, q_no_max = NULL){

  # Validate
  stopifnot(is_grades_report(x))
  x <- new_GradesReport(x)
  # Append list element "questions_max" to "quiz_setting" attribute
  attr_old <- attr(x, "quiz_setting")

  ## If not provide `q_no_max` assume `x` is raw_gr_df and get it
  ls <- if(is.null(q_no_max)){
    list(questions_max = get_setting_questions_no_max(x))
  } else {
    list(questions_max = q_no_max)
  }

  attr(x, "quiz_setting") <- append(attr_old, ls)
  x

}


#' New GradesReport
#'
#' Append "GradesReport" to existing "MoodleQuizReport" class
#'
#' @param x a MoodleQuizReport data.frame
#'
#' @return object of sub-class "GradesReport" of class "MoodleQuizReport"
#' @noRd
new_GradesReport <- function(x){

  # Check Class: must be data.frame and "MoodleQuizReport" class
  stopifnot(is.data.frame(x), inherits(x, "MoodleQuizReport"))
  if(inherits(x, "GradesReport")) return(x) # Already inherits: return
  # Assign "GradesReport" as child
  class(x) <- c("GradesReport", class(x))
  x

}

#' IS GradesReport
#'
#' @param x object
#'
#' @return logical
#' @noRd
is_GradesReport <- function(x){
  inherits(x, "GradesReport")
}

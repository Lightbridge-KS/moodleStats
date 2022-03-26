
#' Get path to moodleStats example
#'
#' moodleStats comes bundled with a number of sample files in its `inst/extdata`
#' directory. This function make them easy to access
#'
#' @param file Name of file. If `NULL`, the example files will be listed.
#' @export
#' @examples
#' library(moodleStats)
#' moodleStats_example()
#' moodleStats_example("grades_report.csv")
moodleStats_example <- function(file = NULL) {

  if (is.null(file)) {
    dir(system.file("extdata", package = "moodleStats"))

  } else {
    system.file("extdata", file, package = "moodleStats", mustWork = TRUE)
  }

}

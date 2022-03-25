

# Process: Clean Quiz -----------------------------------------------------


#' Process: Clean Moodle Quiz
#'
#' [proc_clean_quiz()]: A base cleaning for all moodle quiz report
#'   -  Filter out "Overall average" at the last row
#'   -  Unite first name & Surname
#'   -  Rename Email = "Email address", Started = "Started on"
#'   -  Discard "Completed" and "Time taken" (w/o trigger error if not already have)
#'   -  Reformat date-time (Started) to POSIXct
#'   -  if `force_gr_numeric = TRUE`: at column start with "G"
#'      -  format "Not yet graded" and "-" to `NA` then others to numeric
#'
#' @param data raw Moodle quiz report DF
#' @param sep_name (Character) Separating first name and surname
#' @param force_gr_numeric If `TRUE` format "Not yet graded" and "-" to `NA` then others to numeric
#'
#' @return A base cleaned DF
#' @noRd
proc_clean_quiz <- function(data,
                            sep_name = " ",
                            force_gr_numeric = TRUE
){

  df_cleaned_1 <- data %>%
    # Filter out "Overall average" in the last row of Grade report
    dplyr::filter(!is.na(State)) %>%
    # Unite - First & Surname
    tidyr::unite("First name", "Surname", col = "Name", sep = sep_name) %>%
    # Rename Some Column
    dplyr::rename(Email = "Email address", Started ="Started on") %>%
    # Discard "Completed" and "Time taken" (w/o trigger error if not already have)
    dplyr::select(!tidyselect::any_of(c("Completed", "Time taken"))) %>%
    # Reformat Stated Date to POSIXct
    dplyr::mutate(Started = lubridate::dmy_hm(Started))

  # Format "Grade" column to numeric; Even if it's "Not yet graded" or dashed
  if(force_gr_numeric){
    df_cleaned_1 <- df_cleaned_1 %>%
      dplyr::mutate(
        dplyr::across(tidyselect::starts_with("G"),
                      ~dplyr::na_if(.x, "Not yet graded")),
        dplyr::across(tidyselect::starts_with("G"),
                      ~dplyr::na_if(.x, "-")),
        dplyr::across(tidyselect::starts_with("G"), as.numeric)
      )
  }
  df_cleaned_1
}



# Process: Clean Grade Report ---------------------------------------------


#' Process: Clean Moodle Grades Report
#'
#' [proc_clean_gr()]: further cleaning for grades report
#'   -  clean "Grades xx" and "Q xx" column
#'   -  If `force_q_numeric = TRUE`: at column start with "Q"
#'     -  format "Requires grading" and "-" to `NA` then others to numeric
#'
#' @param df_cleaned a base-cleaned data frame
#' @param force_q_numeric If `TRUE`, format "Requires grading" and "-" to `NA` then others to numeric
#'
#' @return A cleaner data frame
#' @noRd
proc_clean_gr <- function(df_cleaned,
                          force_q_numeric = TRUE
){


  q_no_max <- get_setting_questions_no_max(df_cleaned)

  # Clean Grades & Q_xx column
  df_cleaned_gr <- df_cleaned %>%
    dplyr::rename_with(.fn = ~paste0("Grade"),
                       .cols = tidyselect::starts_with("Grade")
    ) %>%
    dplyr::rename_with(.fn = ~names(q_no_max),
                       .cols =  tidyselect::matches("Q\\."))

  # Format Q_xx column to numeric; Even if it's "Requires grading" or dashed
  if(force_q_numeric){
    df_cleaned_gr <- df_cleaned_gr %>%
      dplyr::mutate(
        dplyr::across(tidyselect::starts_with("Q"),
                      ~dplyr::na_if(.x, "Requires grading")),
        dplyr::across(tidyselect::starts_with("Q"),
                      ~dplyr::na_if(.x, "-")),
        dplyr::across(tidyselect::starts_with("Q"), as.numeric)
      )
  }

  df_cleaned_gr


}

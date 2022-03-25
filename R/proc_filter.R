

# Process: Filter State ---------------------------------------------------


#' Process: Filter State Column
#'
#' @param df_cleaned a cleaned Moodle Quiz DF (raw can be used as well)
#' @param choose_state A `State` column to filter by
#'
#' @return a filtered DF
#' @noRd
proc_filter_State_col <- function(df_cleaned,
                                  choose_state = c("Finished", "In progress", "all")
){

  choose_state <- rlang::arg_match(choose_state)

  if(choose_state == "all") return(df_cleaned)

  filt_expr <- switch (choose_state,
                       "Finished" = { rlang::expr(State == "Finished") },
                       "In progress" = { rlang::expr(State == "In progress") },
                       stop("`choose_state` must be one of 'Finished', 'In progress', 'all'")
  )

  df_cleaned %>%
    dplyr::filter(!!filt_expr)

}


# Process: Filter Grade col -----------------------------------------------



#' Process: filter Grade column
#'
#' @param df_cleaned A cleaned data frame
#' @param choose_grade type of grade to filter per student
#'
#' @return a filterd grade DF
#' @noRd
proc_filter_Grade_col <- function(df_cleaned,
                                  choose_grade = c("max", "min", "all")
) {

  choose_grade <- rlang::arg_match(choose_grade)
  # Get Grades Column name
  Grade_col <- stringr::str_subset(names(df_cleaned), "G") %>% rlang::sym()

  # Grouped filter by Score of each student
  filt_expr <- switch (choose_grade,
                       "max" = { rlang::expr(!!Grade_col == max(!!Grade_col)) },
                       "min" = { rlang::expr(!!Grade_col == min(!!Grade_col))},
                       "all" = { rlang::expr(!!Grade_col == !!Grade_col)},
                       stop("`choose_grade` must be one of 'max', 'min', 'mean', 'all'", call. = F)
  )

  df_cleaned %>%
    dplyr::group_by(Name) %>%
    dplyr::filter(!!filt_expr) %>%
    dplyr::ungroup()


}


# Process: Filter Started Column ------------------------------------------


#' Process: Filter time by Started column
#'
#' @param df_cleaned A cleaned data frame
#' @param choose_time choose attempt based on `Started` column
#'
#' @return a filterd time DF
#' @noRd
proc_filter_Started_col <- function(df_cleaned,
                                    choose_time = c("first", "last", "all")
){
  choose_time <- rlang::arg_match(choose_time)

  # Grouped filter by Started Time of each student
  filt_expr <- switch (choose_time,
                       "first" = { rlang::expr(Started == min(Started)) },
                       "last" = { rlang::expr(Started == max(Started)) },
                       "all" = { rlang::expr(Started == Started) },
                       stop("`choose_time` must be one of 'first', 'last', 'all'", call. = F)
  )

  df_cleaned %>%
    dplyr::group_by(Name) %>%
    dplyr::filter(!!filt_expr) %>%
    dplyr::ungroup()
}

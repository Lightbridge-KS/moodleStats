

# Summary Stats -----------------------------------------------------------


#' Summary Stats at Variable
#'
#' Calculate summary statistics paritcular variable into a data frame.
#'
#' @note "kurtosis" calculate *excess* kurtosis (kurtosis - 3).
#'
#' @param data a data frame
#' @param var (Quote or Unquote) a numeric variable
#' @param show (Character) character vector to choose type of stats. `NULL` choose all.
#' @param round_digits decimals to round, `NULL` for no round.
#'
#' @return a data.frame
#' @noRd
summarise_stats_var <- function(data,
                                var,
                                show = NULL, # Character Vector to Choose Expression
                                round_digits = NULL
) {

  if(!is.null(show)){
    show <- match.arg(show, c("n", "min", "max", "median",
                              "Q1", "Q3", "IQR", "MAD", "mean",
                              "SD", "skewness", "kurtosis"), several.ok = TRUE)
  }

  conf.level <- 0.95; alpha <- 1 - conf.level

  var <- rlang::ensym(var)
  ## Summary Expressions
  summary_exprs <- list(
    n = rlang::expr(sum(!is.na(!!var))),
    min = rlang::expr(min(!!var, na.rm = TRUE)),
    max = rlang::expr(max(!!var, na.rm = TRUE)),
    Q1 = rlang::expr(stats::quantile(!!var, 0.25, na.rm = TRUE)),
    median = rlang::expr(stats::median(!!var, na.rm = TRUE)),
    Q3 = rlang::expr(stats::quantile(!!var, 0.75, na.rm = TRUE)),
    IQR = rlang::expr(stats::IQR(!!var, na.rm = TRUE)),
    MAD = rlang::expr(stats::mad(!!var, na.rm = TRUE)),
    mean = rlang::expr(mean(!!var, na.rm = TRUE)),
    SD = rlang::expr(stats::sd(!!var, na.rm = TRUE)),
    skewness = rlang::expr(moments::skewness(!!var, na.rm = TRUE)),
    kurtosis = rlang::expr(moments::kurtosis(!!var, na.rm = TRUE) - 3)
  )

  if(!is.null(show)){
    ## Select Subset of Expression by Name
    summary_exprs <- summary_exprs[show]
  }

  ## Summary Stats to 1 row
  summary_row <- data %>%
    dplyr::summarise(!!!summary_exprs)

  if(is.null(round_digits)) return(summary_row)

  summary_row %>%
    purrr::modify(~round(.x, digits = round_digits))
}



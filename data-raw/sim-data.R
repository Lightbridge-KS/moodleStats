## code to prepare `sim-data` dataset goes here


# Simulate Moodle Quiz Report ---------------------------------------------


#' Simulate Moodle Quiz Report
#'
#' Providing real Moodle Quiz Report,
#' This function replace `First name`, `Surname`, and `Email address` with the fake one.
#' If multiple attempt is allowed, this function can simulate the same person with new same person.
#'
#' @param data_raw (Data Frame) Real raw Moodle Quiz Report Data Frame
#' @param seed seed to generate
#'
#' @return a Data Frame with new `First name`, `Surname`, and `Email address`
#' @export
#'
#' @examples
sim_moodleQuiz <- function(data_raw, seed = 1) {

  last_row <- data_raw[nrow(data_raw), ] # Last Row has "Overall average"
  data_student <- data_raw[1:(nrow(data_raw) - 1), ] # Not Last Rows

  set.seed(seed = seed)

  data_student %>%
    # Replace Names
    dplyr::mutate(
      Surname = replace_randomNames(Surname, which.names = "last"),
      `First name` = replace_randomNames(`First name`, which.names = "first")
    ) %>%
    # Simulate Email
    dplyr::mutate(
      `Email address` = sim_email_student(first = `First name`, last = Surname)
    ) %>%
    # Remove everything in "Institution" and "Department"
    dplyr::mutate(
      Institution = rep(NA, nrow(data_student)),
      Department = rep(NA, nrow(data_student)),
    ) %>%
    # Bind Last Row
    dplyr::bind_rows(last_row)

}


# Replace Name by RandomNames ---------------------------------------------



#' Replace Names by another Random Names
#'
#' Replace names vector by another random names vector, using [`randomNames::randomNames()`]
#' If there are more than one record of the same names, output names will also match that duplicated names.
#'
#' @param x (Character vector) Old names to replace
#' @param which.names OPTIONAL. One of "both" (the default), "first", or "last", "complete.data" indicating what names to produce. "complete.data" provides a data.table with ethnicity and gender codes.
#' @param gender OPTIONAL. A vector indicating the genders for the names to be calculated. The maximum of n, the length of gender and the length of ethnicity is the number of random names returned. Note that the gender vector is only employed for deriving first names. If no gender vector is provided, the function randomly samples from both genders to produce a sample of names. Current gender codes are 0: Male and 1: Female. See examples for various use cases.
#' @param ethnicity OPTIONAL. A vector indicating the ethnicities for the names to be calculated. The maximum of n, the length of gender and the length of ethnicity is the number of random names returned. Note that the ethnicity vector is employed for both deriving first and last names. If no ethnicity vector is provided the function samples from all ethnicity to produce a sample of names.
#' @param name.order OPTIONAL. If which.names is "both", then names can be returned as either "last.first" (the default) or "first.last".
#' @param name.sep OPTIONAL. If which.names is "both", then names are separated by the name.sep string provided. Defaults to comma-space separated.
#'
#' @return
#' @export
#'
#' @examples
replace_randomNames <- function(x,
                                which.names = "both",
                                gender,
                                ethnicity,
                                name.order,
                                name.sep) {
  # Unique Names with remove NA
  x_unique <- as.character(na.omit(unique(x)))
  n_unique <- length(x_unique)

  # Sampling New Unique Names with the same length
  y_unique <- randomNames::randomNames(n_unique,
                                       which.names = which.names,
                                       gender,
                                       ethnicity,
                                       name.order="last.first",
                                       name.sep=", ",
                                       sample.with.replacement = FALSE)
  # Encode to Original
  encoder(x, x_unique, y_unique)
}


#' Simulate Email from First and Last Name
#'
#'
#' @param first (Character vector) First Name
#' @param last (Character vector) Last Name
#' @param id_format (Character) sprintf format of `id`
#' @param email_format (Character) {glue} output of email
#'
#' @return a character vector
#' @export
#'
#' @examples
sim_email_student <- function(first,
                              last,
                              id_format = "%03d",
                              email_format = "{first}.{last3}_{id}@example.com"
){
  # Change Case
  first <- tolower(first)
  last <- tolower(last)

  # First & Last Name Combination
  firstlast <- paste(first, last)

  # ID number
  id <- encoder(
    firstlast,
    unique(firstlast),
    sample(sprintf(id_format, seq_along(unique(firstlast))),
           replace = FALSE
    )
  )
  # Subset first 3 alphabetical character of last name
  last3 <- stringr::str_sub(stringr::str_extract(last, "[:alpha:]+"), 1, 3)

  # Build Email
  as.character(glue::glue(email_format))
}


# Helper: Encoder ----------------------------------------------------------


#' Encode Vector
#'
#' @description Match and Encode vector
#' @param x vector: input data to be matched.
#' @param match vector: matching value to `x`
#' @param encode vector: encoding vector same length as `match`
#' @param nomatch Character: Indicate result if elements in `x` was not matched with `match`.
#' It must be one of:
#' * \strong{"NA"}: return `NA`
#' * \strong{"original"}: return original elements in `x`
#'
#' @return encoded vector
#' @details Elements that not match will return values according to `nomatch`.
#' @export
#'
#' @examples
#' encoder(c("a","b","d"), c("a","b","c"), c("A","B","C"))
#' encoder(c("a","b","d"), c("a","b","c"), c("A","B","C"), nomatch = "original")
encoder <- function(x, # Any vector
                    match,
                    encode = match, # Encode that pair with match
                    nomatch = c("NA", "original")
) {

  nomatch <- match.arg(nomatch)
  if(length(match) != length(encode)) stop("`match` and `encode` must have same length", call. = F)

  index <- match(x, match)
  encoded_may_NA <- encode[index]

  # Control no matching cases
  out <- switch (nomatch,
                 # Leaves as `NA`
                 "NA" = { encoded_may_NA },
                 # Use Original `x`
                 "original" = {
                   encoded_may_NA[is.na(encoded_may_NA)] <- x[is.na(encoded_may_NA)]
                   encoded <- encoded_may_NA
                   encoded
                 }
  )
  out
}



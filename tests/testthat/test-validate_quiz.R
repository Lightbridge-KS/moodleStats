



# Quiz Report Test --------------------------------------------------------



test_that("is_quiz_report() works",{

  expect_true(is_quiz_report(grades_df)) # Grades Report
  expect_true(is_quiz_report(moodleStats:::responses_df)) # Response Report (Internal)
  expect_false(is_quiz_report(iris)) # Not Quiz Report
  # Error
  expect_error(is_quiz_report(1:10) )

})

test_that("stopifnot_quiz_report() works",{
  # Return Invisible
  expect_invisible(stopifnot_quiz_report(grades_df))
  expect_invisible(stopifnot_quiz_report(moodleStats:::responses_df))
  # Error test
  expect_error(stopifnot_quiz_report(iris))
  expect_error(stopifnot_quiz_report(1:10))
})


# Grades Report -----------------------------------------------------------


test_that("is_grades_report() works",{
  # TRUE
  expect_true(is_grades_report(grades_df)) # Grades Report
  # FALSE
  expect_false(is_grades_report(moodleStats:::responses_df)) # Response Report (Internal)
  expect_false(is_grades_report(iris)) # Not Quiz Report
  # Error
  expect_error(is_grades_report(1:10))

})

test_that("stopifnot_grades_report() works",{
  # Return Invisible
  expect_invisible(stopifnot_grades_report(grades_df))
  # Error test
  expect_error(stopifnot_grades_report(moodleStats:::responses_df)) # Response Report
  expect_error(stopifnot_grades_report(iris))
  expect_error(stopifnot_grades_report(1:10))
})


# Responses Report --------------------------------------------------------

test_that("is_responses_report() works",{

  # TRUE
  expect_true(is_responses_report(moodleStats:::responses_df))
  # FALSE
  expect_false(is_responses_report(grades_df)) # Grades Report
  expect_false(is_responses_report(iris)) # Not Quiz Report
  # Error
  expect_error(is_responses_report(1:10))

})

test_that("stopifnot_responses_report() works",{
  # Return Invisible
  expect_invisible(stopifnot_responses_report(moodleStats:::responses_df))
  # Error test
  expect_error(stopifnot_responses_report(grades_df)) # Grades Report
  expect_error(stopifnot_responses_report(iris))
  expect_error(stopifnot_responses_report(1:10))
})


# Regex in Names ----------------------------------------------------------



test_that("test is_regex_in_names()",{

  x1 <- c(a1 = "A", b = "B")

  expect_equal(is_regex_in_names(x1, c("\\d+", "c")), c(TRUE, FALSE))

})

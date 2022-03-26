
<!-- README.md is generated from README.Rmd. Please edit that file -->

# moodleStats

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/Lightbridge-KS/moodleStats/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Lightbridge-KS/moodleStats/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

> A high-level R package for quiz & questions analysis of [Moodle Grades
> Report](https://docs.moodle.org/311/en/Quiz_reports#Grades_report)

## Installation

You can install the development version of moodleStats from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("Lightbridge-KS/moodleStats")
```

## Goal

The goal of this package it to provide a high-level functions for
analysis of [Moodle Grades
Report](https://docs.moodle.org/311/en/Quiz_reports#Grades_report) such
as calculation of **descriptive statistics** for quiz & questions, and
performingan **item analysis**.

## Quick Workflow

``` r
library(moodleStats)
```

### Read Data

Read Moodle Grades Report from `.csv` file into a Data Frame.

``` r
grades_df <- readr::read_csv(moodleStats_example("grades_report.csv"))
#> Rows: 461 Columns: 19
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> chr (17): Surname, First name, Email address, State, Started on, Completed, ...
#> lgl  (2): Institution, Department
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

``` r
dplyr::glimpse(grades_df)
#> Rows: 461
#> Columns: 19
#> $ Surname         <chr> "el-Taha", "al-Aydin", "Sawyer", "Snow", "al-Habib", "…
#> $ `First name`    <chr> "Joshua", "Tyler", "Michael", "Leeah", "Lawrence", "Is…
#> $ Institution     <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ Department      <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ `Email address` <chr> "joshua.el_025@example.com", "tyler.al_192@example.com…
#> $ State           <chr> "Finished", "Finished", "In progress", "Finished", "Fi…
#> $ `Started on`    <chr> "12 February 2021  1:03 PM", "12 February 2021  3:36 P…
#> $ Completed       <chr> "1 March 2021  3:35 AM", "28 February 2021  10:53 PM",…
#> $ `Time taken`    <chr> "16 days 14 hours", "16 days 7 hours", "-", "6 days 5 …
#> $ `Grade/9.00`    <chr> "5.00", "8.00", "-", "9.00", "6.00", "6.00", "-", "0.0…
#> $ `Q. 1 /1.00`    <chr> "1.00", "1.00", "-", "1.00", "1.00", "0.00", "-", "0.0…
#> $ `Q. 2 /1.00`    <chr> "1.00", "1.00", "-", "1.00", "1.00", "1.00", "-", "0.0…
#> $ `Q. 3 /1.00`    <chr> "0.00", "0.00", "-", "1.00", "0.00", "0.00", "-", "0.0…
#> $ `Q. 4 /1.00`    <chr> "0.00", "1.00", "-", "1.00", "1.00", "1.00", "-", "0.0…
#> $ `Q. 5 /1.00`    <chr> "1.00", "1.00", "-", "1.00", "0.00", "1.00", "-", "0.0…
#> $ `Q. 6 /1.00`    <chr> "0.00", "1.00", "-", "1.00", "1.00", "0.00", "-", "0.0…
#> $ `Q. 7 /1.00`    <chr> "1.00", "1.00", "-", "1.00", "1.00", "1.00", "-", "0.0…
#> $ `Q. 8 /1.00`    <chr> "1.00", "1.00", "-", "1.00", "0.00", "1.00", "-", "0.0…
#> $ `Q. 9 /1.00`    <chr> "0.00", "1.00", "-", "1.00", "1.00", "1.00", "-", "0.0…
```

### Prepare Data

Cleaning and filtering data can be done in 1 step using
`prep_grades_report()`

``` r
grades_df_preped <- prep_grades_report(grades_df,
                                       choose_state = "Finished", # 1. choose only "Finished" attempt
                                       choose_grade = "max", # 2. choose only the best score of each student
                                       choose_time = "first" # 3. choose the first time that student submitted
                                       ) 
dplyr::glimpse(grades_df_preped)
#> Rows: 272
#> Columns: 16
#> $ Name        <chr> "Joshua el-Taha", "Leeah Snow", "Isaiah el-Saleem", "Eric …
#> $ Institution <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ Department  <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ Email       <chr> "joshua.el_025@example.com", "leeah.sno_016@example.com", …
#> $ State       <chr> "Finished", "Finished", "Finished", "Finished", "Finished"…
#> $ Started     <dttm> 2021-02-12 13:03:00, 2021-02-21 20:09:00, 2021-02-23 19:5…
#> $ Grade       <dbl> 5, 9, 6, 0, 7, 4, 2, 5, 6, 8, 8, 3, 3, 5, 8, 9, 0, 5, 5, 7…
#> $ Q1          <dbl> 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0…
#> $ Q2          <dbl> 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1…
#> $ Q3          <dbl> 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1…
#> $ Q4          <dbl> 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1…
#> $ Q5          <dbl> 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0…
#> $ Q6          <dbl> 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1…
#> $ Q7          <dbl> 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1…
#> $ Q8          <dbl> 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1…
#> $ Q9          <dbl> 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1…
```

### Quiz Metadata

Show quiz metadata such as maximum settings of quiz and questions by
`quiz_meta()`

``` r
quiz_meta(grades_df_preped)
#> 
#> ── Moodle Quiz Setting ──
#> 
#> • Maximum grades of quiz: 9
#> • Maximum score of questions:
#> 
#> Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 
#>  1  1  1  1  1  1  1  1  1
#> 
#> ── Data Frame Filtering ──
#> 
#> Data frame was filtered by the following orders:
#>   1. Choose "Finished" responses by 'State' column.
#>   2. Choose max grades of each students.
#>   3. Choose first attempt(s) of each student by 'Started on' column.
```

### Quiz Summary

`summary_quiz()` calculates various quiz summary statistics, and combine
it into 1 row data frame.

``` r
quiz_report_df <- summary_quiz(grades_df_preped)
dplyr::glimpse(quiz_report_df)
#> Rows: 1
#> Columns: 14
#> $ n              <int> 272
#> $ min            <dbl> 0
#> $ max            <dbl> 9
#> $ max_quiz       <dbl> 9
#> $ median         <dbl> 7
#> $ Q1             <dbl> 5
#> $ Q3             <dbl> 9
#> $ IQR            <dbl> 4
#> $ MAD            <dbl> 2.9652
#> $ mean           <dbl> 6.702206
#> $ SD             <dbl> 2.219403
#> $ skewness       <dbl> -0.883699
#> $ kurtosis       <dbl> 0.07821787
#> $ Cronbach_Alpha <dbl> 0.7400243
```

### Question Summary and Item Analysis

``` r
question_report_df <- summary_questions(grades_df_preped)
```

Here is summary statistics for each questions.

``` r
question_report_df %>% 
  dplyr::select(Questions:SD)
#> # A tibble: 9 × 7
#>   Questions     n   min   max max_setting  mean    SD
#>   <chr>     <int> <dbl> <dbl>       <dbl> <dbl> <dbl>
#> 1 Q1          271     0     1           1 0.760 0.428
#> 2 Q2          269     0     1           1 0.941 0.237
#> 3 Q3          268     0     1           1 0.511 0.501
#> 4 Q4          269     0     1           1 0.822 0.384
#> 5 Q5          269     0     1           1 0.743 0.438
#> 6 Q6          269     0     1           1 0.684 0.466
#> 7 Q7          269     0     1           1 0.870 0.337
#> 8 Q8          267     0     1           1 0.708 0.456
#> 9 Q9          270     0     1           1 0.737 0.441
```

And, here is an **item analysis** for Moodle Grades Report.

-   **`Difficulty_Index`** is for **Item Difficulty Index (p)**, a
    measure of the *proportion* of examinees who answered the item
    correctly.
-   **`Discrimination_Index`** is for **Item Discrimination Index (r)**,
    a measure of how well an item is able to distinguish between
    examinees who are knowledgeable and those who are not. It is a
    pairwise *point-biserial correlation* between the score of each
    questions and total score of the quiz.

``` r
question_report_df %>% 
  dplyr::select(Questions, Difficulty_Index:p.value)
#> # A tibble: 9 × 4
#>   Questions Difficulty_Index Discrimination_Index  p.value
#>   <chr>                <dbl>                <dbl>    <dbl>
#> 1 Q1                   0.760                0.434 7.44e-14
#> 2 Q2                   0.941                0.452 6.15e-15
#> 3 Q3                   0.511                0.600 1.48e-27
#> 4 Q4                   0.822                0.510 3.52e-19
#> 5 Q5                   0.743                0.675 4.13e-37
#> 6 Q6                   0.684                0.646 3.26e-33
#> 7 Q7                   0.870                0.554 4.86e-23
#> 8 Q8                   0.708                0.640 3.59e-32
#> 9 Q9                   0.737                0.597 1.81e-27
```

------------------------------------------------------------------------

Last updated: 27 March 2022

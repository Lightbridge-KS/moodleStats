
<!-- README.md is generated from README.Rmd. Please edit that file -->

# moodleStats

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/Lightbridge-KS/moodleStats/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Lightbridge-KS/moodleStats/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/Lightbridge-KS/moodleStats/branch/main/graph/badge.svg)](https://app.codecov.io/gh/Lightbridge-KS/moodleStats?branch=main)
<!-- badges: end -->

> A high-level, ready-to-use R package for quiz & questions analysis of
> [Moodle Grades
> Report](https://docs.moodle.org/311/en/Quiz_reports#Grades_report)

# Installation

You can install the development version of moodleStats from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("Lightbridge-KS/moodleStats")
```

# Goal

The goal of this package it to provide a high-level functions for
analysis of [Moodle Grades
Report](https://docs.moodle.org/311/en/Quiz_reports#Grades_report) such
as calculation of **descriptive statistics** for quiz & questions, and
performingan **item analysis**.

# Workflow

``` r
library(moodleStats)
```

## Read Data

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
head(grades_df)
#> # A tibble: 6 × 19
#>   Surname `First name` Institution Department `Email address` State `Started on`
#>   <chr>   <chr>        <lgl>       <lgl>      <chr>           <chr> <chr>       
#> 1 el-Taha Joshua       NA          NA         joshua.el_025@… Fini… 12 February…
#> 2 al-Ayd… Tyler        NA          NA         tyler.al_192@e… Fini… 12 February…
#> 3 Sawyer  Michael      NA          NA         michael.saw_24… In p… 16 February…
#> 4 Snow    Leeah        NA          NA         leeah.sno_016@… Fini… 21 February…
#> 5 al-Hab… Lawrence     NA          NA         lawrence.al_20… Fini… 22 February…
#> 6 el-Sal… Isaiah       NA          NA         isaiah.el_140@… Fini… 23 February…
#> # … with 12 more variables: Completed <chr>, Time taken <chr>,
#> #   Grade/9.00 <chr>, Q. 1 /1.00 <chr>, Q. 2 /1.00 <chr>, Q. 3 /1.00 <chr>,
#> #   Q. 4 /1.00 <chr>, Q. 5 /1.00 <chr>, Q. 6 /1.00 <chr>, Q. 7 /1.00 <chr>,
#> #   Q. 8 /1.00 <chr>, Q. 9 /1.00 <chr>
```

## Prepare Data

Cleaning and filtering data can be done in 1 step using
`prep_grades_report()`

``` r
grades_df_preped <- prep_grades_report(grades_df,
                                       choose_state = "Finished", # 1. choose only "Finished" attempt
                                       choose_grade = "max", # 2. choose only the best score of each student
                                       choose_time = "first" # 3. choose the first time that student submitted
                                       ) 
head(grades_df_preped)
#> # A tibble: 6 × 16
#>   Name  Institution Department Email State Started             Grade    Q1    Q2
#>   <chr> <lgl>       <lgl>      <chr> <chr> <dttm>              <dbl> <dbl> <dbl>
#> 1 Josh… NA          NA         josh… Fini… 2021-02-12 13:03:00     5     1     1
#> 2 Leea… NA          NA         leea… Fini… 2021-02-21 20:09:00     9     1     1
#> 3 Isai… NA          NA         isai… Fini… 2021-02-23 19:51:00     6     0     1
#> 4 Eric… NA          NA         eric… Fini… 2021-02-23 21:57:00     0     0     0
#> 5 Euge… NA          NA         euge… Fini… 2021-02-24 12:25:00     7     1     1
#> 6 Anni… NA          NA         anni… Fini… 2021-02-25 01:39:00     4     0     1
#> # … with 7 more variables: Q3 <dbl>, Q4 <dbl>, Q5 <dbl>, Q6 <dbl>, Q7 <dbl>,
#> #   Q8 <dbl>, Q9 <dbl>
```

## Quiz Metadata

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

## Quiz Summary

`summary_quiz()` calculates various quiz summary statistics, and combine
it into 1 row data frame.

``` r
quiz_report_df <- summary_quiz(grades_df_preped)
quiz_report_df
#> # A tibble: 1 × 14
#>       n   min   max max_quiz median    Q1    Q3   IQR   MAD  mean    SD skewness
#>   <int> <dbl> <dbl>    <dbl>  <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>    <dbl>
#> 1   272     0     9        9      7     5     9     4  2.97  6.70  2.22   -0.884
#> # … with 2 more variables: kurtosis <dbl>, Cronbach_Alpha <dbl>
```

## Question Summary and Item Analysis

`summary_questions()` calculates various question summary statistics and
item analysis into a data frame.

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
    a pairwise *point-biserial correlation* between the score of each
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

# Learn more

-   [Get started using
    moodleStats](https://lightbridge-ks.github.io/moodleStats/articles/moodleStats.html)

------------------------------------------------------------------------

Last updated: 30 March 2022

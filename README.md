
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {workspace}

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/workspace)](https://CRAN.R-project.org/package=workspace)
[![R-CMD-check](https://github.com/KoderKow/workspace/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/KoderKow/workspace/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/KoderKow/workspace/branch/main/graph/badge.svg)](https://app.codecov.io/gh/KoderKow/workspace?branch=main)
<!-- badges: end -->

The goal of {workspace} is to effortlessly create and restore dev
environments.

## Installation

``` r
devtools::install_github("KoderKow/workspace")
```

## Example scenario

It’s a new day and a fresh RStudio session! 🥳

``` r
ls()

#> character(0)
```

*8 hours later*

Wow! What a long hard day of development! 😤

Lets review what we did:

``` r
a <- 1
b <- 2

ls()

#> "a" "b"
```

Fascinating 🤩

Let’s save our progress using {workspace} package 📦

``` r
workspace_save()

#> v Created the folder '_workspace' in the current working directory
#> v '_workspace' added to '.gitignore'
#> v '_workspace' added to '.Rbuildignore'
#> v Restore point created: _workspace/ws-2023-06-06-23-34-12_.qs
```

Assuming this is the first time using {workspace} in this project, let’s
go over what is happening here 👨‍🏫

1.  Creates a folder called `_workspace`
    - This is where all restore point files will live
2.  If the project has a `.gitignore` file, it will ignore the new
    `_workspace` folder
3.  If the project has a `.Rbuildignore` file, it will ignore the new
    `_workspace` folder
4.  A message confirming and showing the new restore point

``` r
rm(list = ls())

ls()

#> character(0)
```

Time to go shutdown RStudio and go home for the day 😴

*Morning time* 🌞

It’s a new day, lets bring back the environment we ended yesterday with

``` r
workspace_restore()

#> * Would you like to use the latest or a specific restore point?
#> 
#> 1: Latest
#> 2: List out the restore points
#> 
#> Selection: 1
#> * WARNING! Restoring will reset your global environment. Continue?
#> 
#> 1: Yes
#> 2: No
#> 
#> Selection: 1
#> v Restore complete
```

Let’s confirm the variables are back

``` r
ls()

#> "a" "b"
```

Excellent! Let’s pretend the following took use hours to create and we
want to save before getting some lunch 🌮

``` r
d <- data.frame(
  a = a,
  b = b
)

workspace_save("data created")

#> v Restore point created: _workspace/ws-2023-06-06-23-35-33_data created.qs
```

View of what variables we have

``` r
ls()

#> "a" "b" "d"
```

Alright, were back from lunch and we’re ready to … oh no! RStudio froze!
We are about to lose our entire environment

``` r
rm(list = ls())

ls()

># character(0)
```

Good thing we created a restore point after a breakthrough dev moment!

``` r
workspace_restore()

#> * Would you like to use the latest or a specific restore point?
#> 
#> 1: Latest
#> 2: List out the restore points
#> 
#> Selection: 2
#> * Enter a number corresponding to the wanted workspace restore point:
#> 
#> 1: 2023-06-06 23:34:12
#> 2: 2023-06-06 23:35:33 | data created
#> 
#> Selection: 2
#> * WARNING! Restoring will reset your global environment. Continue?
#> 
#> 1: Yes
#> 2: No
#> 
#> Selection: 1
#> v Restore complete
```

Is it back? 😥

``` r
d

#>   a b
#> 1 1 2
```

It’s back! Woo! 💃

## Recognitions

- Thanks to `save.image()` for frustrating me enough to make this
  package
- [{qs}](https://github.com/traversc/qs) package for the fast save/read
  speeds
- [{qsimage}](https://github.com/sellorm/qsimage) package for the code
  utilizing {qs} to mimic the actions of `save.image()`
- Jason Carey ([@jasoncareyco95](https://github.com/jasoncareyco95)) for
  the inspiration for creating this package

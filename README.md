
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {workspace}

<!-- badges: start -->

[![R-CMD-check](https://github.com/KoderKow/workspace/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/KoderKow/workspace/actions/workflows/R-CMD-check.yaml)
[![pre-commit.ci
status](https://results.pre-commit.ci/badge/github/KoderKow/workspace/main.svg)](https://results.pre-commit.ci/latest/github/KoderKow/workspace/main)
[![Codecov test
coverage](https://codecov.io/gh/KoderKow/workspace/branch/main/graph/badge.svg)](https://app.codecov.io/gh/KoderKow/workspace?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/workspace)](https://CRAN.R-project.org/package=workspace)
<!-- badges: end -->

Welcome to {workspace}, where magic happens! 🎇 This package aims to
make your RStudio sessions more exciting and efficient by allowing you
to effortlessly create and restore dev environments.

## Installation

``` r
devtools::install_github("KoderKow/workspace")
```

## Example scenario

Imagine it’s a brand new day, and you’re starting a fresh RStudio
session! 🌟

The workspace is clean and empty:

``` r
ls()

#> character(0)
```

*8 hours later*

Wow! It has been a long and challenging day of development

Let’s review what you’ve accomplished:

``` r
a <- 1
b <- 2

ls()

#> "a" "b"
```

Fascinating, isn’t it? 🤩

Now, let’s save our progress using the {workspace} package! 📦

``` r
workspace_save()

#> v Created the folder '_workspace' in the current working directory
#> v '_workspace' added to '.gitignore'
#> v '_workspace' added to '.Rbuildignore'
#> v Restore point created: _workspace/ws-2023-06-06-23-34-12_.qs
```

Assuming this is the first time using {workspace} in this project, let’s
go over what is happening here 👨‍🏫

1.  The function creates a folder named ’\_workspace’ to store restore
    point files
2.  If your project has a ‘.gitignore’ file, the ’\_workspace’ folder is
    automatically excluded
3.  Similarly, if your project has a ‘.Rbuildignore’ file, the
    ’\_workspace’ folder is ignored during builds
4.  The function generates a restore point file, and a message confirms
    the successful creation

Time to go shutdown RStudio and go home for the day 😴

``` r
rm(list = ls())

ls()

#> character(0)
```

*Morning time* 🌞

It’s a new day, lets bring back the environment we ended yesterday with.
Using `workspace_restore()` let’s restore from the latest restore point

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

#> character(0)
```

Good thing we created a restore point after a breakthrough dev moment!
Using `workspace_restore()` let’s restore by viewing all restore points
in a list

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
#> * WARNlNG! Restoring will reset your global environment. Continue?
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

## What this package does not do today

- Cleanup the `_workspace` folder
- Allow the user to change the default location of `_workspace`

## Recognitions

- Thanks to `save.image()` for frustrating me enough to make this
  package
- [{qs}](https://github.com/traversc/qs) package for the fast save/read
  speeds
- [{qsimage}](https://github.com/sellorm/qsimage) package for the code
  utilizing {qs} to mimic the actions of `save.image()`
- Jason Carey ([@jasoncareyco95](https://github.com/jasoncareyco95)) for
  the inspiration for creating this package

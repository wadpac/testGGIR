
<!-- README.md is generated from README.Rmd. Please edit that file -->

# testGGIR

<!-- badges: start -->
<!-- badges: end -->

The goal of testGGIR is to run an automatic testing routine based on
user-provided test files and configuration parameters.

## Installation

You can install the development version of testGGIR like so:

``` r
library(remotes)
install_github("jhmigueles/testGGIR")
```

## How does it work

The function `runPipeline` from testGGIR takes raw accelerometer data
files (ideally a subset of files from a given project), and a GGIR
config.csv file to run GGIR with a given configuration. First time the
function is run, it would only generate the output as GGIR would do it.
Next times, new output output would be generated and the GGIR reports
are compared with the latest version available in the working directory
for this same project. If all reports are similar, testGGIR will prompt
that in the console. Otherwise, it stores text files with specific
information on the differences between the report files in the
user-provided working directory.

## Example

This is a basic example:

``` r
library(testGGIR)
runPipeline(workdir = "C:/mytests/mystudy/",
            datadir = "C:/mytests/mystudy/rawfiles/",
            configfile = "C:/mystudy/output_mystudy/config.csv",
            verbose = TRUE)
```

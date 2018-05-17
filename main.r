### Psykiatriboken
## Main script

## Packages
require(knitr)
require(rmarkdown)
require(bookdown)
library(kableExtra)
## install.packages("kableExtra")
## install.packages("bookdown")
## install.packages("huxtable")

## setwd("../../../e/psykiatriboken")

## prepare data
##source("data_prepare.r") ## Only needs to be run when updated

## Render
bookdown::render_book("index.rmd", "bookdown::pdf_book")

##render("presentation_beamer.rmd", "beamer_presentation") ## presentation
##render("public_defence_application_part1a.rmd", "pdf_document", encoding="UTF-8")



## Instructions ----------
## These are now in _bookdown.yml["index.rmd", "background.rmd", "methods.rmd", "results.rmd", "ending.rmd", "references.rmd"]
## Layout and content of first pages is in frontpage_thesis.tex
## Note: "Twosides" is enabled in "preamble_tex"

## Index: Load functions, load themes, load data, bibliography, csl
## _output.yml: enables inclusion of frontpage.tex, lastpage.tex, preamble.tex
## premable.tex: Latex packages with options
## frontpage.tex: Latex formatted frontpage (probably not necessary?)

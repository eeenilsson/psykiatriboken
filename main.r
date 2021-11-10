### Psykiatriboken
## Main script
setwd('../psykiatriboken/')

## Sys.setlocale("LC_ALL","Swedish")
## options(encoding = "utf-8")
## options(encoding = "UTF-8")
## options(encoding = "latin-1")

## Packages
## install.packages("pacman")
pacman::p_load(knitr, rmarkdown, bookdown, kableExtra)
detach(package:plyr)
## install.packages("kableExtra")
## install.packages("bookdown")
## install.packages("huxtable")

## setwd("../../../e/psykiatriboken")

## prepare data
##source("data_prepare.r") ## Only needs to be run when updated

## Render
bookdown::render_book("index.rmd", "bookdown::gitbook")
bookdown::render_book("index.rmd", "bookdown::pdf_book")
bookdown::render_book("index.rmd", "bookdown::pdf_book", output_dir = "../dropbox")

knitr::kable(data.frame(a = 1:10, b = 1:10), format = "markdown")

## Plot single pages
source('antipsychotics-dosing-interval.r', encoding='utf-8')

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


## plot hyperbola
## https://www.dummies.com/education/math/calculus/how-to-graph-a-hyperbola/
## https://stackoverflow.com/questions/12702248/plotting-implicit-function
x<-seq(-1.1,1.1,length=1000)
y<-seq(-1,1,length=1000)
## z<-outer(x,y,function(x,y) 4*y^2+x^2+x*y -1 ) ## original
a <- 1
b <- 0.75
h <- 1
v <- 0.025
z<-outer(x,y,function(x,y) (x-h)^2/a^2 - (y-v)^2/b^2 -1 )
contour(x,y,z,levels=0)




d <- transform(
    expand.grid(x=seq(-2,2,length=51), ## creates combination of the vectors
                y=seq(-2,2,length=51)
                ),
    z=x^2+3*x*y+4*x+2*y+2*y^2)

require(ggplot2)
str(d)
g1 <- qplot(x,y,z=z,data=d,colour=factor(..level..),geom="contour")

p <- ggplot(aes(x=x, y=y, z = z, colour = factor(..level..)), data = d)

p + geom_contour()

?geom_contour()

dta <- transform(
    cbind(x = 1:10,
    y = 1:10)
)

p <- ggplot(aes(x=x, y=y), data = dta)
p + geom_line()

## horizontal hyperbola
(x-h)^2/a^2 - (y-v)^2/b^2 = 1

(x-h)^2/a^2 - (y-v)^2/b^2 -1 = 0


?outer

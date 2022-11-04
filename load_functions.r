## themes
source('../functions/theme_polar.r')

## packages
pacman::p_load(tidyverse,
               ggplot2,
               kableExtra,
               rsvg,
               svglite,
               data.table)

## detach(package:plyr) ## to avoid conflict w dplyr

## Functions
makestack <- function(x){
    paste("\\makecell[lt]{", gsub(",", " \\\\\\\\ ", x), "}") ## replace commas with four backslashes
}

source('../functions/query_label.r')
source('../functions/query.abbrev.r')
source('../functions/first.up.r')
source('../functions/fix.names.R')
source('../functions/labelThis.r')
## source('../functions/make_rows.r')
source('../functions/make_namedlist.r')
source('../functions/fix_pval.r')

## varnames
source('varnames.r')
source('abbreviations.r')

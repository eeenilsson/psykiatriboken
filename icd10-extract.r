## packages
library('rJava')
library("tabulizer")
library('tidyverse')

pacman::p_load(tidyverse, tabulizer, rJava)

pacman::p_load(rJava)

## packages
library('rJava')
library("tabulizer")
library('tidyverse')

## ?extract_tables
## ?extract_text

## read from pdf
pages <- 14 ## set pages to extract
test <- extract_text("/home/eee/Dropbox/psykiatri/documents/icd10_bluebook.pdf", pages = pages, area = NULL, password = NULL,
                     encoding = NULL, copy = FALSE)

## extract_text("/home/eee/Dropbox/psykiatri/documents/icd10_bluebook.pdf", pages = 1000)

## get page number
## Note: If page number is to be used, we neeed to make a loop iterating reading one page at a time.
## Note: You have to use \\1 and \\2 to replace the term inside the first and second () with itself.
## pageNumber <- gsub("^.*(- [[:digit:]]{2} -).*$","\\1", test)
## pageNumber <- gsub("- ", "", pageNumber)
## pageNumber <- gsub(" -", "", pageNumber)
## pageNumber <- as.numeric(pageNumber)

## remove page number
test <- gsub("- [0-9]* -", "", test) 

## citations (very few exist?)
## citations <- gsub("^.*(\\.[[:digit:]]{1}).*$","\\1", test)

## remove newlines appearing inside text chunks
test <- gsub("\n(?=[^ ])", "", test, perl = T, ignore.case=TRUE) ## regexp with lookahead removes only newlines in text

test <- gsub("(\n[[:space:]]){2,}", "\n ", test) ## reduce ocurrances of two or more \n to one \n
test <- gsub("(\n[[:space:]]*\n)", "\n ", test) ## repeat but no space after last \n

test <- gsub("[[:blank:]]{2,}", " ", test) ## reduce ocurrances of two or more spaces

## Identify headers - newlines not ending with dot before next newline (add hash to these)
## testHeaders <-
##     gsub("((?<=\n){1}[^$.|\n]*(?=[[:space:]]\n){1}?)", "##\\1", perl = TRUE, ignore.case=TRUE, test) ## [^$.|\n] matches NOT ^$. OR \n
## Note: this misses headers with dots inside header

## test dot at end
testHeaders <- gsub("((?<=\n)(?:(?!\\.[[:blank:]]).)+(?=[[:space:]]\n){1}?)", "##\\1", test, perl = TRUE) ### works?

## testHeaders <-
##     gsub("((?<=\n){1}[^$(.)]*(?=[[:space:]]\n){1}?)", "##\\1", perl = TRUE, ignore.case=TRUE, test) 
## /(.*)\.[^.]+$/
## gsub("/(.*).[^\.]+$/", "", "test.pdf", perl = TRUE)
## gsub("\\.\\s", "", "test. pdf test.pdf") ## works
## gsub("[^(es)]", "", "test. pdf texst.pdf")
## gsub("^(?:(?!es).)+$", "", "test. pdf texst.pdf", perl = TRUE)
## gsub("^(?:(?!\n).)+", "", "test.header \n This is text. Here also. \n", perl = TRUE)
## gsub("^(?:(?!\\.).)+", "", "test.header \n This is text. Here also. \n", perl = TRUE) ## not dot
## gsub("^(?:(?!\\.[[:blank:]]).)+", "", "test.header \n This is text. Here also. \n", perl = TRUE)
## gsub("^(?:(?!\\.[[:blank:]]).)+", "", "test.header \n This is text. Here also. \n", perl = TRUE)
## gsub("(?<=\n)(?:(?!\\.[[:blank:]]).)+(?=[[:space:]]\n){1}?", "", "\n test.header \n This is text. Here also. \n", perl = TRUE) ### works?

## gsub("((?<=\n)(?:(?!\\.[[:blank:]]).)+(?=[[:space:]]\n){1}?)", "##\\1", "\n test.header \n Another header \n This is text. Here also. \n", perl = TRUE) ### works?

## format
testHeaders <- gsub("\n", "\n \n", testHeaders) ## double newline
testHeaders <- gsub("\n ", "\n", testHeaders) ## remove leading blank

## export

## one page
## testList <- strsplit(testHeaders, "\n") ## split by newline
## writeLines(testList[[1]], "test.txt")

## multiple pages
testList <- lapply(testHeaders, function(x) strsplit(x, "\n"))
for(i in 1:length(testList)){
    write(testList[[i]][[1]], file = "test.txt"
       , append = TRUE
          )
    
}


## test get quotes (removing duplicates)
source('../functions/get_quote.r')
get_quotes(testList$text, "children")[!duplicated(get_quotes(testList$text, "children"))]

## Notes below

getwd()
setwd("../psykiatriboken/")

?regmatches
 x <- c("A and B", "A, B and C", "A, B, C and D", "foobar")
     pattern <- "[[:space:]]*(,|and)[[:space:]]"
     ## Match data from regexpr()
     m <- regexpr(pattern, x)
     regmatches(x, m)


## list of tables, p 2:8
tab <- extract_tables("variables_in_evolve_define.pdf", pages = 2:8)
tab_df <- as.data.frame(do.call("rbind", tab)) # make df
## names(df) <- df[1,] # set colnames, not meaningful when writing csv
write_csv(tab_df, "variable_tables.csv") # write csv

## variables
P <- 9:481
vars <- extract_tables("variables_in_evolve_define.pdf", pages = P)
vars_df <- as.data.frame(do.call("rbind", vars)) # make df
referred <- lapply(
    extract_text("variables_in_evolve_define.pdf", pages = P),
       get_referred_vars) # gather text that matches the referred variable
vars_df <- cbind( ## add column with referred variable
    vars_df,
    referred = insert_at(vars_df[,1], "Variable", unlist(referred))
)
levels(vars_df[["referred"]]) <- c(levels(vars_df[["referred"]]),"referred")
vars_df["referred"][1,] <- "referred" # add to first row
colnames(vars_df) <- as.character(unlist(vars_df[1,]))
vars_df <- vars_df[-1,] # remove first row (colnames)
write_csv(vars_df, "variables.csv") # write csv

# NOTE: do the renaming for all sets

## code list, p 482:577 (refers to variables: controlled terms or format)
P <- 482:577
codes <- extract_tables("variables_in_evolve_define.pdf", pages = P)
codes_df <- as.data.frame(do.call("rbind", codes)) # make df
referred <- lapply(
    extract_text("variables_in_evolve_define.pdf", pages = P),
       get_referred) # gather text that matches the referred variable
codes_df <- cbind( ## add column with referred variable
    codes_df,
    referred = insert_at(codes_df[,1], "Code Value", unlist(referred))
)
write_csv(codes_df, "codes.csv") # write csv

#### extract dsm-5 to txt (note this is the old non-revised dsm-5 version)

## packages
pacman::p_load(tidyverse, tabulizer, rJava)

### DSM-5 (not the updated version)
contents <-
    extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 5:6) ## contents

### Classifications
classifications <-     extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 13:40) ## classifications list start on p13

## make list of codes (use existing csv instead?)
classificationsList <- classifications
classificationsList[1] <- gsub("(?s).*(?=\nNe)", "", classificationsList[1], perl=T)
## strsplit(classificationsList[1])
## strsplit(classificationsList[1], "\n") ## split by newline

## multiple pages from list
for(i in 1:length(classificationsList)){
    write(classificationsList[[i]][[1]], file = "test.txt"
       , append = TRUE
          )
    
}
## Note: Superscrips are not read, has to be edited manually

writeLines(classifications[1], "test.txt")
classifications[1]


## ICD9-CM (ICD10-CM)

preface <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 41:44) ## classifications list start on p13


section1 <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 45:66) ## "DSM-5 basics". Note that chapter title is a graphic and will not be extracted

section2toc <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 67) ## "Diagnostic criteria and codes". [TOC]

section2preface <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 68) ## [Preface]

section2intro <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 69:71) ## "Neurodevelopmental disorders". ## Note: remove last part

section2a <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 71:79) ## "Neurodevelopmental disorders".
section2a[1] <- gsub("(?s).*(?=\nIntelle)", "", section2a[1], perl=T) ## remove redundant text before section starts
## section2a[1] <- gsub("(?s)\n(?!\\(|[A-Z]\\.)", "", section2a[1], perl=T) ## remove \n not followed by parens or CAP.
section2a <- paste(section2a, collapse = "") ## collapse to one

section2a <- gsub("(?s)\n(?!\\(|[A-Z])", "", section2a, perl=T) ## remove \n not followed by parens or CAP
## test
substr(gsub("(?s)\n(?!\\(|[A-Z]\\.)", "", section2a, perl=T), 4000, 5000)

section2a



## format details
section2a <- gsub("Note:", "\nNote:", section2a)
section2a <- gsub("Coding note:", "\nCoding note:", section2a)
section2a <- gsub("Specify", "\nSpecify", section2a)
section2a <- gsub("Specifiers", "\n## Specifiers\n", section2a)
section2a <-
    gsub("Specify(.*:\n)", "\nSpecify\\1", section2a)

## write
writeLines(section2a[1], "section2a.txt")

section2a[1]

extract_tables("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 72) ## table, cannot be read



x

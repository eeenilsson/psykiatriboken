#### extract dsm-5 to txt (note this is the old non-revised dsm-5 version)

## packages
pacman::p_load(tidyverse, tabulizer, rJava)

## Functions
spellCorrect <- function(SPELL, CHUNK){
    ## Replaces matches in CHUNK from SPELL list. SPELL is a list of named elements with name = match and value = replacement 
    TEMP <- CHUNK
    for (i in 1:length(SPELL)){
    TEMP <-
        gsub(names(SPELL[i]), SPELL[i][[1]], TEMP, perl=T)
    }
    return(TEMP)    
}

makeHeaders <-function(x){
    gsub("((?<=\n)(?:(?![\\,\\.]).)+(?=\n){1}?)", "## \\1", x, perl=T)
}

cleanNewlines <- function(CHUNK){
    ## removes newlines not followed by parens, Cap, number. or multiplnumbers
    gsub("(?s)\n(?!\\(|[A-Z]|[0-9]\\.|[0-9]{3,}.*\\(F)", "", CHUNK, perl=T) 
}

cleanNewlinesDot <- function(CHUNK){
    ## added dot after CAPS and anychar befoe parens
    gsub("(?s)\n(?!.\\(|[A-Z]\\.|[0-9]\\.|[0-9]{3,}.*\\(F)", "", CHUNK, perl=T) 
}

## variables

### make a listr of value-replacement pairs
spellList <- list(
    'Reiationship'= "Relationship",
    'Prevaience'= "Prevalence",
    'Deveiopment' = "Development",
    'Reiated' = "Related",
    'iVlaricers' = "Markers",
    'lUloderate' = "Moderate",
    'Cuiture' = "Culture",
    'comotbid' = "comorbid",
    ' ̂' = "",
    '(-){2,}' = "",
    '(_){2,}' = "",
    '(_̂){1,}' = ""
)

### DSM-5 (not the updated version)

copyright <-
    extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 4) 

contents <-
    extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 5:6) ## contents

contents <- paste(contents, collapse = "") ## collapse to one
contents <- gsub("\\.{2,}", "\t", contents)
contents <- gsub("Section", "## Section", contents)
contents <- gsub("Appendix", "## Appendix", contents)
contents <- gsub("Contents", "## Contents", contents)
contents <- gsub("[[:blank:]]\n", " ", contents, perl=T, ignore.case=TRUE)
contents <- gsub("(I{1,})\n", "\\1 ", contents, perl=T)
contents <- gsub("##", "\n##", contents, perl=T)
writeLines(contents, "contents.txt")

taskforce <-
    extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 7:12)  
taskforce <- paste(taskforce, collapse = "") ## collapse to one

### Classifications
## Note: import not working, codes in sequence instead of per line
## classifications <-     extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 13:40) ## classifications list start on p13
## classifications <- paste(classifications, collapse = "") ## collapse to one
## classifications <- cleanNewlines(classifications) ## not working here so well
## writeLines(classifications, "classifications.txt")
## gsub("((?<=\n).*\\)(?=\n))", "## \\1", classifications, perl=T)

## make list of codes (use existing csv instead?)
## classificationsList <- classifications
## classificationsList[1] <- gsub("(?s).*(?=\nNe)", "", classificationsList[1], perl=T)
## ## strsplit(classificationsList[1])
## ## strsplit(classificationsList[1], "\n") ## split by newline

## ## multiple pages from list
## for(i in 1:length(classificationsList)){
##     write(classificationsList[[i]][[1]], file = "test.txt"
##        , append = TRUE
##           )
    
## }
## Note: Superscrips are not read, has to be edited manually
## writeLines(classifications[1], "test.txt")
## classifications[1]

## ICD9-CM (ICD10-CM)

## Preface
preface <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 41:44) ## classifications list start on p13
preface <- gsub("­\n", "", preface) ## remove - at end of line
preface <- spellCorrect(spellList, preface)
preface <- cleanNewlinesDot(preface)
preface <- gsub("\n", "\n\n", preface) ## double newline
preface <- gsub("ΤΙΊΘ A m G riC Sn  P s y c h iâ t r ic", " American Psychiatric", preface)
preface <- gsub("•", "\n•", preface)
writeLines(preface, "preface.txt")

section1 <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 45:66) ## "DSM-5 basics". Note that chapter title is a graphic and will not be extracted
section1 <- paste(section1, collapse = "")
section1 <- gsub("ΤΙΊΘ C rG âtion  ", " The creation ", section1)

cleanText <- function(CHUNK) {
    TEMP <- CHUNK
    TEMP <- gsub("­\n", "", TEMP) ## remove - at end of line
    TEMP <- spellCorrect(spellList, TEMP)
    TEMP <- cleanNewlinesDot(TEMP)
    TEMP <- gsub("\n", "\n\n", TEMP) ## double newline
    TEMP <- gsub("•", "\n•", TEMP)
    TEMP <- gsub("\\.{2,}", "\t", TEMP)
    TEMP <- gsub("((?<=\\.)[A-Z])", " \\1", TEMP, perl=T)
    return(TEMP)
}

test <- cleanText(section1)
writeLines(test, "section1.txt")



makeHeaders(test)

writeLines(makeHeaders(test), "section1.txt")



section2toc <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 67) ## "Diagnostic criteria and codes". [TOC]

section2preface <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 68) ## [Preface]

section2intro <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 69:71) ## "Neurodevelopmental disorders". ## Note: remove last part

section2a <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 71:79) ## "Neurodevelopmental disorders".
section2a[1] <- gsub("(?s).*(?=\nIntelle)", "", section2a[1], perl=T) ## remove redundant text before section starts
## section2a[1] <- gsub("(?s)\n(?!\\(|[A-Z]\\.)", "", section2a[1], perl=T) ## remove \n not followed by parens or CAP.

## collapse pages
section2a <- paste(section2a, collapse = "") ## collapse to one

## remove - at end of line
section2a <- gsub("­\n", "", section2a)

section2a <- gsub("(?s)\n(?!\\(|[A-Z]|[0-9]\\.)", "", section2a, perl=T) ## remove \n not followed by parens or CAP or number

## identify headers as lines without comma or dot
section2a <- gsub("((?<=\n)(?:(?![\\,\\.]).)+(?=\n){1}?)", "## \\1", section2a, perl=T)

## format details
section2a <-
    gsub("Specify(.*:\n)", "Specify\\1", section2a)
section2a <- gsub("\n", "\n\n", section2a) ## double newline

## replace matches in spellList
## for (i in 1:length(spellList)){
##     section2a <-
##         gsub(names(spellList[i]), spellList[i][[1]], section2a)
## }

section2a <- spellCorrectTEST(spellList, section2a) ## fix spelling

## chunk specific replacements
section2a <- gsub("(?s)\\.&.*Æu cru", "", section2a, perl = T) ## remove table
section2a <- gsub("Global Developmental Delay315.8 \\(F88\\)", "## Global Developmental Delay \n\n315.8 (F88)", section2a)
section2a <-
    gsub("\n\n\\(Intellectual Developmental Disorder\\)319 \\(F79\\)", "(Intellectual Developmental Disorder) \n\n319 (F79)", section2a)

## write
writeLines(section2a[1], "section2a.txt")

## notes
## pdftools better?
## text <- pdftools::pdf_text("path/file.pdf")[10:16]

## install pdftk on arch?
## system("pdftk myfile.pdf cat 10-16 output myfile_10to16.pdf")

## splitDSM <- split_pdf("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf")
## merge_pdfs(splitDSM[10:16], 'dsm-5-manual-2013-sid10-16.pdf')
## extract_tables("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 72) ## table, cannot be read

sectionTEST <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 611:618) ## "DSM-5 basics". Note that chapter title is a graphic and will not be extracted

## collapse pages
sectionTEST <- paste(sectionTEST, collapse = "") ## collapse to one

## remove - at end of line
sectionTEST <- gsub("­\n", "", sectionTEST)

## remove surplus newlines
sectionTEST <-
    gsub("(?s)\n(?!\\(|[A-Z]|[0-9]\\.|[0-9]{3,}.*\\(F)", "", sectionTEST, perl=T) 
## removes \n not followed by parens or CAP or number followed by dot

## test
## sectionTEST <-
    ## gsub("(?s)\n(?!\\(|[A-Z]|[0-9]\\.|[0-9]{3,}.*\\(F)", "", "Unknown) \nSubstance-Induced Disorders\nBecause \nanew.", perl=T) 

## identify headers as lines without dot or comma characters or a special expression for some lists of diagnosis codes
## sectionTEST <-
##     gsub("((?<=\n)(?:(?![\\,\\.]).)+(?=\n){1}?)", "## \\1", sectionTEST, perl=T)

## headers
sectionTEST <- makeHeaders(sectionTEST)

sectionTEST <- spellCorrect(spellList, sectionTEST) ## fix spelling

sectionTEST <- gsub("\n", "\n\n", sectionTEST) ## double newline

## format details
## sectionTEST <-
##     gsub("Specify(.*:\n)", "Specify\\1", sectionTEST)
## sectionTEST <- gsub("(-){2,}", "", sectionTEST, perl=T)
## sectionTEST <- gsub("(_){2,}", "", sectionTEST, perl=T)
## sectionTEST <- gsub("(_̂){1,}", "", sectionTEST, perl=T)

## local formatting
## gsub("(?s)((?<=(\n\n## Other \\(or Unknown\\) \n\n)).*(?=## Diagnostic Criteria))", "", text, perl=T) ## correctly identifies text between bounds but no 
##way to replace ## within region.

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

cleanText <- function(CHUNK) {
    ## gathers some text cleaning functions
    TEMP <- CHUNK
    TEMP <- gsub("­\n", "", TEMP) ## remove - at end of line
    TEMP <- spellCorrect(spellList, TEMP)
    TEMP <- cleanNewlines(TEMP)
    TEMP <- gsub("\n", "\n\n", TEMP) ## double newline
    TEMP <- gsub("•", "\n•", TEMP)
    TEMP <- gsub("\\.{2,}", "\t", TEMP)
    TEMP <- gsub("((?<=\\.)[A-Z])", " \\1", TEMP, perl=T)
    return(TEMP)
}

assignTag <- function(CHUNK, LIST, tag = "<--@TAG-->", ignore.case = FALSE){
    ## Assign label 'tag' to strings in CHUNK matching LIST
    TEMP <- CHUNK
    for (i in 1:length(LIST)){
        searchFor <- paste("## ", LIST[i]) 
        TEMP <- sub(paste("## ", LIST[i], sep = ""),
                    paste("## ", LIST[i], " ", tag, sep = ""), TEMP,
                    ignore.case = ignore.case)
    }
    return(TEMP)
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
    'Fieid' = "Field",
    'Triais' = "Trials",
    'commimication' = "communication",
    'foimdational' = "foundational",
    's e c tio n' = "section",
    'comotbid' = "comorbid",
    'Risic' = "Risk",
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

## Section I (Introduction/basics)
section1 <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 45:66) ## "DSM-5 basics". Note that chapter title is a graphic and will not be extracted
section1 <- paste(section1, collapse = "")
section1 <- gsub("ΤΙΊΘ C rG âtion  ", "\n The creation ", section1)
section1 <- cleanText(section1)
section1 <- makeHeaders(section1)
writeLines(section1, "section1.txt")

## Section II Diagnostic criteria

### TOC
section2toc <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 67) ## "Diagnostic criteria and codes". [TOC]
section2toc <- paste(section2toc, collapse = "") ## collapse to one
section2toc <- gsub("\\.{2,}", "\t", section2toc)
section2toc <- gsub("\\.«.*riDiagnostic..", "## Diagnostic criteria and codes", section2toc)
writeLines(section2toc, "section2toc.txt")

### preface to section II
section2preface <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 68) ## [Preface]
section2preface <- paste(section2preface, collapse = "")
section2preface <- cleanText(section2preface)
section2preface <- makeHeaders(section2preface)
writeLines(section2preface, "section2preface.txt")

### Neurodevelopmental disorder intro
neurodevelopmentalIntro <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 69:71) ## "Neurodevelopmental disorders". ## Note: remove last part
neurodevelopmentalIntro <- paste(neurodevelopmentalIntro, collapse = "")
neurodevelopmentalIntro <- cleanText(neurodevelopmentalIntro)
neurodevelopmentalIntro <- makeHeaders(neurodevelopmentalIntro)
neurodevelopmentalIntro <- gsub("ΤΙί Θ Π θυΓΟ όθνθΙορΓΠ Θ Π ΐάΙ", "The neurodevelopmental", neurodevelopmentalIntro)
neurodevelopmentalIntro <- gsub("## Intellectual Disabilities.*", "", neurodevelopmentalIntro) ## remove redundant part of next chunk
neurodevelopmentalIntro <- gsub("- ", "", neurodevelopmentalIntro)
writeLines(neurodevelopmentalIntro, "neurodevelopmentalIntro.txt")

### Neurodevelopmental main body
neurodevelopmentalMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 71:124) ## "Neurodevelopmental disorders".
neurodevelopmentalMain[1] <- gsub("(?s).*(?=\nIntelle)", "", neurodevelopmentalMain[1], perl=T) ## remove redundant text before section starts and 
neurodevelopmentalMain[1] <- gsub("^\n", "## Intellectual Disabilities\n", neurodevelopmentalMain[1]) ## add ## to first line
#### clean
neurodevelopmentalMain <- paste(neurodevelopmentalMain, collapse = "") ## collapse to one
neurodevelopmentalMain <- cleanText(neurodevelopmentalMain)
neurodevelopmentalMain <- makeHeaders(neurodevelopmentalMain)
#### chunk specific replacements
neurodevelopmentalMain <- gsub("(?s)\\.&.*Æu cru", "\n\n<--TABLE REMOVED-->", neurodevelopmentalMain, perl = T) ## remove table
neurodevelopmentalMain <- gsub("c\\.2.cS.*(I  1 1)", "\n\n<--TABLE REMOVED-->", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("Global Developmental Delay315.8 \\(F88\\)", "## Global Developmental Delay \n\n315.8 (F88)", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("\n\n\\(Intellectual Developmental Disorder\\)319 \\(F79\\)", "(Intellectual Developmental Disorder) \n\n319 (F79)", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("(\n\n## )(\\(Intellectual)", " \\2", neurodevelopmentalMain, perl = T)
#### other replacements
neurodevelopmentalMain <- gsub("(\n\n## )([0-9])", "\n\n\\2", neurodevelopmentalMain, perl = T)
neurodevelopmentalMain <- gsub("## \\(", "\\(", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("## With", "With", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("\n\n([A-Z].*\\))(?=(\n\n[A-Z]\\.))", "\n\n### \\1", neurodevelopmentalMain, perl = T) ### subheaders for multiple subdiagnoses in the diagnostic criteria section
neurodevelopmentalMain <- gsub("\n\n## Disorder\n\n", "Disorder\n\n", neurodevelopmentalMain) ## make ##Disorder not be separate header
neurodevelopmentalMain <- gsub("(### )([A-Z]\\.)", "\\2", neurodevelopmentalMain) ## extra cleaning 
neurodevelopmentalMain <-
    gsub("\\/.\n\n## ", "\\/", neurodevelopmentalMain) ## remove forwardslash
neurodevelopmentalMain <-
    gsub("[[:blank:]]{2,}", " ", neurodevelopmentalMain) ## remove repeated spaces

store <- neurodevelopmentalMain
## neurodevelopmentalMain <- store ## recover

## tags

## List groups
groupList <- c(
    "Intellectual Disabilities",
    "Communication Disorders",
    "Autism Spectrum Disorder",
    "Specific Learning Disorder",
    "Motor Disorders",
    "Other Neurodevelopmental Disorders"
)

## assign group tags
neurodevelopmentalMain <- assignTag(neurodevelopmentalMain, groupList, tag = "<--@GROUP-->")
writeLines(neurodevelopmentalMain, "neurodevelopmentalMain.txt")

## assign diagnosis tags
##icd10cmDsm5 <- read_csv("icd10cm-to-dsm5.csv")
icd10cmDsm5 <- read_csv("icd10-dsm5.csv") ## try other version

listDiagnoses <- gsub("([.|()\\^{}+$*?]|\\[|\\])", "\\\\\\1", icd10cmDsm5$dsm5text) ## escape regex characters
neurodevelopmentalMain <- assignTag(neurodevelopmentalMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE)
writeLines(neurodevelopmentalMain, "neurodevelopmentalMain.txt")

#### write
writeLines(neurodevelopmentalMain, "neurodevelopmentalMain.txt")

## TODO: addTags should ignore headers that already have tags (optionally?)

## Header ref in bookdown {#background}
## <-- @CHAPTER --->
## <-- @GROUP ---> ## Diagnosis group
## <-- @DIAGNOSIS --->
## <-- @SECTION (I-III)--->

## add "icd10 to parens containing these diagnoses"

## test
test <- substr(neurodevelopmentalMain, 1, 25000)


## TODO ================================
## TODO:
## ## Specify if: should perhaps be made boldface or just remove ## ?
## Headers

## Notes on headers =============
## A [diagnosis] has diagnostic criteria and is followed by text on the subject.
## A [diagnosis] can be matched in the code list, but note that CASE is different, so needs case-insensitive matching

#### Section headers: (only first occurance)
## Intellectual Disabilities
## Communication Disorders
## Autism Spectrum Disorder
## Specific Learning Disorder
## Motor Disorders
## Other Neurodevelopmental Disorders


## # Neurodevelopmental
## ## Intellectual disabilities [group]
## ### Intellectual disability (Intellectual Developmental Disorder) [diagnosis]
## ## Communication Disorders
## ### Language Disorder
## ### Speech Sound Disorder
## ### Childhood-Onset Fluency Disorder (Stuttering)
## ## Autism Spectrum Disorder [group]
## ### Autism Spectrum Disorder [Note: In this case subheader identical to header]
## Attention-Deficit/Hyperactivity Disorder
## Specific Learning Disorder
## Motor Disorders [group]
### Tic Disorders [diagnosis]
#### Tourette’s Disorder 307.23 (F95.2) [sub-diagnosis]
#### Persistent (Chronic) Motor or Vocal Tic Disorder 307.22 (F95.1 )
#### Provisional Tic Disorder 307.21 (F95.0)
## Other Neurodevelopmental Disorders

## Notes below ===================

## test substring
## test <- substr(neurodevelopmentalMain, nchar(neurodevelopmentalMain)-19000, nchar(neurodevelopmentalMain)-16000)
## gsub("\n\n([A-Z].*\\))(?=(\n\n[A-Z]\\.))", "### \\1", test, perl = T) ## seems to work


## 125:128 schizophrenia intro
## 128 Scizophrenia start of main body

## 31
## 87+40
## 71-31
## 125

## gsub("^", "Start", neurodevelopmentalMain)

## section2a <- gsub("­\n", "", section2a) ## remove - at end of line
## section2a <- gsub("(?s)\n(?!\\(|[A-Z]|[0-9]\\.)", "", section2a, perl=T) ## remove \n not followed by parens or CAP or number
## ## identify headers as lines without comma or dot
## section2a <- gsub("((?<=\n)(?:(?![\\,\\.]).)+(?=\n){1}?)", "## \\1", section2a, perl=T)
## section2a <- gsub("Specify(.*:\n)", "Specify\\1", section2a)
## section2a <- gsub("\n", "\n\n", section2a) ## double newline







## notes ============================
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
## format details
## sectionTEST <-
##     gsub("Specify(.*:\n)", "Specify\\1", sectionTEST)
## sectionTEST <- gsub("(-){2,}", "", sectionTEST, perl=T)
## sectionTEST <- gsub("(_){2,}", "", sectionTEST, perl=T)
## sectionTEST <- gsub("(_̂){1,}", "", sectionTEST, perl=T)

## local formatting
## gsub("(?s)((?<=(\n\n## Other \\(or Unknown\\) \n\n)).*(?=## Diagnostic Criteria))", "", text, perl=T) ## correctly identifies text between bounds but no 
##way to replace ## within region.

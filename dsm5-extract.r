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

## OLD
## assignTag <- function(CHUNK, LIST, tag = "<--@TAG-->", ignore.case = FALSE){
##     ## Assign label 'tag' to strings in CHUNK matching LIST
##     TEMP <- CHUNK
##     for (i in 1:length(LIST)){
##         searchFor <- paste("## ", LIST[i]) 
##         TEMP <- sub(paste("## ", LIST[i], sep = ""),
##                     paste("## ", LIST[i], " ", tag, sep = ""), TEMP,
##                     ignore.case = ignore.case)
##     }
##     return(TEMP)
## }

assignTag <- function(CHUNK, LIST, tag = "<--@TAG-->", ignore.case = FALSE, hash.replace = "##"){
    ## Assign label 'tag' to strings in CHUNK matching LIST
    TEMP <- CHUNK
    for (i in 1:length(LIST)){
        TEMP <- sub(paste("## ", LIST[i], sep = ""),
                    paste(hash.replace, " ", LIST[i], " ", tag, sep = ""), TEMP,
                    ignore.case = ignore.case)
    }
    return(TEMP)
}


## variables
source('replacement-list.r')

### DSM-5 (not the updated version)

## Title, copyright page etc ================
## Page 1: Cover
## Page 2: American Psychiatric Association (LIST OF NAMES OF OFFICERS)

## ## Page 3, Title page
## DIAGNOSTIC AND STATISTICAL
## MANUAL OF 
## MENTAL DISORDERS
## FIFTH EDITION
## DSM-5^TM
## LOGO: American Psychiatric Publishing
## -----
## Washington, DC
## London, England

## Copyright page
## ISBN 978-0-89042-554-1
copyright <-
    extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 4) 

## Contents
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

## Taskforce (List of members)
taskforce <-
    extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 7:12)  
taskforce <- paste(taskforce, collapse = "") ## collapse to one

## ## Classifications (List of diagnoses and sub-diagnoses, import not working)
## Note: import not working, codes in sequence instead of per line
classifications <-     extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 13:40) ## classifications list start on p13
classifications <- paste(classifications, collapse = "") ## collapse to one
classifications <- cleanNewlines(classifications) ## not working here so well
writeLines(classifications, "classifications.txt")

## ICD9-CM (ICD10-CM)
## TODO: Extract chapter names [A-Z].* ([0-9]{1,})\n

## writeLines(
##     grep("(?<=\n)[A-Z].*\\([0-9]{1,}(?=\\)\n)", text, value = T, perl = T)
##   , "chapters.txt")
## text <- "\nV62.9 (Z65.9) Unspecified Problem Related to Unspecified Psychosocial\nCircumstances (725)\nV15.49 Z91.49 TEST\nV15.59 (Z91.5)\nV62.22 (Z91.82)\nV15.89 (Z91.89)\nV69.9 (Z72.9)\nV71.01 (Z72.811)\nV71.02 (Z72.810)\nOther Circumstances of Personal History (726)\nOther Personal History of Psychological Trauma (726)\nPersonal History of Self-Harm (726)\nPersonal History of Military Deployment (726)\nOther Personal Risk Factors (726)\nProblem Related to Lifestyle (726)\nAdult Antisocial Behavior (726)\nChild or Adolescent Antisocial Behavior (726)\nProblems Related to Access to Medical and Other Health Care (726)\nV63.9 (Z75.3) Unavailability or Inaccessibility of Health Care Facilities (726) \nV63.8 (Z75.4) Unavailability or Inaccessibility of Other Helping Agencies (726)\nNonadherence to Medical Treatment (726)\n"
## gsub("((?<=\n).*\\)(?=\n))", "## \\1", classifications, perl=T)

## Preface ==============================
preface <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 41:44) ## classifications list start on p13
preface <- gsub("­\n", "", preface) ## remove - at end of line
preface <- spellCorrect(spellList, preface)
preface <- cleanNewlinesDot(preface)
preface <- gsub("\n", "\n\n", preface) ## double newline
preface <- gsub("ΤΙΊΘ A m G riC Sn  P s y c h iâ t r ic", " American Psychiatric", preface)
preface <- gsub("•", "\n•", preface)
writeLines(preface, "preface.txt") ## Foreword

## Book elements =============

## Part section chapter
## LaTex
## -1 	\part{part}
## 0 	\chapter{chapter}
## 1 	\section{section}
## 2 	\subsection{subsection}
## 3 	\subsubsection{subsubsection}
## 4 	\paragraph{paragraph}
## 5 	\subparagraph{subparagraph}

## Foreword
## The foreword contains a statement about the book and is usually written by someone other than the author who is an expert or is widely known in the field of the book's topic. A foreword lends authority to your book and may increase its potential for sales. If you plan to include a foreword, please arrange to have it written and included in your submitted manuscript. A foreword is most commonly found in nonfiction works.

## Preface
## The preface usually describes why you wrote the book, your research methods and perhaps some acknowledgments if they have not been included in a separate section. It may also establish your qualifications and expertise as an authority in the field in which you're writing. Again, a preface is far more common in nonfiction titles and should be used only if necessary in fiction works.

## Section I (Introduction/basics) ================================
section1 <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 45:66) ## "DSM-5 basics". Note that chapter title is a graphic and will not be extracted
section1 <- paste(section1, collapse = "")
section1 <- gsub("ΤΙΊΘ C rG âtion  ", "\n The creation ", section1)
section1 <- cleanText(section1)
section1 <- makeHeaders(section1)
writeLines(section1, "section1.txt")

## Section II Diagnostic criteria ==========================

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
neurodevelopmentalMain[1] <-
    gsub("(?s).*(?=\nIntellectual Disabilities\n)", "", neurodevelopmentalMain[1], perl=T) ## remove redundant text before section starts and 
neurodevelopmentalMain[1] <- gsub("^\n", "## ", neurodevelopmentalMain[1]) ## add ## to first line
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
neurodevelopmentalMain <- gsub("## \\(", "\\(", neurodevelopmentalMain) ## removes hashes before severity diagnoses
neurodevelopmentalMain <- gsub("## With", "With", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("\n\n([A-Z].*\\))(?=(\n\n[A-Z]\\.))", "\n\n### \\1", neurodevelopmentalMain, perl = T) ### subheaders for multiple subdiagnoses in the diagnostic criteria section
neurodevelopmentalMain <- gsub("\n\n## Disorder\n\n", "Disorder\n\n", neurodevelopmentalMain) ## make ##Disorder not be separate header
neurodevelopmentalMain <- gsub("(### )([A-Z]\\.)", "\\2", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("## Specify", "_Specify_", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("(\\.)([a-z]\\.[[:blank:]][A-Z])", "\\1\n\\2", neurodevelopmentalMain) ## lowercase lists
## Specify is not a header
## extra cleaning 
neurodevelopmentalMain <-
    gsub("\\/.\n\n## ", "\\/", neurodevelopmentalMain) ## remove forwardslash
neurodevelopmentalMain <-
    gsub("[[:blank:]]{2,}", " ", neurodevelopmentalMain) ## remove repeated spaces

store <- neurodevelopmentalMain
##neurodevelopmentalMain <- store ## recover

## tags

## List groups
groupList <- c(
    "Intellectual Disabilities",
    "Communication Disorders",
    "Autism Spectrum Disorder",
    "Attention-Deficit/Hyperactivity Disorder",
    "Specific Learning Disorder",
    "Motor Disorders",
    "Other Neurodevelopmental Disorders"
)

## assign group tags
neurodevelopmentalMain <- assignTag(neurodevelopmentalMain, groupList, tag = "<--@GROUP-->", hash.replace = "#")
writeLines(neurodevelopmentalMain, "neurodevelopmentalMain.txt")

## assign diagnosis tags
##icd10cmDsm5 <- read_csv("icd10cm-to-dsm5.csv")
icd10cmDsm5 <- read_csv("icd10-dsm5.csv") ## try other version

## clean
icd10cmDsm5$dsm5textClean <- gsub("\\[.*\\+\\][[:blank:]]", "", icd10cmDsm5$dsm5text) ## remove stuff in brackets
icd10cmDsm5$icd10cmClean <- gsub("\\[.*\\+\\][[:blank:]]", "", icd10cmDsm5$icd10cm) ## remove stuff in brackets

## listBrackets <- grep("\\[.*\\+\\][[:blank:]]", icd10cmDsm5$dsm5text, value=T) ## get list of stuff in brackets ## NOT working properly

listDiagnoses <- gsub("([.|()\\^{}+$*?]|\\[|\\])", "\\\\\\1", icd10cmDsm5$dsm5textClean) ## escape regex characters
listCodes <- gsub("([.|()\\^{}+$*?]|\\[|\\])", "\\\\\\1", icd10cmDsm5$icd10cmClean)



neurodevelopmentalMain <- assignTag(neurodevelopmentalMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE)
writeLines(neurodevelopmentalMain, "neurodevelopmentalMain.txt") ## Noe that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)


text <- "[Frontotemporal disease +] Major frontotemporal neurocognitive disorder, Probable"


## Tag severity diagnoses
assignTagSub <- function(CHUNK, LIST, LIST2, tag = "<--@TAG-->", ignore.case = FALSE, replace = "TEST"){
    ## Assign label 'tag' to strings in CHUNK matching LIST
    TEMP <- CHUNK
    for (i in 1:length(LIST)){
        TEMP <- sub(paste("((?<=\\()", LIST[i], "\\.?[0-9]{0,3}", "(?=\\)))", sep = ""),
                    paste("\\1", replace, " ", LIST2[i], " ", tag, sep = ""), TEMP,
                    ignore.case = ignore.case,
                    perl = T)
    }
    return(TEMP)
}

i <- 1
LIST <-listCodes
assignTagSub(text, listCodes, listDiagnoses)


"(?<=\\()Z55\\.9\\.?[0-9]{0,3}(?=\\))\n"

tag <- "<--@TAG-->"

paste("(?<=\\() ([A-Z][0-9]{2}.*) (?=\\))", listCodes[1], sep = "")
paste("\\2", replace, " ", listCodes[1], " ", tag, sep = "")

sub("(?<=\\()([A-Z][0-9]{2}.*)(?=\\))", "hello", text, perl = T)
gsub("F72", "hello", text, perl = T)


listDiagnoses

View(icd10cmDsm5)

text <- "
(F17.209) Mild 

(F71) Moderate 

(F72) Severe 

(F73) Profound
"

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

## Pages
## 125:128 schizophrenia intro
## 128 Scizophrenia start of main body
## 746:758 Other Conditions That May Be a Focus of Clinical Attention

## 759 Section III Emerging Measures and Models (TOC)
## 760 Section III Introduction [@CHAPTER]
## 761:776 Assessment measures [@CHAPTER]
## 777:787 Cultural Formulation [@CHAPTER]
## 788:808 Alternative DSM-5 Model for Personality Disorders [@CHAPTER]
## 809:832 Conditions for Further Study [@CHAPTER]

## 833 Appendix (TOC) [@SECTION]
## 834:841 Highlights of Changes From DSM-IV ti DSM-5 [@CHAPTER]
## 842:856 Glossary of Technical Terms 
## 857:861 Glossary of Cultural Concepts of Distress
## 862 Alphabetical Listing of DSIM-5 Diagnoses and Codes (iCD-9-CM and ICD-10-CM)
## 886 Numerical Listing of DSM-5 Diagnoses and Codes (ICD-9-CM)
## 900:919 Numerical Listing of DSM-5 Diagnoses and Codes (ICD-10-CM)
## 920:939 DSM-5 Advisors and other contributors

## 940:970 Index [@SECTION]
## ======================================================

## List of Section II chapters:
## Neurodevelopmental Disorders	 31
## Schizophrenia Spectrum and Other Psychotic Disorders	87
## Bipolar and Related Disorders	 123
## Depressive Disorders	155
## Anxiety Disorders	189
## Obsessive-Compulsive and Related Disorders	 235
## Trauma- and Stressor-Related Disorders	265
## Dissociative Disorders	291
## Somatic Symptom and Related Disorders	 309
## Feeding and Eating Disorders	 329
## Elimination Disorders	355
## Sleep-Wake Disorders	361
## Sexual Dysfunctions	423
## Gender Dysphoria	451
## Disruptive, Impulse-Control, and Conduct Disorders	461
## Substance-Related and Addictive Disorders	 481
## Neurocognitive Disorders	 591
## Personality Disorders	645
## Paraphilic Disorders	685
## Other Mental Disorders	 707
## Medication-Induced Movement Disorders and Other Adverse Effects of Medication	 709
## Other Conditions That May Be a Focus of Clinical Attention 	 715

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

## sectionTEST <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 611:618) ## "DSM-5 basics". Note that chapter title is a graphic and will not be extracted
## sectionTEST <- paste(sectionTEST, collapse = "") ## collapse to one
## sectionTEST <- gsub("­\n", "", sectionTEST) ## remove - end of line
## sectionTEST <-
##     gsub("(?s)\n(?!\\(|[A-Z]|[0-9]\\.|[0-9]{3,}.*\\(F)", "", sectionTEST, perl=T) ## remove surplus newlines
## removes \n not followed by parens or CAP or number followed by dot
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

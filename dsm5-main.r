#### extract dsm-5 to txt (note this is the old non-revised dsm-5 version)
## Main script for DSM5 extraction
### DSM-5 (not the updated version)

## packages
pacman::p_load(tidyverse, tabulizer, rJava, knitr)

## Functions
source('dsm5-functions.r')

## variables
source('replacement-list.r')
source('page-index.r')
source('dsm5-variables.r')

## Title, preface and more ================
source('dsm5-title.r')

## Section I ===================
source('dsm5-section1.r')

## Section II Diagnostic criteria ==========================
source('dsm5-section2.r')
## TOC
## Preface

## Section III ==============================
## Diagnostic classifications
source("dsm5-neurodevelopmental.r")
source("dsm5-schizophrenia.r")
source("dsm5-bipolar.r") ## also makes a bib entry

## Notes

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


## Tag severity diagnoses
## Note: Working but should perhaps not be used?
## i <- 1
## LIST <-listCodes
## assignTagSub(text, listCodes, listDiagnoses)
## tag <- "<--@TAG-->"
## text <- "
## (F17.209) Mild 

## (F71) Moderate 

## (F72) Severe 

## (F73) Profound
## "

## assignTagSub <- function(CHUNK, LIST, LIST2, tag = "<--@TAG-->", ignore.case = FALSE, replace = "TEST"){
##     ## Assign label 'tag' to strings in CHUNK matching LIST
##     TEMP <- CHUNK
##     for (i in 1:length(LIST)){
##         TEMP <- sub(paste("((?<=\n\\()", LIST[i], "\\.?[0-9]{0,3}", "(?=\\)).*(?=\n))", sep = ""),
##                     paste("\\1", replace, " ", LIST2[i], " ", tag, sep = ""), TEMP,
##                     ignore.case = ignore.case,
##                     perl = T)
##     }
##     return(TEMP)
## }

## Header ref in bookdown {#background}
## <-- @CHAPTER --->
## <-- @GROUP ---> ## Diagnosis group
## <-- @DIAGNOSIS --->
## <-- @SECTION (I-III)--->

## add "icd10 to parens containing these diagnoses"

## test
test <- substr(neurodevelopmentalMain, 1, 25000)


## TODO ================================

## Notes below ===================

## test substring
## test <- substr(neurodevelopmentalMain, nchar(neurodevelopmentalMain)-19000, nchar(neurodevelopmentalMain)-16000)
## gsub("\n\n([A-Z].*\\))(?=(\n\n[A-Z]\\.))", "### \\1", test, perl = T) ## seems to work

## Pages
## 125:128 schizophrenia intro
## 128 Schizophrenia start of main body
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

## Notes on headers =============
## A [diagnosis] has diagnostic criteria and is followed by text on the subject.
## A [diagnosis] can be matched in the code list, but note that CASE is different, so needs case-insensitive matching

## notes ============================

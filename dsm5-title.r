
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
##preface <- cleanNewlinesDot(preface)
preface <- cleanNewlines(preface)
preface <- gsub("\n", "\n\n", preface) ## double newline
preface <- gsub("ΤΙΊΘ A m G riC Sn  P s y c h iâ t r ic", " American Psychiatric", preface)
preface <- gsub("•", "\n•", preface)
writeLines(preface, "preface.txt") ## Foreword

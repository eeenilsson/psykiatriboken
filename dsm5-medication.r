chapterTitle <- "Medication-Induced Movement Disorders and Other Adverse Effects of Medication"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Medication-Induced Movement Disorders and Other Adverse Effects of Medication	 709


## Medication intro and main body
medicationMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 740:745)
## medicationMain[1] <-
##     gsub("(?s).*(?=\nSeparation Medication Disorder)", "", medicationMain[1], perl=T) ## remove redundant text before section starts and 
medicationMain <- paste(medicationMain, collapse = "") ## collapse to one
medicationMain <- cleanText(medicationMain)
medicationMain <- makeHeaders(medicationMain)
medicationMain <- cleanMore(medicationMain)
medicationMain <- gsub(" \n\n", "\n\n", medicationMain, perl=T) ## Remove blanks preceding newline
medicationMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", medicationMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
medicationMain <- gsub("^.*indUCGCl", "Medication Induced", medicationMain) ## remove title and first sentance (not correctly parsed from pdf)
medicationMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), medicationMain) ## Add header to intro
medicationMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), medicationMain) ## Add chapter
medicationMain <- gsub("(?<=[^\n])##", "\n\n##", medicationMain, perl=T) ## ## should be preceded by newline
medicationMain <- gsub("\\,\"", "\"\\,", medicationMain) ## comma before qoutes corrected
medicationMain <- gsub("## The essential", "The essential", medicationMain) ## seems common
medicationMain <- gsub("Disorder 2", "Disorder\n\n2", medicationMain)
medicationMain <- gsub("([a-z])(\n\n)([0-9])", "\\1 \\3", medicationMain) ## newline followed by number and preceded bu letter with no period character

writeLines(medicationMain, "medicationMain.txt")

#### chunk specific replacements
medicationMain <- gsub("[^\n]## Diagnostic Features", "\n\n## Diagnostic Features", medicationMain)
medicationMain <- removeFalseHeader("Discontinuation symptoms may", medicationMain)
medicationMain <- removeFalseHeader("This category is available", medicationMain)

##
## startTag <- "## Inhalant Use Disorder\n\n## Inhalant"
## stopTag <- "Disorders\n\n## Unspecified Inhalant.Related Disorder"
## grep(startTag, medicationMain, perl=T, ignore.case=T)
## grep(stopTag, medicationMain, perl=T, ignore.case=T)
## medicationMain <- cutSection(startTag, stopTag, medicationMain, insert.list=TRUE) ## cut section and insert list


## medicationMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", medicationMain)

writeLines(medicationMain, "medicationMain.txt")

#### table replacement ==================
## medicationMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", medicationMain, perl=T) ## table

### start and stop tags
## startTag <- "(?s)(?<=the clinician should record only the substance.induced medication.compulsive and related disorder.)"
## stopTag <- "F19.988 (?=_Specify)"
## grep(startTag, medicationMain, perl=T) ## test
## grep(stopTag, medicationMain, perl=T) ## test
## ### get Section
## myTable <- getSection(startTag, stopTag, medicationMain)
## myTable <- parseTableUseDisorder(myTable)
## colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
## medicationMain <- gsub(
##     paste(startTag, ".*", stopTag, sep= ""),
##     formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced NNNN Disorder"), medicationMain, perl=T) ## table
## write_csv(myTable, "dsm5-table-p295.csv")
## writeLines(medicationMain, "medicationMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, medicationMain, perl=T) ## test
## grep(stopTag, medicationMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(medicationMain,
##            regexpr(startTag, medicationMain, perl=T)[1],
##            regexpr(stopTag, medicationMain, perl=T)[1]+
##            attr(regexpr(stopTag, medicationMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## medicationMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", medicationMain, perl=T) ## table
## ## insert section
## medicationMain <- gsub("(distress in the context of loss..)(?=\n\n## Medication II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), medicationMain, perl=T)

### Add tags
## assign group tags (none in medication)
medicationMain <- assignTag(medicationMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
medicationMain <- assignTag(medicationMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
medicationMain <- assignTagHeader(medicationMain)

#### write
writeLines(medicationMain, "medicationMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

chapterTitle <- "Other Conditions That May Be a Focus of Clinical Attention"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Other Conditions That May Be a Focus of Clinical Attention 	 715


## Focus intro and main body
focusMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 746:758)
## focusMain[1] <-
##     gsub("(?s).*(?=\nSeparation Focus Disorder)", "", focusMain[1], perl=T) ## remove redundant text before section starts and 
focusMain <- paste(focusMain, collapse = "") ## collapse to one
focusMain <- cleanText(focusMain)
focusMain <- makeHeaders(focusMain)
focusMain <- cleanMore(focusMain)
focusMain <- gsub(" \n\n", "\n\n", focusMain, perl=T) ## Remove blanks preceding newline
focusMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", focusMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
focusMain <- gsub("^.*T h is d is c u s s io n", "This discussion", focusMain) ## remove title and first sentance (not correctly parsed from pdf)
focusMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), focusMain) ## Add header to intro
focusMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), focusMain) ## Add chapter
focusMain <- gsub("(?<=[^\n])##", "\n\n##", focusMain, perl=T) ## ## should be preceded by newline
focusMain <- gsub("\\,\"", "\"\\,", focusMain) ## comma before qoutes corrected
focusMain <- gsub("## The essential", "The essential", focusMain) ## seems common
focusMain <- gsub("Disorder 2", "Disorder\n\n2", focusMain)
focusMain <- gsub("([a-z])(\n\n)([0-9])", "\\1 \\3", focusMain) ## newline followed by number and preceded bu letter with no period character

writeLines(focusMain, "focusMain.txt")

#### chunk specific replacements
focusMain <- gsub("[^\n]## Diagnostic Features", "\n\n## Diagnostic Features", focusMain)
focusMain <- removeFalseHeader("Missing work or school", focusMain)
focusMain <- gsub("for\n\n## Counseling", "for Counseling", focusMain)
focusMain <- gsub("Problems Related to Other Psychosocial, Personal, and Environmental Circumstances ", "\n\n## Problems Related to Other Psychosocial, Personal, and Environmental Circumstances ", focusMain)
focusMain <- gsub("neglect Spouse or Partner Abuse, Psychological", "neglect\n\n ## Spouse or Partner Abuse, Psychological\n\n", focusMain)
focusMain <- gsub("## Problems Related to Other Psychosocial, Personal, and Environmental Circumstances V62.89 \\(Z65.8\\)"
, "## Problems Related to Other Psychosocial, Personal, and Environmental Circumstances\n\nV62.89 (Z65.8) "
, focusMain)


##
## startTag <- "## Inhalant Use Disorder\n\n## Inhalant"
## stopTag <- "Disorders\n\n## Unspecified Inhalant.Related Disorder"
## grep(startTag, focusMain, perl=T, ignore.case=T)
## grep(stopTag, focusMain, perl=T, ignore.case=T)
## focusMain <- cutSection(startTag, stopTag, focusMain, insert.list=TRUE) ## cut section and insert list


## focusMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", focusMain)

writeLines(focusMain, "focusMain.txt")

#### table replacement ==================
## focusMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", focusMain, perl=T) ## table

### start and stop tags
## startTag <- "(?s)(?<=the clinician should record only the substance.induced focus.compulsive and related disorder.)"
## stopTag <- "F19.988 (?=_Specify)"
## grep(startTag, focusMain, perl=T) ## test
## grep(stopTag, focusMain, perl=T) ## test
## ### get Section
## myTable <- getSection(startTag, stopTag, focusMain)
## myTable <- parseTableUseDisorder(myTable)
## colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
## focusMain <- gsub(
##     paste(startTag, ".*", stopTag, sep= ""),
##     formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced NNNN Disorder"), focusMain, perl=T) ## table
## write_csv(myTable, "dsm5-table-p295.csv")
## writeLines(focusMain, "focusMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, focusMain, perl=T) ## test
## grep(stopTag, focusMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(focusMain,
##            regexpr(startTag, focusMain, perl=T)[1],
##            regexpr(stopTag, focusMain, perl=T)[1]+
##            attr(regexpr(stopTag, focusMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## focusMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", focusMain, perl=T) ## table
## ## insert section
## focusMain <- gsub("(distress in the context of loss..)(?=\n\n## Focus II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), focusMain, perl=T)

### Add tags
## assign group tags (none in focus)
focusMain <- assignTag(focusMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
focusMain <- assignTag(focusMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
focusMain <- assignTagHeader(focusMain)

#### write
writeLines(focusMain, "focusMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

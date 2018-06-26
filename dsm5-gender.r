chapterTitle <- "Gender Dysphoria"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Gender Dysphoria	451

## Gender intro and main body
genderMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 486:494)
## genderMain[1] <-
##     gsub("(?s).*(?=\nSeparation Gender Disorder)", "", genderMain[1], perl=T) ## remove redundant text before section starts and 
genderMain <- paste(genderMain, collapse = "") ## collapse to one
genderMain <- cleanText(genderMain)
genderMain <- makeHeaders(genderMain)
genderMain <- cleanMore(genderMain)
genderMain <- gsub(" \n\n", "\n\n", genderMain, perl=T) ## Remove blanks preceding newline
genderMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", genderMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
genderMain <- gsub("^.*C h s p te r ", "In this chapter", genderMain) ## remove title and first sentance (not correctly parsed from pdf)
genderMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), genderMain) ## Add header to intro
genderMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), genderMain) ## Add chapter
genderMain <- gsub("(?<=[^\n])##", "\n\n##", genderMain, perl=T) ## ## should be preceded by newline

writeLines(genderMain, "genderMain.txt")

#### chunk specific replacements
genderMain <- gsub("\n\n#\n\n", "\n\n", genderMain)
genderMain <- gsub("Children 302", "children\n\n302", genderMain)
genderMain <- gsub("\\(F64.2\\)", "\\(F64.2\\)\n\n## Diagnostic Criteria", genderMain)
genderMain <- gsub("## Gender Dysphoria\n\n## Diagnostic Criteria", "## Gender Dysphoria", genderMain)
genderMain <- gsub("Adults 302", "Adults\n\n302", genderMain)
genderMain <- gsub("\\(F64.1 \\)", "\\(F64.1\\)\n\n## Diagnostic Criteria", genderMain)


## genderMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", genderMain)

writeLines(genderMain, "genderMain.txt")

#### table replacement ==================
## genderMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", genderMain, perl=T) ## table

### start and stop tags
## startTag <- "(?s)(?<=the clinician should record only the substance.induced gender.compulsive and related disorder.)"
## stopTag <- "F19.988 (?=_Specify)"
## grep(startTag, genderMain, perl=T) ## test
## grep(stopTag, genderMain, perl=T) ## test
## ### get Section
## myTable <- getSection(startTag, stopTag, genderMain)
## myTable <- parseTableUseDisorder(myTable)
## colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
## genderMain <- gsub(
##     paste(startTag, ".*", stopTag, sep= ""),
##     formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced NNNN Disorder"), genderMain, perl=T) ## table
## write_csv(myTable, "dsm5-table-p295.csv")
## writeLines(genderMain, "genderMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, genderMain, perl=T) ## test
## grep(stopTag, genderMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(genderMain,
##            regexpr(startTag, genderMain, perl=T)[1],
##            regexpr(stopTag, genderMain, perl=T)[1]+
##            attr(regexpr(stopTag, genderMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## genderMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", genderMain, perl=T) ## table
## ## insert section
## genderMain <- gsub("(distress in the context of loss..)(?=\n\n## Gender II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), genderMain, perl=T)

### Add tags
## assign group tags (none in gender)
genderMain <- assignTag(genderMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
genderMain <- assignTag(genderMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
genderMain <- assignTagHeader(genderMain)

#### write
writeLines(genderMain, "genderMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

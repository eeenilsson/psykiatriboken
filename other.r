chapterTitle <- "Other Mental Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Other Mental Disorders	 707

## Other intro and main body
otherMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 738:739)
## otherMain[1] <-
##     gsub("(?s).*(?=\nSeparation Other Disorder)", "", otherMain[1], perl=T) ## remove redundant text before section starts and 
otherMain <- paste(otherMain, collapse = "") ## collapse to one
otherMain <- cleanText(otherMain)
otherMain <- makeHeaders(otherMain)
otherMain <- cleanMore(otherMain)
otherMain <- gsub(" \n\n", "\n\n", otherMain, perl=T) ## Remove blanks preceding newline
otherMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", otherMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
otherMain <- gsub("^.*F o u r d iSO rd G fS", "Four disorders", otherMain) ## remove title and first sentance (not correctly parsed from pdf)
otherMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), otherMain) ## Add header to intro
otherMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), otherMain) ## Add chapter
otherMain <- gsub("(?<=[^\n])##", "\n\n##", otherMain, perl=T) ## ## should be preceded by newline
otherMain <- gsub("\\,\"", "\"\\,", otherMain) ## comma before qoutes corrected
otherMain <- gsub("## The essential", "The essential", otherMain) ## seems common
otherMain <- gsub("Disorder 2", "Disorder\n\n2", otherMain)
otherMain <- gsub("([a-z])(\n\n)([0-9])", "\\1 \\3", otherMain) ## newline followed by number and preceded bu letter with no period character

writeLines(otherMain, "otherMain.txt")

#### chunk specific replacements
otherMain <- gsub("[^\n]## Diagnostic Features", "\n\n## Diagnostic Features", otherMain)
otherMain <- removeFalseHeader("Missing work or school", otherMain) 
otherMain <- gsub("Disorder 3", "Disorder\n\n3", otherMain)

##
## startTag <- "## Inhalant Use Disorder\n\n## Inhalant"
## stopTag <- "Disorders\n\n## Unspecified Inhalant.Related Disorder"
## grep(startTag, otherMain, perl=T, ignore.case=T)
## grep(stopTag, otherMain, perl=T, ignore.case=T)
## otherMain <- cutSection(startTag, stopTag, otherMain, insert.list=TRUE) ## cut section and insert list


## otherMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", otherMain)

writeLines(otherMain, "otherMain.txt")

#### table replacement ==================
## otherMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", otherMain, perl=T) ## table

### start and stop tags
## startTag <- "(?s)(?<=the clinician should record only the substance.induced other.compulsive and related disorder.)"
## stopTag <- "F19.988 (?=_Specify)"
## grep(startTag, otherMain, perl=T) ## test
## grep(stopTag, otherMain, perl=T) ## test
## ### get Section
## myTable <- getSection(startTag, stopTag, otherMain)
## myTable <- parseTableUseDisorder(myTable)
## colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
## otherMain <- gsub(
##     paste(startTag, ".*", stopTag, sep= ""),
##     formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced NNNN Disorder"), otherMain, perl=T) ## table
## write_csv(myTable, "dsm5-table-p295.csv")
## writeLines(otherMain, "otherMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, otherMain, perl=T) ## test
## grep(stopTag, otherMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(otherMain,
##            regexpr(startTag, otherMain, perl=T)[1],
##            regexpr(stopTag, otherMain, perl=T)[1]+
##            attr(regexpr(stopTag, otherMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## otherMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", otherMain, perl=T) ## table
## ## insert section
## otherMain <- gsub("(distress in the context of loss..)(?=\n\n## Other II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), otherMain, perl=T)

### Add tags
## assign group tags (none in other)
otherMain <- assignTag(otherMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
otherMain <- assignTag(otherMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
otherMain <- assignTagHeader(otherMain)

#### write
writeLines(otherMain, "otherMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

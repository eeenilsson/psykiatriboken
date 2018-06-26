chapterTitle <- "Neurocognitive Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Neurocognitive Disorders	 591

## Neurocognitive intro and main body
neurocognitiveMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 624:676)
## neurocognitiveMain[1] <-
##     gsub("(?s).*(?=\nSeparation Neurocognitive Disorder)", "", neurocognitiveMain[1], perl=T) ## remove redundant text before section starts and 
neurocognitiveMain <- paste(neurocognitiveMain, collapse = "") ## collapse to one
neurocognitiveMain <- cleanText(neurocognitiveMain)
neurocognitiveMain <- makeHeaders(neurocognitiveMain)
neurocognitiveMain <- cleanMore(neurocognitiveMain)
neurocognitiveMain <- gsub(" \n\n", "\n\n", neurocognitiveMain, perl=T) ## Remove blanks preceding newline
neurocognitiveMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", neurocognitiveMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
neurocognitiveMain <- gsub("Dementia,\n\n", "Dementia, ", neurocognitiveMain) ## remove title and first sentance (not correctly parsed from pdf)
neurocognitiveMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), neurocognitiveMain) ## Add header to intro
neurocognitiveMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), neurocognitiveMain) ## Add chapter
neurocognitiveMain <- gsub("(?<=[^\n])##", "\n\n##", neurocognitiveMain, perl=T) ## ## should be preceded by newline
neurocognitiveMain <- gsub("\\,\"", "\"\\,", neurocognitiveMain) ## comma before qoutes corrected
neurocognitiveMain <- gsub("## The essential", "The essential", neurocognitiveMain) ## seems common
neurocognitiveMain <- gsub("Disorder 2", "Disorder\n\n2", neurocognitiveMain)

writeLines(neurocognitiveMain, "neurocognitiveMain.txt")

#### chunk specific replacements
## neurocognitiveMain <- gsub("[^\n]## Diagnostic Features", "\n\n## Diagnostic Features", neurocognitiveMain)
## neurocognitiveMain <- removeFalseHeader("Missing work or school", neurocognitiveMain)

neurocognitiveMain <- gsub("A.\n\nB.\n\nA disturbance", "A. A disturbance", neurocognitiveMain)
neurocognitiveMain <- gsub("\n\nThe disturbance develops over a short period of time", "\n\nB. The disturbance develops over a short period of time", neurocognitiveMain)

## table replacements
startTag <- "(?s)(11 i l)"
stopTag <- "k E\\.\n\n"
neurocognitiveMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "\n\n<--REMOVED-TABLE-P593-->\n\n", neurocognitiveMain, perl=T) ## table
## Note: This table may be useful but it is big


## startTag <- "## Inhalant Use Disorder\n\n## Inhalant"
## stopTag <- "Disorders\n\n## Unspecified Inhalant.Related Disorder"
## grep(startTag, neurocognitiveMain, perl=T, ignore.case=T)
## grep(stopTag, neurocognitiveMain, perl=T, ignore.case=T)
## neurocognitiveMain <- cutSection(startTag, stopTag, neurocognitiveMain, insert.list=TRUE) ## cut section and insert list


## neurocognitiveMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", neurocognitiveMain)

writeLines(neurocognitiveMain, "neurocognitiveMain.txt")

#### table replacement ==================
## neurocognitiveMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", neurocognitiveMain, perl=T) ## table

### start and stop tags
startTag <- "(?s)(?<=the clinician should record only the substance intoxication delirium.)"
stopTag <- "9.921 (?=Substance)"
grep(startTag, neurocognitiveMain, perl=T) ## test
grep(stopTag, neurocognitiveMain, perl=T) ## test
### get Section
myTable <- getSection(startTag, stopTag, neurocognitiveMain)

gsub("##(.*)?CM", "", myTable) ## additional cleaning needed

myTable <- parseTableUseDisorder(myTable)
colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
neurocognitiveMain <- gsub(
    paste(startTag, ".*", stopTag, sep= ""),
    formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced NNNN Disorder"), neurocognitiveMain, perl=T) ## table
write_csv(myTable, "dsm5-table-p295.csv")
writeLines(neurocognitiveMain, "neurocognitiveMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, neurocognitiveMain, perl=T) ## test
## grep(stopTag, neurocognitiveMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(neurocognitiveMain,
##            regexpr(startTag, neurocognitiveMain, perl=T)[1],
##            regexpr(stopTag, neurocognitiveMain, perl=T)[1]+
##            attr(regexpr(stopTag, neurocognitiveMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## neurocognitiveMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", neurocognitiveMain, perl=T) ## table
## ## insert section
## neurocognitiveMain <- gsub("(distress in the context of loss..)(?=\n\n## Neurocognitive II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), neurocognitiveMain, perl=T)

### Add tags
## assign group tags (none in neurocognitive)
neurocognitiveMain <- assignTag(neurocognitiveMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
neurocognitiveMain <- assignTag(neurocognitiveMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
neurocognitiveMain <- assignTagHeader(neurocognitiveMain)

#### write
writeLines(neurocognitiveMain, "neurocognitiveMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

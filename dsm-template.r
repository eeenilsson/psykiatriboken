chapterTitle <- "Disruptive, Impulse-Control, and Conduct Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Disruptive, Impulse-Control, and Conduct Disorders	461

## Impulse intro and main body
impulseMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 495:514)
## impulseMain[1] <-
##     gsub("(?s).*(?=\nSeparation Impulse Disorder)", "", impulseMain[1], perl=T) ## remove redundant text before section starts and 
impulseMain <- paste(impulseMain, collapse = "") ## collapse to one
impulseMain <- cleanText(impulseMain)
impulseMain <- makeHeaders(impulseMain)
impulseMain <- cleanMore(impulseMain)
impulseMain <- gsub(" \n\n", "\n\n", impulseMain, perl=T) ## Remove blanks preceding newline
impulseMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", impulseMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
impulseMain <- gsub("^.*SomStiC", "Impulse", impulseMain) ## remove title and first sentance (not correctly parsed from pdf)
impulseMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), impulseMain) ## Add header to intro
impulseMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), impulseMain) ## Add chapter
impulseMain <- gsub("(?<=[^\n])##", "\n\n##", impulseMain, perl=T) ## ## should be preceded by newline

writeLines(impulseMain, "impulseMain.txt")

#### chunk specific replacements
impulseMain <- gsub("[^\n]## Diagnostic Features", "\n\n## Diagnostic Features", impulseMain)

## impulseMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", impulseMain)

writeLines(impulseMain, "impulseMain.txt")

#### table replacement ==================
## impulseMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", impulseMain, perl=T) ## table

### start and stop tags
## startTag <- "(?s)(?<=the clinician should record only the substance.induced impulse.compulsive and related disorder.)"
## stopTag <- "F19.988 (?=_Specify)"
## grep(startTag, impulseMain, perl=T) ## test
## grep(stopTag, impulseMain, perl=T) ## test
## ### get Section
## myTable <- getSection(startTag, stopTag, impulseMain)
## myTable <- parseTableUseDisorder(myTable)
## colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
## impulseMain <- gsub(
##     paste(startTag, ".*", stopTag, sep= ""),
##     formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced NNNN Disorder"), impulseMain, perl=T) ## table
## write_csv(myTable, "dsm5-table-p295.csv")
## writeLines(impulseMain, "impulseMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, impulseMain, perl=T) ## test
## grep(stopTag, impulseMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(impulseMain,
##            regexpr(startTag, impulseMain, perl=T)[1],
##            regexpr(stopTag, impulseMain, perl=T)[1]+
##            attr(regexpr(stopTag, impulseMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## impulseMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", impulseMain, perl=T) ## table
## ## insert section
## impulseMain <- gsub("(distress in the context of loss..)(?=\n\n## Impulse II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), impulseMain, perl=T)

### Add tags
## assign group tags (none in impulse)
impulseMain <- assignTag(impulseMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
impulseMain <- assignTag(impulseMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
impulseMain <- assignTagHeader(impulseMain)

#### write
writeLines(impulseMain, "impulseMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

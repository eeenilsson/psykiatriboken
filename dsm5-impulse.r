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
impulseMain <- gsub("^.*C O n tro l", "Disruptive, Impulse-Control", impulseMain) ## remove title and first sentance (not correctly parsed from pdf)
impulseMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), impulseMain) ## Add header to intro
impulseMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), impulseMain) ## Add chapter
impulseMain <- gsub("(?<=[^\n])##", "\n\n##", impulseMain, perl=T) ## ## should be preceded by newline

writeLines(impulseMain, "impulseMain.txt")

#### chunk specific replacements
impulseMain <- gsub("## One-year prevalence data", "One-year prevalence data", impulseMain)
impulseMain <- gsub("about\n\n2", "about 2", impulseMain)
impulseMain <- gsub("## The essential", "The essential", impulseMain)

## impulseMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", impulseMain)

writeLines(impulseMain, "impulseMain.txt")

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

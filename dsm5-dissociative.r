chapterTitle <- "Dissociative Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Dissociative Disorders	291

source('replacement-list.r') ## ## Diagnostic Marlcers not replaced??

## Dissociative disorders intro
dissociativeIntro <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 328:329)
dissociativeIntro <- paste(dissociativeIntro, collapse = "")
dissociativeIntro <- cleanText(dissociativeIntro)
dissociativeIntro <- makeHeaders(dissociativeIntro)
dissociativeIntro <- cleanMore(dissociativeIntro)
## dissociativeIntro <- gsub("## Separation.*$", "", dissociativeIntro) ## remove start of next
dissociativeIntro <- gsub("DiSSOCi.tiVG d isorders", "Dissociative disorders", dissociativeIntro)
dissociativeIntro <- gsub("^", "##i Introduction to Dissociative Disorders\n\n", dissociativeIntro) ## Add header to intro
dissociativeIntro <- gsub("and \n\nGanser", "and Ganser", dissociativeIntro)
dissociativeIntro <- gsub("## Dissociative Identity.*$", "", dissociativeIntro) ## remove beginning of next section
writeLines(dissociativeIntro, "dissociativeIntro.txt")

## Dissociative main body
dissociativeMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 329:344)
dissociativeMain[1] <-
    gsub("(?s).*(?=\nDissociative Identity Disorder)", "", dissociativeMain[1], perl=T) ## remove redundant text before section starts 
dissociativeMain <- paste(dissociativeMain, collapse = "") ## collapse to one
dissociativeMain <- cleanText(dissociativeMain)
dissociativeMain <- makeHeaders(dissociativeMain)
dissociativeMain <- cleanMore(dissociativeMain)
## dissociativeMain <- gsub("(## )([^\n]*)(\n\n## )", "## \\2", dissociativeMain) ## removes broken headers. Affects true headers followed by true headers
dissociativeMain <- gsub(" \n\n", "\n\n", dissociativeMain, perl=T) ## Remove blanks preceding newline
dissociativeMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", dissociativeMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline

writeLines(dissociativeMain, "dissociativeMain.txt")


#### chunk specific replacements
dissociativeMain <- gsub("## Examples", "Examples", dissociativeMain)

writeLines(dissociativeMain, "dissociativeMain.txt")

#### table replacement ==================
## None

### Add tags
## assign group tags (none in dissociative)
dissociativeMain <- assignTag(dissociativeMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
dissociativeMain <- assignTag(dissociativeMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
dissociativeMain <- assignTagHeader(dissociativeMain)

#### write
writeLines(dissociativeMain, "dissociativeMain.txt")

## Join intro to main
dissociativeMain <- paste(dissociativeIntro, dissociativeMain, sep = "\n\n") ## join
## dissociativeMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), dissociativeMain) ## Add header to intro
dissociativeMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), dissociativeMain) ## Add chapter
writeLines(dissociativeMain, "dissociativeMain.txt")

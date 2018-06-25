chapterTitle <- "Trauma- and Stressor-Related Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Trauma- and Stressor-Related Disorders	265

source('replacement-list.r') ## ## Diagnostic Marlcers not replaced??

## Obsessive disorders intro
traumaIntro <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 302)
traumaIntro <- paste(traumaIntro, collapse = "")
traumaIntro <- cleanText(traumaIntro)
traumaIntro <- makeHeaders(traumaIntro)
traumaIntro <- cleanMore(traumaIntro)
traumaIntro <- gsub("## Reactive Attachment Disorder.*$", "", traumaIntro) ## remove start of next
traumaIntro <- gsub("^", "## Introduction to ", traumaIntro) ## Add header to intro
traumaIntro <- gsub("and \n\n## Stressor", "and Stressor", traumaIntro)
traumaIntro <- gsub("T r3 U m 3 - â n d StrG SSO r-rG l..G d", "Trauma- and Stressor-Related Disorders", traumaIntro)
writeLines(traumaIntro, "traumaIntro.txt")

## Trauma main body
traumaMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 302:327)
traumaMain[1] <-
    gsub("(?s).*(?=\nReactive Attachment Disorder)", "", traumaMain[1], perl=T) ## remove redundant text before section starts and 
traumaMain <- paste(traumaMain, collapse = "") ## collapse to one
traumaMain <- cleanText(traumaMain)
traumaMain <- makeHeaders(traumaMain)
traumaMain <- cleanMore(traumaMain)
## traumaMain <- gsub("(## )([^\n]*)(\n\n## )", "## \\2", traumaMain) ## removes broken headers. Affects true headers followed by true headers
traumaMain <- gsub(" \n\n", "\n\n", traumaMain, perl=T) ## Remove blanks preceding newline
traumaMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", traumaMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline

writeLines(traumaMain, "traumaMain.txt")


#### chunk specific replacements
traumaMain <- gsub("## Examples", "Examples", traumaMain)
traumaMain <- gsub("and\n\n##", "and", traumaMain)

writeLines(traumaMain, "traumaMain.txt")

#### table replacement ==================
## None in trauma

### Add tags
## assign group tags (none in trauma)
traumaMain <- assignTag(traumaMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
traumaMain <- assignTag(traumaMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
traumaMain <- assignTagHeader(traumaMain)

#### write
writeLines(traumaMain, "traumaMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

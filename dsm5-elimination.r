chapterTitle <- "Elimination Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Elimination Disorders	355

## Somatic intro and main body
eliminationMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 390:395)
## eliminationMain[1] <-
##     gsub("(?s).*(?=\nSeparation Elimination Disorder)", "", eliminationMain[1], perl=T) ## remove redundant text before section starts and 
eliminationMain <- paste(eliminationMain, collapse = "") ## collapse to one
eliminationMain <- cleanText(eliminationMain)
eliminationMain <- makeHeaders(eliminationMain)
eliminationMain <- cleanMore(eliminationMain)
eliminationMain <- gsub(" \n\n", "\n\n", eliminationMain, perl=T) ## Remove blanks preceding newline
eliminationMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", eliminationMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
eliminationMain <- gsub("^.*Elimin3tion diSOrdGrSal l", "Elimination Disorders all", eliminationMain) ## remove title and first sentance (not correctly parsed from pdf)
eliminationMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), eliminationMain) ## Add header to intro
eliminationMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), eliminationMain) ## Add chapter

writeLines(eliminationMain, "eliminationMain.txt")

#### chunk specific replacements
## None
writeLines(eliminationMain, "eliminationMain.txt")

#### table replacement ==================
## None

### Add tags
## assign group tags (none in elimination)
eliminationMain <- assignTag(eliminationMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
eliminationMain <- assignTag(eliminationMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
eliminationMain <- assignTagHeader(eliminationMain)

#### write
writeLines(eliminationMain, "eliminationMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

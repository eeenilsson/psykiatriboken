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
traumaMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 302:)
## traumaMain[1] <-
##     gsub("(?s).*(?=\nSeparation Trauma Disorder)", "", traumaMain[1], perl=T) ## remove redundant text before section starts and 
traumaMain <- paste(traumaMain, collapse = "") ## collapse to one
traumaMain <- cleanText(traumaMain)
traumaMain <- makeHeaders(traumaMain)
traumaMain <- cleanMore(traumaMain)
## traumaMain <- gsub("(## )([^\n]*)(\n\n## )", "## \\2", traumaMain) ## removes broken headers. Affects true headers followed by true headers
traumaMain <- gsub(" \n\n", "\n\n", traumaMain, perl=T) ## Remove blanks preceding newline
traumaMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", traumaMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline

writeLines(traumaMain, "traumaMain.txt")


#### chunk specific replacements
traumaMain <- gsub("Trauma-Compulsive Disorder i", "## Trauma-Compulsive Disorder", traumaMain)
traumaMain <- gsub("## These beliefs", "These beliefs", traumaMain)
traumaMain <- gsub("## OCD try", "OCD try", traumaMain)
traumaMain <- gsub("## The essential features", "The essential features", traumaMain)
traumaMain <- gsub("attention ##", "attention.\n\n ##", traumaMain)
traumaMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", traumaMain)

writeLines(traumaMain, "traumaMain.txt")

#### table replacement ==================
## traumaMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", traumaMain, perl=T) ## table

### start and stop tags
startTag <- "(?s)(?<=the clinician should record only the substance.induced trauma.compulsive and related disorder.)"
stopTag <- "F19.988 (?=_Specify)"
grep(startTag, traumaMain, perl=T) ## test
grep(stopTag, traumaMain, perl=T) ## test
### get Section
myTable <- getSection(startTag, stopTag, traumaMain)
myTable <- parseTableUseDisorder(myTable)
colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
traumaMain <- gsub(
    paste(startTag, ".*", stopTag, sep= ""),
    formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced Trauma-Compulsive Disorder"), traumaMain, perl=T) ## table
write_csv(myTable, "dsm5-table-p295.csv")
writeLines(traumaMain, "traumaMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, traumaMain, perl=T) ## test
## grep(stopTag, traumaMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(traumaMain,
##            regexpr(startTag, traumaMain, perl=T)[1],
##            regexpr(stopTag, traumaMain, perl=T)[1]+
##            attr(regexpr(stopTag, traumaMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## traumaMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", traumaMain, perl=T) ## table
## ## insert section
## traumaMain <- gsub("(distress in the context of loss..)(?=\n\n## Trauma II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), traumaMain, perl=T)

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

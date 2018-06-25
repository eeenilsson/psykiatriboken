### Anxiety Disorders  ==============
chapterTitle <- "Anxiety Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Anxiety Disorders	189

source('replacement-list.r') ## ## Diagnostic Marlcers not replaced??

## Anxiety disorders intro
anxietyIntro <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 227:228)
anxietyIntro <- paste(anxietyIntro, collapse = "")
anxietyIntro <- cleanText(anxietyIntro)
anxietyIntro <- gsub("^", paste("## Introduction to ", chapterTitle, "\n\n", sep=""), anxietyIntro) ## Add header to intro
anxietyIntro <- makeHeaders(anxietyIntro)
anxietyIntro <- gsub("A n x ie ty  diSOrdGrS", "Anxiety disorders", anxietyIntro)
anxietyIntro <- gsub("## Separation.*$", "", anxietyIntro) ## remove start of next
writeLines(anxietyIntro, "anxietyIntro.txt")

## Anxiety main body
anxietyMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 228:271)
anxietyMain[1] <-
    gsub("(?s).*(?=\nSeparation Anxiety Disorder)", "", anxietyMain[1], perl=T) ## remove redundant text before section starts and 
anxietyMain <- paste(anxietyMain, collapse = "") ## collapse to one
anxietyMain <- cleanText(anxietyMain)
anxietyMain <- makeHeaders(anxietyMain)
anxietyMain <- cleanMore(anxietyMain)
## anxietyMain <- gsub("(## )([^\n]*)(\n\n## )", "## \\2", anxietyMain) ## removes broken headers. Affects true headers followed by true headers
anxietyMain <- gsub(" \n\n", "\n\n", anxietyMain, perl=T) ## Remove blanks preceding newline
anxietyMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", anxietyMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline

writeLines(anxietyMain, "anxietyMain.txt")


#### chunk specific replacements
## None?

writeLines(anxietyMain, "anxietyMain.txt")

#### table replacement ==================
## anxietyMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", anxietyMain, perl=T) ## table

### start and stop tags
startTag <- "(?s)(?<=the clinician should record only the substance.induced anxiety disorder.)"
stopTag <- "FI 9.980 (?=_Specify)"
grep(startTag, anxietyMain, perl=T) ## test
grep(stopTag, anxietyMain, perl=T) ## test
### get Section
myTable <- getSection(startTag, stopTag, anxietyMain)
myTable <- parseTableUseDisorder(myTable)
colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
anxietyMain <- gsub(
    paste(startTag, ".*", stopTag, sep= ""),
    formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced Anxiety Disorder"), anxietyMain, perl=T) ## table
write_csv(myTable, "dsm5-table-p176.csv")
writeLines(anxietyMain, "anxietyMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, anxietyMain, perl=T) ## test
## grep(stopTag, anxietyMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(anxietyMain,
##            regexpr(startTag, anxietyMain, perl=T)[1],
##            regexpr(stopTag, anxietyMain, perl=T)[1]+
##            attr(regexpr(stopTag, anxietyMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## anxietyMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", anxietyMain, perl=T) ## table
## ## insert section
## anxietyMain <- gsub("(distress in the context of loss..)(?=\n\n## Anxiety II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), anxietyMain, perl=T)

### Add tags
## assign group tags (none in anxiety)
anxietyMain <- assignTag(anxietyMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
anxietyMain <- assignTag(anxietyMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
anxietyMain <- assignTagHeader(anxietyMain)

#### write
writeLines(anxietyMain, "anxietyMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

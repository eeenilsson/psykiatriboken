### Anxiety Disorders  ==============
chapterTitle <- "Obsessive-Compulsive and Related Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Obsessive-Compulsive and Related Disorders	 235

source('replacement-list.r') ## ## Diagnostic Marlcers not replaced??

## Obsessive disorders intro
obsessiveIntro <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 272:273)
obsessiveIntro <- paste(obsessiveIntro, collapse = "")
obsessiveIntro <- cleanText(obsessiveIntro)
obsessiveIntro <- makeHeaders(obsessiveIntro)
obsessiveIntro <- cleanMore(obsessiveIntro)
## obsessiveIntro <- gsub("## Separation.*$", "", obsessiveIntro) ## remove start of next
obsessiveIntro <- gsub("^", "## Introduction to ", obsessiveIntro) ## Add header to intro
obsessiveIntro <- gsub("O bSG SSiV G -C O m pu lsiV G", "Obsessive-Compulsive", obsessiveIntro)
writeLines(obsessiveIntro, "obsessiveIntro.txt")

## Obsessive main body
obsessiveMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 274:301)
## obsessiveMain[1] <-
##     gsub("(?s).*(?=\nSeparation Obsessive Disorder)", "", obsessiveMain[1], perl=T) ## remove redundant text before section starts and 
obsessiveMain <- paste(obsessiveMain, collapse = "") ## collapse to one
obsessiveMain <- cleanText(obsessiveMain)
obsessiveMain <- makeHeaders(obsessiveMain)
obsessiveMain <- cleanMore(obsessiveMain)
## obsessiveMain <- gsub("(## )([^\n]*)(\n\n## )", "## \\2", obsessiveMain) ## removes broken headers. Affects true headers followed by true headers
obsessiveMain <- gsub(" \n\n", "\n\n", obsessiveMain, perl=T) ## Remove blanks preceding newline
obsessiveMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", obsessiveMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline

writeLines(obsessiveMain, "obsessiveMain.txt")


#### chunk specific replacements
obsessiveMain <- gsub("Obsessive-Compulsive Disorder i", "## Obsessive-Compulsive Disorder", obsessiveMain)
obsessiveMain <- gsub("## These beliefs", "These beliefs", obsessiveMain)
obsessiveMain <- gsub("## OCD try", "OCD try", obsessiveMain)
obsessiveMain <- gsub("## The essential features", "The essential features", obsessiveMain)
obsessiveMain <- gsub("attention ##", "attention.\n\n ##", obsessiveMain)

writeLines(obsessiveMain, "obsessiveMain.txt")

#### table replacement ==================
## obsessiveMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", obsessiveMain, perl=T) ## table

### start and stop tags
startTag <- "(?s)(?<=the clinician should record only the substance.induced obsessive disorder.)"
stopTag <- "FI 9.980 (?=_Specify)"
grep(startTag, obsessiveMain, perl=T) ## test
grep(stopTag, obsessiveMain, perl=T) ## test
### get Section
myTable <- getSection(startTag, stopTag, obsessiveMain)
myTable <- parseTableUseDisorder(myTable)
colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
obsessiveMain <- gsub(
    paste(startTag, ".*", stopTag, sep= ""),
    formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced Obsessive Disorder"), obsessiveMain, perl=T) ## table
write_csv(myTable, "dsm5-table-p176.csv")
writeLines(obsessiveMain, "obsessiveMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, obsessiveMain, perl=T) ## test
## grep(stopTag, obsessiveMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(obsessiveMain,
##            regexpr(startTag, obsessiveMain, perl=T)[1],
##            regexpr(stopTag, obsessiveMain, perl=T)[1]+
##            attr(regexpr(stopTag, obsessiveMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## obsessiveMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", obsessiveMain, perl=T) ## table
## ## insert section
## obsessiveMain <- gsub("(distress in the context of loss..)(?=\n\n## Obsessive II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), obsessiveMain, perl=T)

### Add tags
## assign group tags (none in obsessive)
obsessiveMain <- assignTag(obsessiveMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
obsessiveMain <- assignTag(obsessiveMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
obsessiveMain <- assignTagHeader(obsessiveMain)

#### write
writeLines(obsessiveMain, "obsessiveMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

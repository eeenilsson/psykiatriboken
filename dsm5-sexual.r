chapterTitle <- "Sexual Dysfunctions"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Sexual Dysfunctions	423

## Sexual intro and main body
sexualMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 458:485)
## sexualMain[1] <-
##     gsub("(?s).*(?=\nSeparation Sexual Disorder)", "", sexualMain[1], perl=T) ## remove redundant text before section starts and 
sexualMain <- paste(sexualMain, collapse = "") ## collapse to one
sexualMain <- cleanText(sexualMain)
sexualMain <- makeHeaders(sexualMain)
sexualMain <- cleanMore(sexualMain)
sexualMain <- gsub(" \n\n", "\n\n", sexualMain, perl=T) ## Remove blanks preceding newline
sexualMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", sexualMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
sexualMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), sexualMain) ## Add header to intro
sexualMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), sexualMain) ## Add chapter
sexualMain <- gsub("(?<=[^\n])##", "\n\n##", sexualMain, perl=T) ## ## should be preceded by newline

writeLines(sexualMain, "sexualMain.txt")

#### chunk specific replacements
sexualMain <- gsub("## Marked tensing", "Marked tensing", sexualMain)
sexualMain <- gsub("'’", "\"", sexualMain)
sexualMain <- gsub(",”", "”,", sexualMain)

writeLines(sexualMain, "sexualMain.txt")

#### table replacement ==================

### start and stop tags
startTag <- "(?s)(?<=the clinician should record only the substance.induced sexual dysfunction.)\n\n##"
stopTag <- "FI 9.981 (?=Specify)"
grep(startTag, sexualMain, perl=T) ## test
grep(stopTag, sexualMain, perl=T) ## test
### get Section
myTable <- getSection(startTag, stopTag, sexualMain)
myTable <- parseTableUseDisorder(myTable)
colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
sexualMain <- gsub(
    paste(startTag, ".*", stopTag, sep= ""),
    formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced Sexual Dysfunction"), sexualMain, perl=T) ## table
write_csv(myTable, "dsm5-table-p295.csv")
writeLines(sexualMain, "sexualMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, sexualMain, perl=T) ## test
## grep(stopTag, sexualMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(sexualMain,
##            regexpr(startTag, sexualMain, perl=T)[1],
##            regexpr(stopTag, sexualMain, perl=T)[1]+
##            attr(regexpr(stopTag, sexualMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## sexualMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", sexualMain, perl=T) ## table
## ## insert section
## sexualMain <- gsub("(distress in the context of loss..)(?=\n\n## Sexual II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), sexualMain, perl=T)

### Add tags
## assign group tags (none in sexual)
sexualMain <- assignTag(sexualMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
sexualMain <- assignTag(sexualMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
sexualMain <- assignTagHeader(sexualMain)

#### write
writeLines(sexualMain, "sexualMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

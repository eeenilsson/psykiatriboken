chapterTitle <- "Sleep-Wake Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Sleep-Wake Disorders	361

## Sleep intro and main body
sleepMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 396:457)
## sleepMain[1] <-
##     gsub("(?s).*(?=\nSeparation Sleep Disorder)", "", sleepMain[1], perl=T) ## remove redundant text before section starts and 
sleepMain <- paste(sleepMain, collapse = "") ## collapse to one
sleepMain <- cleanText(sleepMain)
sleepMain <- makeHeaders(sleepMain)
sleepMain <- cleanMore(sleepMain)
sleepMain <- gsub(" \n\n", "\n\n", sleepMain, perl=T) ## Remove blanks preceding newline
sleepMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", sleepMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
sleepMain <- gsub("^.*Cl3SS ifiC3tion", "The DSM-5 classification", sleepMain) ## remove title and first sentance (not correctly parsed from pdf)
sleepMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), sleepMain) ## Add header to intro
sleepMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), sleepMain) ## Add chapter

writeLines(sleepMain, "sleepMain.txt")

#### chunk specific replacements
## sleepMain <- gsub("## The principles", "The principles", sleepMain)
sleepMain <- gsub("## The weight of", "The weight of", sleepMain)
sleepMain <- gsub("Classification of\n\n##", "Classification of", sleepMain)
sleepMain <- gsub("## Narcolepsy.cataplexy nearly", "Narcolepsy-cataplexy nearly", sleepMain)
sleepMain <- gsub("international Classification", "International Classification", sleepMain)
sleepMain <- gsub("(?<=[^\n])##", "\n\n##", sleepMain, perl=T) ## ## should be preceded by newline
sleepMain <- gsub("condition.[\\\\] ", "condition.", sleepMain)
sleepMain <- gsub("isexacerbating", "is exacerbating", sleepMain)
sleepMain <- gsub("Type[\\\\] ", "Type ", sleepMain)
sleepMain <- gsub("Type[\\\\] ", "Type ", sleepMain) ## needs repeat?
sleepMain <- gsub("Movement\n\n## Sleep", "Movement Sleep", sleepMain)
sleepMain <- gsub("## During sleep onset", "During sleep onset", sleepMain)
sleepMain <- gsub("of\n\n## Sleep", "of Sleep", sleepMain)
sleepMain <- gsub("## REM sleep behavior disorder is", "REM sleep behavior disorder is", sleepMain)
sleepMain <- gsub("the\n\nInternational", "the International", sleepMain)
sleepMain <- gsub("## Prevalence rates of", "Prevalence rates of", sleepMain)
sleepMain <- gsub("to\n\n7", "to 7", sleepMain)
sleepMain <- gsub("## The essential", "The essential", sleepMain)

writeLines(sleepMain, "sleepMain.txt")

#### table replacement ==================
### start and stop tags
startTag <- "(?s)(?<=discontinuation of the substance/medication.)\n\n## ICD-9-CM"
stopTag <- "FI 9.982(?= \n\n##)"
grep(startTag, sleepMain, perl=T) ## test
grep(stopTag, sleepMain, perl=T) ## test

### get Section
myTable <- getSection(startTag, stopTag, sleepMain)
myTable <- parseTableUseDisorder(myTable)
colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
sleepMain <- gsub(
    paste(startTag, ".*", stopTag, sep= ""),
    formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced Sleep Disorder"), sleepMain, perl=T) ## table
write_csv(myTable, "dsm5-table-p450.csv")
writeLines(sleepMain, "sleepMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, sleepMain, perl=T) ## test
## grep(stopTag, sleepMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(sleepMain,
##            regexpr(startTag, sleepMain, perl=T)[1],
##            regexpr(stopTag, sleepMain, perl=T)[1]+
##            attr(regexpr(stopTag, sleepMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## sleepMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", sleepMain, perl=T) ## table
## ## insert section
## sleepMain <- gsub("(distress in the context of loss..)(?=\n\n## Sleep II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), sleepMain, perl=T)

### Add tags
## assign group tags (none in sleep)
sleepMain <- assignTag(sleepMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
sleepMain <- assignTag(sleepMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
sleepMain <- assignTagHeader(sleepMain)

#### write
writeLines(sleepMain, "sleepMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

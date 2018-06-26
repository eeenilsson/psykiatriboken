chapterTitle <- "Feeding and Eating Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Feeding and Eating Disorders	 329

## Feeding intro and main body
feedingMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 364:389)
feedingMain <- paste(feedingMain, collapse = "") ## collapse to one
feedingMain <- cleanText(feedingMain)
feedingMain <- makeHeaders(feedingMain)
feedingMain <- cleanMore(feedingMain)
feedingMain <- gsub(" \n\n", "\n\n", feedingMain, perl=T) ## Remove blanks preceding newline
feedingMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", feedingMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
feedingMain <- gsub("^.*pGGdiriQ ând GSting disorders", "Feeding and Eating disorders", feedingMain) ## remove title and first sentance (not correctly parsed from pdf)
feedingMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), feedingMain) ## Add header to intro
feedingMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), feedingMain) ## Add chapter

writeLines(feedingMain, "feedingMain.txt")

#### chunk specific replacements
feedingMain <- gsub("condition, ##", "condition.\n\n##", feedingMain)
feedingMain <- gsub("## Mild", "Mild", feedingMain)
feedingMain <- gsub("## Extreme", "Extreme", feedingMain)
feedingMain <- gsub("## The 12-month", "The 12-month", feedingMain)
feedingMain <- gsub("approximately\n\n0", "approximately 0", feedingMain)
feedingMain <- gsub("## There are three", "There are three", feedingMain)
feedingMain <- gsub("gain\n\n\\(", "gain \\(", feedingMain)

feedingMain <- gsub("([^\n])##", "\\1\n\n##", feedingMain) ## hash should always be preceded by newline. Needs to come after chunk-specific replacements
writeLines(feedingMain, "feedingMain.txt")

## feedingMain <- gsub("## The principles", "The principles", feedingMain)
## feedingMain <- gsub("from\n\nDSM", "from DSM", feedingMain)
## feedingMain <- gsub("## Prevalence estimates of", "Prevalence estimates of", feedingMain)
## feedingMain <- gsub("against resistance.\n## ", "against resistance.\n", feedingMain)
## feedingMain <- gsub("Affecting\n\n## Other", "Affecting Other", feedingMain)
## feedingMain <- gsub("Factors\n\n## Affecting", "Factors Affecting", feedingMain)
## feedingMain <- gsub("[^\n]## Diagnostic Features", "\n\n## Diagnostic Features", feedingMain)

## feedingMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", feedingMain)

#### table replacement ==================
## feedingMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", feedingMain, perl=T) ## table

### start and stop tags
## startTag <- "(?s)(?<=the clinician should record only the substance.induced feeding.compulsive and related disorder.)"
## stopTag <- "F19.988 (?=_Specify)"
## grep(startTag, feedingMain, perl=T) ## test
## grep(stopTag, feedingMain, perl=T) ## test
## ### get Section
## myTable <- getSection(startTag, stopTag, feedingMain)
## myTable <- parseTableUseDisorder(myTable)
## colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
## feedingMain <- gsub(
##     paste(startTag, ".*", stopTag, sep= ""),
##     formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced Feeding-Compulsive Disorder"), feedingMain, perl=T) ## table
## write_csv(myTable, "dsm5-table-p295.csv")
## writeLines(feedingMain, "feedingMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, feedingMain, perl=T) ## test
## grep(stopTag, feedingMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(feedingMain,
##            regexpr(startTag, feedingMain, perl=T)[1],
##            regexpr(stopTag, feedingMain, perl=T)[1]+
##            attr(regexpr(stopTag, feedingMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## feedingMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", feedingMain, perl=T) ## table
## ## insert section
## feedingMain <- gsub("(distress in the context of loss..)(?=\n\n## Feeding II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), feedingMain, perl=T)

### Add tags
## assign group tags (none in feeding)
feedingMain <- assignTag(feedingMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
feedingMain <- assignTag(feedingMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
feedingMain <- assignTagHeader(feedingMain)

#### write
writeLines(feedingMain, "feedingMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

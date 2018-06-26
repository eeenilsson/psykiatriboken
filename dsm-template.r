chapterTitle <- "Somatic Symptom and Related Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Somatic Symptom and Related Disorders	 309

## Somatic intro and main body
somaticMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 345:363)
## somaticMain[1] <-
##     gsub("(?s).*(?=\nSeparation Somatic Disorder)", "", somaticMain[1], perl=T) ## remove redundant text before section starts and 
somaticMain <- paste(somaticMain, collapse = "") ## collapse to one
somaticMain <- cleanText(somaticMain)
somaticMain <- makeHeaders(somaticMain)
somaticMain <- cleanMore(somaticMain)
somaticMain <- gsub(" \n\n", "\n\n", somaticMain, perl=T) ## Remove blanks preceding newline
somaticMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", somaticMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
somaticMain <- gsub("^.*SomStiC", "Somatic", somaticMain) ## remove title and first sentance (not correctly parsed from pdf)
somaticMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), somaticMain) ## Add header to intro
somaticMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), somaticMain) ## Add chapter
somaticMain <- gsub("(?<=[^\n])##", "\n\n##", somaticMain, perl=T) ## ## should be preceded by newline

writeLines(somaticMain, "somaticMain.txt")

#### chunk specific replacements
somaticMain <- gsub("[^\n]## Diagnostic Features", "\n\n## Diagnostic Features", somaticMain)

## somaticMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", somaticMain)

writeLines(somaticMain, "somaticMain.txt")

#### table replacement ==================
## somaticMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", somaticMain, perl=T) ## table

### start and stop tags
## startTag <- "(?s)(?<=the clinician should record only the substance.induced somatic.compulsive and related disorder.)"
## stopTag <- "F19.988 (?=_Specify)"
## grep(startTag, somaticMain, perl=T) ## test
## grep(stopTag, somaticMain, perl=T) ## test
## ### get Section
## myTable <- getSection(startTag, stopTag, somaticMain)
## myTable <- parseTableUseDisorder(myTable)
## colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
## somaticMain <- gsub(
##     paste(startTag, ".*", stopTag, sep= ""),
##     formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced Somatic-Compulsive Disorder"), somaticMain, perl=T) ## table
## write_csv(myTable, "dsm5-table-p295.csv")
## writeLines(somaticMain, "somaticMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, somaticMain, perl=T) ## test
## grep(stopTag, somaticMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(somaticMain,
##            regexpr(startTag, somaticMain, perl=T)[1],
##            regexpr(stopTag, somaticMain, perl=T)[1]+
##            attr(regexpr(stopTag, somaticMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## somaticMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", somaticMain, perl=T) ## table
## ## insert section
## somaticMain <- gsub("(distress in the context of loss..)(?=\n\n## Somatic II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), somaticMain, perl=T)

### Add tags
## assign group tags (none in somatic)
somaticMain <- assignTag(somaticMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
somaticMain <- assignTag(somaticMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
somaticMain <- assignTagHeader(somaticMain)

#### write
writeLines(somaticMain, "somaticMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

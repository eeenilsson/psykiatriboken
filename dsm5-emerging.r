chapterTitle <- "Emerging Measures and Models"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Section III Emerging Measures and Models

## Emerging intro and main body
emergingMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 760:832)
## emergingMain[1] <-
##     gsub("(?s).*(?=\nSeparation Emerging Disorder)", "", emergingMain[1], perl=T) ## remove redundant text before section starts and 
emergingMain <- paste(emergingMain, collapse = "") ## collapse to one
emergingMain <- cleanText(emergingMain)
emergingMain <- makeHeaders(emergingMain)
emergingMain <- cleanMore(emergingMain)
emergingMain <- gsub(" \n\n", "\n\n", emergingMain, perl=T) ## Remove blanks preceding newline
emergingMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", emergingMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
emergingMain <- gsub("^.*SomStiC", "Emerging", emergingMain) ## remove title and first sentance (not correctly parsed from pdf)
emergingMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), emergingMain) ## Add header to intro
emergingMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), emergingMain) ## Add chapter
emergingMain <- gsub("(?<=[^\n])##", "\n\n##", emergingMain, perl=T) ## ## should be preceded by newline
emergingMain <- gsub("\\,\"", "\"\\,", emergingMain) ## comma before qoutes corrected
emergingMain <- gsub("## The essential", "The essential", emergingMain) ## seems common
emergingMain <- gsub("Disorder 2", "Disorder\n\n2", emergingMain)
emergingMain <- gsub("([a-z])(\n\n)([0-9])", "\\1 \\3", emergingMain) ## newline followed by number and preceded bu letter with no period character

writeLines(emergingMain, "emergingMain.txt")

#### chunk specific replacements
emergingMain <- gsub("[^\n]## Diagnostic Features", "\n\n## Diagnostic Features", emergingMain)
emergingMain <- removeFalseHeader("Missing work or school", emergingMain)
emergingMain <- gsub("Assessment\n\n## Measures", "Assessment Measures", emergingMain)



##
## startTag <- "## Inhalant Use Disorder\n\n## Inhalant"
## stopTag <- "Disorders\n\n## Unspecified Inhalant.Related Disorder"
## grep(startTag, emergingMain, perl=T, ignore.case=T)
## grep(stopTag, emergingMain, perl=T, ignore.case=T)
## emergingMain <- cutSection(startTag, stopTag, emergingMain, insert.list=TRUE) ## cut section and insert list


## emergingMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", emergingMain)

writeLines(emergingMain, "emergingMain.txt")

#### table replacement ==================
## emergingMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", emergingMain, perl=T) ## table

### start and stop tags
## startTag <- "(?s)(?<=the clinician should record only the substance.induced emerging.compulsive and related disorder.)"
## stopTag <- "F19.988 (?=_Specify)"
## grep(startTag, emergingMain, perl=T) ## test
## grep(stopTag, emergingMain, perl=T) ## test
## ### get Section
## myTable <- getSection(startTag, stopTag, emergingMain)
## myTable <- parseTableUseDisorder(myTable)
## colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
## emergingMain <- gsub(
##     paste(startTag, ".*", stopTag, sep= ""),
##     formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced NNNN Disorder"), emergingMain, perl=T) ## table
## write_csv(myTable, "dsm5-table-p295.csv")
## writeLines(emergingMain, "emergingMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, emergingMain, perl=T) ## test
## grep(stopTag, emergingMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(emergingMain,
##            regexpr(startTag, emergingMain, perl=T)[1],
##            regexpr(stopTag, emergingMain, perl=T)[1]+
##            attr(regexpr(stopTag, emergingMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## emergingMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", emergingMain, perl=T) ## table
## ## insert section
## emergingMain <- gsub("(distress in the context of loss..)(?=\n\n## Emerging II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), emergingMain, perl=T)

### Add tags
## assign group tags (none in emerging)
emergingMain <- assignTag(emergingMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
emergingMain <- assignTag(emergingMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
emergingMain <- assignTagHeader(emergingMain)

#### write
writeLines(emergingMain, "emergingMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

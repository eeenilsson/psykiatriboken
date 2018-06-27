chapterTitle <- "Personality Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Personality Disorders	645

## Impulse intro and main body
impulseMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 677:716)
## impulseMain[1] <-
##     gsub("(?s).*(?=\nSeparation Impulse Disorder)", "", impulseMain[1], perl=T) ## remove redundant text before section starts and 
impulseMain <- paste(impulseMain, collapse = "") ## collapse to one
impulseMain <- cleanText(impulseMain)
impulseMain <- makeHeaders(impulseMain)
impulseMain <- cleanMore(impulseMain)
impulseMain <- gsub(" \n\n", "\n\n", impulseMain, perl=T) ## Remove blanks preceding newline
impulseMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", impulseMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
impulseMain <- gsub("^.*T h is C h s p te r b e g i n s", "This chapter begins", impulseMain) ## remove title and first sentance (not correctly parsed from pdf)
impulseMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), impulseMain) ## Add header to intro
impulseMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), impulseMain) ## Add chapter
impulseMain <- gsub("(?<=[^\n])##", "\n\n##", impulseMain, perl=T) ## ## should be preceded by newline
impulseMain <- gsub("\\,\"", "\"\\,", impulseMain) ## comma before qoutes corrected
impulseMain <- gsub("## The essential", "The essential", impulseMain) ## seems common
impulseMain <- gsub("Disorder 2", "Disorder\n\n2", impulseMain)

writeLines(impulseMain, "impulseMain.txt")

#### chunk specific replacements
impulseMain <- gsub("of\n\n3", "of 3", impulseMain)
impulseMain <- gsub("\\)\n\n\\(", ") (", impulseMain)
impulseMain <- gsub("([a-z])(\n\n)([0-9])", "\\1 \\3", impulseMain)
impulseMain <- gsub("Change\n\n## Due", "Change Due", impulseMain)
impulseMain <- gsub("Medical Condition 310.1", "Medical Condition\n\n310.1", impulseMain)
impulseMain <- gsub("Personality Disorder 301", "Personality Disorder\n\n301", impulseMain)

impulseMain <- removeFalseHeader("Individuals with", impulseMain)
impulseMain <- removeFalseHeader("A prevalence estimate for paranoid", impulseMain)
impulseMain <- removeFalseHeader("Individuals with schizoid", impulseMain)
impulseMain <- removeFalseHeader("National Epidemiologic Survey", impulseMain)
impulseMain <- removeFalseHeader("Individuals with this", impulseMain)
impulseMain <- removeFalseHeader("The median population", impulseMain)
impulseMain <- removeFalseHeader("These individuals are often", impulseMain)

##
## startTag <- "## Inhalant Use Disorder\n\n## Inhalant"
## stopTag <- "Disorders\n\n## Unspecified Inhalant.Related Disorder"
## grep(startTag, impulseMain, perl=T, ignore.case=T)
## grep(stopTag, impulseMain, perl=T, ignore.case=T)
## impulseMain <- cutSection(startTag, stopTag, impulseMain, insert.list=TRUE) ## cut section and insert list


## impulseMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", impulseMain)

writeLines(impulseMain, "impulseMain.txt")
x
#### table replacement ==================
## impulseMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", impulseMain, perl=T) ## table

### start and stop tags
## startTag <- "(?s)(?<=the clinician should record only the substance.induced impulse.compulsive and related disorder.)"
## stopTag <- "F19.988 (?=_Specify)"
## grep(startTag, impulseMain, perl=T) ## test
## grep(stopTag, impulseMain, perl=T) ## test
## ### get Section
## myTable <- getSection(startTag, stopTag, impulseMain)
## myTable <- parseTableUseDisorder(myTable)
## colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
## impulseMain <- gsub(
##     paste(startTag, ".*", stopTag, sep= ""),
##     formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced NNNN Disorder"), impulseMain, perl=T) ## table
## write_csv(myTable, "dsm5-table-p295.csv")
## writeLines(impulseMain, "impulseMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, impulseMain, perl=T) ## test
## grep(stopTag, impulseMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(impulseMain,
##            regexpr(startTag, impulseMain, perl=T)[1],
##            regexpr(stopTag, impulseMain, perl=T)[1]+
##            attr(regexpr(stopTag, impulseMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## impulseMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", impulseMain, perl=T) ## table
## ## insert section
## impulseMain <- gsub("(distress in the context of loss..)(?=\n\n## Impulse II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), impulseMain, perl=T)

### Add tags
## assign group tags (none in impulse)
impulseMain <- assignTag(impulseMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
impulseMain <- assignTag(impulseMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
impulseMain <- assignTagHeader(impulseMain)

#### write
writeLines(impulseMain, "impulseMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

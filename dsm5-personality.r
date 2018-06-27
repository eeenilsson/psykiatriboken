chapterTitle <- "Personality Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Personality Disorders	645

## Personality intro and main body
personalityMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 677:716)
## personalityMain[1] <-
##     gsub("(?s).*(?=\nSeparation Personality Disorder)", "", personalityMain[1], perl=T) ## remove redundant text before section starts and 
personalityMain <- paste(personalityMain, collapse = "") ## collapse to one
personalityMain <- cleanText(personalityMain)
personalityMain <- makeHeaders(personalityMain)
personalityMain <- cleanMore(personalityMain)
personalityMain <- gsub(" \n\n", "\n\n", personalityMain, perl=T) ## Remove blanks preceding newline
personalityMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", personalityMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
personalityMain <- gsub("^.*T h is C h s p te r b e g i n s", "This chapter begins", personalityMain) ## remove title and first sentance (not correctly parsed from pdf)
personalityMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), personalityMain) ## Add header to intro
personalityMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), personalityMain) ## Add chapter
personalityMain <- gsub("(?<=[^\n])##", "\n\n##", personalityMain, perl=T) ## ## should be preceded by newline
personalityMain <- gsub("\\,\"", "\"\\,", personalityMain) ## comma before qoutes corrected
personalityMain <- gsub("## The essential", "The essential", personalityMain) ## seems common
personalityMain <- gsub("Disorder 2", "Disorder\n\n2", personalityMain)

writeLines(personalityMain, "personalityMain.txt")

#### chunk specific replacements
personalityMain <- gsub("of\n\n3", "of 3", personalityMain)
personalityMain <- gsub("\\)\n\n\\(", ") (", personalityMain)
personalityMain <- gsub("([a-z])(\n\n)([0-9])", "\\1 \\3", personalityMain)
personalityMain <- gsub("Change\n\n## Due", "Change Due", personalityMain)
personalityMain <- gsub("Medical Condition 310.1", "Medical Condition\n\n310.1", personalityMain)
personalityMain <- gsub("Personality Disorder 301", "Personality Disorder\n\n301", personalityMain)

personalityMain <- removeFalseHeader("Individuals with", personalityMain)
personalityMain <- removeFalseHeader("A prevalence estimate for paranoid", personalityMain)
personalityMain <- removeFalseHeader("Individuals with schizoid", personalityMain)
personalityMain <- removeFalseHeader("National Epidemiologic Survey", personalityMain)
personalityMain <- removeFalseHeader("Individuals with this", personalityMain)
personalityMain <- removeFalseHeader("The median population", personalityMain)
personalityMain <- removeFalseHeader("These individuals are often", personalityMain)

##
## startTag <- "## Inhalant Use Disorder\n\n## Inhalant"
## stopTag <- "Disorders\n\n## Unspecified Inhalant.Related Disorder"
## grep(startTag, personalityMain, perl=T, ignore.case=T)
## grep(stopTag, personalityMain, perl=T, ignore.case=T)
## personalityMain <- cutSection(startTag, stopTag, personalityMain, insert.list=TRUE) ## cut section and insert list


## personalityMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", personalityMain)

writeLines(personalityMain, "personalityMain.txt")

#### table replacement ==================
## personalityMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", personalityMain, perl=T) ## table

### start and stop tags
## startTag <- "(?s)(?<=the clinician should record only the substance.induced personality.compulsive and related disorder.)"
## stopTag <- "F19.988 (?=_Specify)"
## grep(startTag, personalityMain, perl=T) ## test
## grep(stopTag, personalityMain, perl=T) ## test
## ### get Section
## myTable <- getSection(startTag, stopTag, personalityMain)
## myTable <- parseTableUseDisorder(myTable)
## colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
## personalityMain <- gsub(
##     paste(startTag, ".*", stopTag, sep= ""),
##     formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced NNNN Disorder"), personalityMain, perl=T) ## table
## write_csv(myTable, "dsm5-table-p295.csv")
## writeLines(personalityMain, "personalityMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, personalityMain, perl=T) ## test
## grep(stopTag, personalityMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(personalityMain,
##            regexpr(startTag, personalityMain, perl=T)[1],
##            regexpr(stopTag, personalityMain, perl=T)[1]+
##            attr(regexpr(stopTag, personalityMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## personalityMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", personalityMain, perl=T) ## table
## ## insert section
## personalityMain <- gsub("(distress in the context of loss..)(?=\n\n## Personality II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), personalityMain, perl=T)

### Add tags
## assign group tags (none in personality)
personalityMain <- assignTag(personalityMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
personalityMain <- assignTag(personalityMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
personalityMain <- assignTagHeader(personalityMain)

#### write
writeLines(personalityMain, "personalityMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

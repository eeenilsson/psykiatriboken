chapterTitle <- "Substance-Related and Addictive Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Substance-Related and Addictive Disorders	 481

## Intro and main body
substanceMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 515:623)
## substanceMain[1] <-
##     gsub("(?s).*(?=\nSeparation Substance Disorder)", "", substanceMain[1], perl=T) ## remove redundant text before section starts and 
substanceMain <- paste(substanceMain, collapse = "") ## collapse to one
substanceMain <- cleanText(substanceMain)
substanceMain <- gsub("Disorder...292.9", "Disorder\n\n292.9", substanceMain) ## otherwise no header
substanceMain <- makeHeaders(substanceMain)
substanceMain <- cleanMore(substanceMain)
substanceMain <- gsub(" \n\n", "\n\n", substanceMain, perl=T) ## Remove blanks preceding newline
substanceMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", substanceMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
substanceMain <- gsub("^.*G C l", "The substance-related", substanceMain) ## remove title and first sentance (not correctly parsed from pdf)
substanceMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), substanceMain) ## Add header to intro
substanceMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), substanceMain) ## Add chapter
substanceMain <- gsub("(?<=[^\n])##", "\n\n##", substanceMain, perl=T) ## ## should be preceded by newline
substanceMain <- gsub("\\,\"", "\"\\,", substanceMain) ## comma before qoutes corrected

                      
writeLines(substanceMain, "substanceMain.txt")

#### chunk specific replacements
substanceMain <- gsub("[^\n]## Diagnostic Features", "\n\n## Diagnostic Features", substanceMain)
substanceMain <- gsub("Medication.\n\n## Induced", "Medication-Induced", substanceMain)
substanceMain <- gsub("## Synthetic oral", "Synthetic oral", substanceMain)
substanceMain <- gsub("9.\n\nTHC", "9-THC", substanceMain)
substanceMain <- gsub("## Spectrum and Other", "Spectrum and Other", substanceMain)
substanceMain <- gsub("Schizophrenia \n\n", "Schizophrenia ", substanceMain)
substanceMain <- gsub("Anxiety\n\n", "Anxiety ", substanceMain)
substanceMain <- gsub("'\"", "\"", substanceMain)

writeLines(substanceMain, "substanceMain.txt")

## ## clean - replace list
substanceMain <- gsub("(?s)(## Alcohol use disorder\n\n##)(.*)?(Disorders\n\n## Unspecified alcohol.related disorder)", "Alcohol use disorder, Alcohol intoxication, Alcohol withdrawal, Other Alcohol-induced Disorders and Unspecified alcohol-related disorder.", substanceMain, perl=T, ignore.case=T)

substanceMain <- gsub("(?s)(## Cannabis use disorder\n\n##)(.*)?(Disorders\n\n## Unspecified cannabis.related disorder)", "Caffeine intoxication, Caffeine withdrawal, Other Caffeine-Induced Disorders and Unspecified caffeine-related disorder.", substanceMain, perl=T, ignore.case=T)

substanceMain <- gsub("(?s)(## Caffeine intoxication\n\n##)(.*)?(Disorders\n\n## Unspecified caffeine.related disorder)", "Caffeine intoxication, Caffeine withdrawal, Other Caffeine-Induced Disorders and Unspecified caffeine-related disorder.", substanceMain, perl=T, ignore.case=T)

substanceMain <- gsub("(?s)(## Phencyclidine Use Disorder\n\n##)(.*)?(Disorder\n\n## Unspecified Hallucinogen.Related Disorder)", "Phencyclidine Use Disorder, Other Hallucinogen Use Disorder, Phencyclidine Intoxication, Other Hallucinogen Intoxication, Hallucinogen Persisting Perception Disorder, Other Phencyclidine-induced Disorders, Other Hallucinogen-induced Disorders and Unspecified Phencyclidine-Related Disorder.", substanceMain, perl=T, ignore.case=T)

startTag <- "## Inhalant Use Disorder\n\n## Inhalant"
stopTag <- "Disorders\n\n## Unspecified Inhalant.Related Disorder"
grep(startTag, substanceMain, perl=T, ignore.case=T)
grep(stopTag, substanceMain, perl=T, ignore.case=T)
substanceMain <- cutSection(startTag, stopTag, substanceMain, insert.list=TRUE) ## cut section and insert list

writeLines(substanceMain, "substanceMain.txt")
## substanceMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", substanceMain)

writeLines(substanceMain, "substanceMain.txt")

#### table replacement ==================
## substanceMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", substanceMain, perl=T) ## table

### Remove table 1 (rotated)
startTag <- "(?s)(?<=Table 1.)o 8"
stopTag <- "## W(?=\n\n)"
grep(startTag, substanceMain, perl=T) ## test
grep(stopTag, substanceMain, perl=T) ## test
term <- paste(startTag, "(.*)?", stopTag, sep = "")
substanceMain <- gsub(term, "\n\n<--TABLE-REMOVED-P482-->\n\n", substanceMain, perl=T)
writeLines(substanceMain, "substanceMain.txt")

### start and stop tags
## startTag <- "(?s)(?<=the clinician should record only the substance.induced substance.compulsive and related disorder.)"
## stopTag <- "F19.988 (?=_Specify)"
## grep(startTag, substanceMain, perl=T) ## test
## grep(stopTag, substanceMain, perl=T) ## test
## ### get Section
## myTable <- getSection(startTag, stopTag, substanceMain)
## myTable <- parseTableUseDisorder(myTable)
## colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
## substanceMain <- gsub(
##     paste(startTag, ".*", stopTag, sep= ""),
##     formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced NNNN Disorder"), substanceMain, perl=T) ## table
## write_csv(myTable, "dsm5-table-p295.csv")
## writeLines(substanceMain, "substanceMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, substanceMain, perl=T) ## test
## grep(stopTag, substanceMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(substanceMain,
##            regexpr(startTag, substanceMain, perl=T)[1],
##            regexpr(stopTag, substanceMain, perl=T)[1]+
##            attr(regexpr(stopTag, substanceMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## substanceMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", substanceMain, perl=T) ## table
## ## insert section
## substanceMain <- gsub("(distress in the context of loss..)(?=\n\n## Substance II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), substanceMain, perl=T)

### Add tags
## assign group tags (none in substance)
substanceMain <- assignTag(substanceMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
substanceMain <- assignTag(substanceMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
substanceMain <- assignTagHeader(substanceMain)

#### write
writeLines(substanceMain, "substanceMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

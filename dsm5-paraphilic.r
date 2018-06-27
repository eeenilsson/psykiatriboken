chapterTitle <- "Paraphilic Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC
## Paraphilic Disorders	685

## Paraphilic intro and main body
paraphilicMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 717:737)
## paraphilicMain[1] <-
##     gsub("(?s).*(?=\nSeparation Paraphilic Disorder)", "", paraphilicMain[1], perl=T) ## remove redundant text before section starts and 
paraphilicMain <- paste(paraphilicMain, collapse = "") ## collapse to one
paraphilicMain <- cleanText(paraphilicMain)
paraphilicMain <- makeHeaders(paraphilicMain)
paraphilicMain <- cleanMore(paraphilicMain)
paraphilicMain <- gsub(" \n\n", "\n\n", paraphilicMain, perl=T) ## Remove blanks preceding newline
paraphilicMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", paraphilicMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
paraphilicMain <- gsub("^.*Psrsphilic", "Paraphilic", paraphilicMain) ## remove title and first sentance (not correctly parsed from pdf)
paraphilicMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), paraphilicMain) ## Add header to intro
paraphilicMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), paraphilicMain) ## Add chapter
paraphilicMain <- gsub("(?<=[^\n])##", "\n\n##", paraphilicMain, perl=T) ## ## should be preceded by newline
paraphilicMain <- gsub("\\,\"", "\"\\,", paraphilicMain) ## comma before qoutes corrected
paraphilicMain <- gsub("## The essential", "The essential", paraphilicMain) ## seems common
paraphilicMain <- gsub("Disorder 2", "Disorder\n\n2", paraphilicMain)
paraphilicMain <- gsub("([a-z])(\n\n)([0-9])", "\\1 \\3", paraphilicMain) ## newline followed by number and preceded bu letter with no period character

writeLines(paraphilicMain, "paraphilicMain.txt")

#### chunk specific replacements
paraphilicMain <- gsub("[^\n]## Diagnostic Features", "\n\n## Diagnostic Features", paraphilicMain)
paraphilicMain <- removeFalseHeader("Many of the conditions", paraphilicMain)
paraphilicMain <- gsub("Disorder 3", "Disorder\n\n3", paraphilicMain)

## startTag <- "## Inhalant Use Disorder\n\n## Inhalant"
## stopTag <- "Disorders\n\n## Unspecified Inhalant.Related Disorder"
## grep(startTag, paraphilicMain, perl=T, ignore.case=T)
## grep(stopTag, paraphilicMain, perl=T, ignore.case=T)
## paraphilicMain <- cutSection(startTag, stopTag, paraphilicMain, insert.list=TRUE) ## cut section and insert list


## paraphilicMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", paraphilicMain)

writeLines(paraphilicMain, "paraphilicMain.txt")

#### table replacement ==================
## paraphilicMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", paraphilicMain, perl=T) ## table

### start and stop tags
## startTag <- "(?s)(?<=the clinician should record only the substance.induced paraphilic.compulsive and related disorder.)"
## stopTag <- "F19.988 (?=_Specify)"
## grep(startTag, paraphilicMain, perl=T) ## test
## grep(stopTag, paraphilicMain, perl=T) ## test
## ### get Section
## myTable <- getSection(startTag, stopTag, paraphilicMain)
## myTable <- parseTableUseDisorder(myTable)
## colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
## paraphilicMain <- gsub(
##     paste(startTag, ".*", stopTag, sep= ""),
##     formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced NNNN Disorder"), paraphilicMain, perl=T) ## table
## write_csv(myTable, "dsm5-table-p295.csv")
## writeLines(paraphilicMain, "paraphilicMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, paraphilicMain, perl=T) ## test
## grep(stopTag, paraphilicMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(paraphilicMain,
##            regexpr(startTag, paraphilicMain, perl=T)[1],
##            regexpr(stopTag, paraphilicMain, perl=T)[1]+
##            attr(regexpr(stopTag, paraphilicMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## paraphilicMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", paraphilicMain, perl=T) ## table
## ## insert section
## paraphilicMain <- gsub("(distress in the context of loss..)(?=\n\n## Paraphilic II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), paraphilicMain, perl=T)

### Add tags
## assign group tags (none in paraphilic)
paraphilicMain <- assignTag(paraphilicMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
paraphilicMain <- assignTag(paraphilicMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
paraphilicMain <- assignTagHeader(paraphilicMain)

#### write
writeLines(paraphilicMain, "paraphilicMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

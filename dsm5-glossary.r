chapterTitle <- "Glossary of Technical Terms"
pageIndex[chapterTitle] ## Chapter page index from TOC

## Glossary intro and main body
glossaryMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 842:970)
## glossaryMain[1] <-
##     gsub("(?s).*(?=\nSeparation Glossary Disorder)", "", glossaryMain[1], perl=T) ## remove redundant text before section starts and 
glossaryMain <- paste(glossaryMain, collapse = "") ## collapse to one
glossaryMain <- cleanText(glossaryMain)
glossaryMain <- makeHeaders(glossaryMain)
glossaryMain <- cleanMore(glossaryMain)
glossaryMain <- gsub(" \n\n", "\n\n", glossaryMain, perl=T) ## Remove blanks preceding newline
glossaryMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", glossaryMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline
glossaryMain <- gsub("^.*Glossa\n\nTechnical Terms", "", glossaryMain) ## remove title and first sentance (not correctly parsed from pdf)
glossaryMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), glossaryMain) ## Add chapter
glossaryMain <- gsub("(?<=[^\n])##", "\n\n##", glossaryMain, perl=T) ## ## should be preceded by newline
glossaryMain <- gsub("\\,\"", "\"\\,", glossaryMain) ## comma before qoutes corrected
glossaryMain <- gsub("## The essential", "The essential", glossaryMain) ## seems common
glossaryMain <- gsub("Disorder 2", "Disorder\n\n2", glossaryMain)
glossaryMain <- gsub("([a-z])(\n\n)([0-9])", "\\1 \\3", glossaryMain) ## newline followed by number and preceded bu letter with no period character

writeLines(glossaryMain, "glossaryMain.txt")

#### chunk specific replacements
glossaryMain <- gsub("[^\n]## Diagnostic Features", "\n\n## Diagnostic Features", glossaryMain)
glossaryMain <- removeFalseHeader("Missing work or school", glossaryMain)

glossaryMain <- gsub("([a-z]|[A-Z])(\\.)([a-z])", "\\1\\2\n\n\\3", glossaryMain)
glossaryMain <- gsub("(?<=\n\n)([a-z\\s]+)", "*\\1* ", glossaryMain, perl=T)
glossaryMain <- gsub(" \\*", "*", glossaryMain, perl=T)

## startTag <- "## Inhalant Use Disorder\n\n## Inhalant"
## stopTag <- "Disorders\n\n## Unspecified Inhalant.Related Disorder"
## grep(startTag, glossaryMain, perl=T, ignore.case=T)
## grep(stopTag, glossaryMain, perl=T, ignore.case=T)
## glossaryMain <- cutSection(startTag, stopTag, glossaryMain, insert.list=TRUE) ## cut section and insert list


## glossaryMain <- gsub("Disorder\n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", glossaryMain)

writeLines(glossaryMain, "glossaryMain.txt")
x
#### table replacement ==================
## glossaryMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", glossaryMain, perl=T) ## table

### start and stop tags
## startTag <- "(?s)(?<=the clinician should record only the substance.induced glossary.compulsive and related disorder.)"
## stopTag <- "F19.988 (?=_Specify)"
## grep(startTag, glossaryMain, perl=T) ## test
## grep(stopTag, glossaryMain, perl=T) ## test
## ### get Section
## myTable <- getSection(startTag, stopTag, glossaryMain)
## myTable <- parseTableUseDisorder(myTable)
## colnames(myTable) <- c("Substance", "With mild use disorder",  "Moderate or severe", "Without use disorder")
## glossaryMain <- gsub(
##     paste(startTag, ".*", stopTag, sep= ""),
##     formatTable(myTable, caption = "ICD codes for Substance/Medication-Induced NNNN Disorder"), glossaryMain, perl=T) ## table
## write_csv(myTable, "dsm5-table-p295.csv")
## writeLines(glossaryMain, "glossaryMain.txt")

## ## move section ## Not needed in depr ======================
## Note: use getSection function instead
## startTag <- "(?<=medical condition.)(..In distinguishing grief)"
## stopTag <- "(pain of depression.\n\n)(?=## Coding)"
## grep(startTag, glossaryMain, perl=T) ## test
## grep(stopTag, glossaryMain, perl=T) ## test
## ### get section
## mySection <-
##     substr(glossaryMain,
##            regexpr(startTag, glossaryMain, perl=T)[1],
##            regexpr(stopTag, glossaryMain, perl=T)[1]+
##            attr(regexpr(stopTag, glossaryMain, perl=T), "match.length")-1)
## mySection <- gsub("^..", "", mySection) ## clean first two chars
## ## delete section
## glossaryMain <-
##     gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", glossaryMain, perl=T) ## table
## ## insert section
## glossaryMain <- gsub("(distress in the context of loss..)(?=\n\n## Glossary II Disorder)",
##                     paste("distress in the context of loss.\n\n", mySection, sep=""), glossaryMain, perl=T)

### Add tags
## assign group tags (none in glossary)
glossaryMain <- assignTag(glossaryMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
glossaryMain <- assignTag(glossaryMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
glossaryMain <- assignTagHeader(glossaryMain)

#### write
writeLines(glossaryMain, "glossaryMain.txt")

## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Notes below

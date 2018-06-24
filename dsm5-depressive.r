### Bipolar and Related Disorders  ==============
chapterTitle <- "Depressive Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC

source('replacement-list.r')

## HERE

## Bipolar disorders intro
depressiveIntro <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 193) ## "Depressive disorders". ## Note: remove last part
depressiveIntro <- paste(depressiveIntro, collapse = "")
depressiveIntro <- cleanText(depressiveIntro)
depressiveIntro <- makeHeaders(depressiveIntro)
depressiveIntro <- gsub("D eprG SSiV G  diSO rdG rS", "Depressive disorders", depressiveIntro)
depressiveIntro <- gsub("disorder \n\n.dysth", "disorder (dysth", depressiveIntro)
depressiveIntro <- gsub("Further \n\nStudy", "Further Study", depressiveIntro)
depressiveIntro <- gsub("Further \n\nStudy", "Further Study", depressiveIntro)
writeLines(depressiveIntro, "depressiveIntro.txt")

## Depressive main body
depressiveMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 194:226)
## depressiveMain[1] <-
##     gsub("(?s).*(?=\nDepressive I Disorder)", "", depressiveMain[1], perl=T) ## remove redundant text before section starts and 
depressiveMain <- paste(depressiveMain, collapse = "") ## collapse to one
depressiveMain <- cleanText(depressiveMain)
depressiveMain <- makeHeaders(depressiveMain)
depressiveMain <- cleanMore(depressiveMain)
## depressiveMain <- gsub("(## )([^\n]*)(\n\n## )", "## \\2", depressiveMain) ## removes broken headers. Affects true headers followed by true headers
depressiveMain <- gsub(" \n\n", "\n\n", depressiveMain, perl=T) ## Remove blanks preceding newline
depressiveMain <- gsub("(?<=\n\n)([^\n#]*)([^\\.:_\\)])(\n\n)", "\\1\\2 ", depressiveMain, perl=T) ## Remove unwanted newline breaks in text not preceded by dot or colon or parens or underscore. NOTE: Must be preceded by removing blanks before newline

#### chunk specific replacements
depressiveMain <- gsub("^", "## ", depressiveMain)
depressiveMain<- gsub("muteness\\)\n\n\\(Criterion", "muteness\\)\\(Criterion", depressiveMain)
depressiveMain <- gsub("## Functional Consequences of\n\n##", "## Functional Consequences of", depressiveMain)
depressiveMain <- gsub("episode\\*", "episode", depressiveMain)
depressiveMain <- gsub("\\*For an episode", "\n\nNote: For an episode", depressiveMain)
depressiveMain <- gsub("condition.. In distinguishing grief", "condition\\.\n\nNote: In distinguishing grief", depressiveMain)
depressiveMain <- gsub("Induced\n\n## Depressive", "Induced Depressive", depressiveMain)
depressiveMain <- gsub("■", " ", depressiveMain)

writeLines(depressiveMain, "depressiveMain.txt")

#### table replacement
startTag <- "(?s)(?<=the clinician should record only the substance.induced depressive disorder.\n\n)"
stopTag <- "9.94 (?=_Specify_)"
grep(startTag, depressiveMain, perl=T) ## test
grep(stopTag, depressiveMain, perl=T) ## test
paste(startTag, ".*", stopTag, sep= "")
depressiveMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P176-->\n\n", depressiveMain, perl=T) ## table

writeLines(depressiveMain, "depressiveMain.txt")

## table notes
tab <- read_csv("dsm5-table-p176.csv")

## Type 1 table
allRows <- list() 
for(i in 2:ncol(tab)-1){
   newRow <- 
paste("- If ", names(tab)[i], ": ", paste(tab[[1]], tab[[i]], collapse = ", "), sep = "")
   allRows[i-1] <- newRow
}
replaceTable <- paste(allRows, collapse = "\n\n")
replaceTable <- paste("<--TABLE-P164 REPLACEMENT-->\n\n", replaceTable, "\n\n", tableNote, "\n", sep="")
depressiveMain <- gsub("<--TABLE-P164-->\n\n", replaceTable, depressiveMain, perl=T) ## table

## type 2 table
i <- 1
for(i in 2:nrow(tab)-1){
   newRow <- 
        paste(tab[[1]][i],
              ": ICD-9-CM code ", tab[[2]][i],
              "; ICD-10-CM code if use disorder is mild (", tab[[3]][i],
              "), -moderate or severe (", tab[[4]][i],
              ") or without use disorder (", tab[[4]][i],
              ")",
              sep = "")
   allRows[i] <- newRow
}
replaceTable <- paste(allRows, collapse = "\n\n")
replaceTable <- paste("<--TABLE-P180 REPLACEMENT-->\n\n", replaceTable, "\n\n", sep="")
depressiveMain <- gsub("<--TABLE-P180-->\n\n", replaceTable, depressiveMain, perl=T) ## table

## move section ## Not needed
startTag <- "(?<=medical condition.)(..In distinguishing grief)"
stopTag <- "(pain of depression.\n\n)(?=## Coding)"
grep(startTag, depressiveMain, perl=T) ## test
grep(stopTag, depressiveMain, perl=T) ## test
### get section
mySection <-
    substr(depressiveMain,
           regexpr(startTag, depressiveMain, perl=T)[1],
           regexpr(stopTag, depressiveMain, perl=T)[1]+
           attr(regexpr(stopTag, depressiveMain, perl=T), "match.length")-1)
mySection <- gsub("^..", "", mySection) ## clean first two chars
## delete section
depressiveMain <-
    gsub(paste("(?s)", startTag, ".*", stopTag, sep= ""), "", depressiveMain, perl=T) ## table
## insert section
depressiveMain <- gsub("(distress in the context of loss..)(?=\n\n## Depressive II Disorder)",
                    paste("distress in the context of loss.\n\n", mySection, sep=""), depressiveMain, perl=T)


### Add tags
## assign group tags (none in depressive)
depressiveMain <- assignTag(depressiveMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
depressiveMain <- assignTag(depressiveMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE , hash.replace = "##d") ## Note that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

## mark headers
depressiveMain <- assignTagHeader(depressiveMain)

#### write
## store copy
store <- depressiveMain
##depressiveMain <- store ## recover
writeLines(depressiveMain, "depressiveMain.txt")
## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## TODO: Check that all major diagnoses are tagged (For example "Depressive I" is not (it has only sub-codes and thus is not in list))
## Make an extra list to append to code list? Add to .csv?

## headers - redundant
## depressiveMain <- assignTag(depressiveMain,
##                          listHeaders,
##                          tag = "<--@HEADER-->",
##                          hash.replace = "##h", ## so that non-headers can be replaced
##                          ignore.case=TRUE,
##                          first.only=FALSE)

## Now, after flattening lists with replace-bounded-hash, all non-tagged starting with ## are-sub headers

## make subheaders of all headers not starting with "##h"
## Note: Do this after cleaning hashlists
## depressiveMain <- gsub("(?<=\n)##[[:blank:]]", "### ", depressiveMain, perl=T)


## Notes below

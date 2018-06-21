### Bipolar and Related Disorders  ==============
## 161 bipolar intro
## 161:191 Bipolar main body
chapterTitle <- "Bipolar and Related Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC

source('replacement-list.r')

### Bipolar disorders intro
bipolarIntro <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 161) ## "Bipolar disorders". ## Note: remove last part
bipolarIntro <- paste(bipolarIntro, collapse = "")
bipolarIntro <- cleanText(bipolarIntro)
bipolarIntro <- makeHeaders(bipolarIntro)
bipolarIntro <- gsub("(?s)^.*(?=disorders are separated)", "Bipolar and Related Disorders", bipolarIntro, perl=T) ## clean start
bipolarIntro <- gsub("\n\n## Bipolar I.*$", "", bipolarIntro) ## clean ending
bipolarIntro <-  gsub("\n\nDSM-5", "DSM-5", bipolarIntro)
bipolarIntro <- gsub("## The diagnosis of", "The diagnosis of", bipolarIntro)
bipolarIntro <- gsub("years \n\n", " years", bipolarIntro)
writeLines(bipolarIntro, "bipolarIntro.txt")

### Bipolar main body
bipolarMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 161:192) ## "Bipolar disorders".
bipolarMain[1] <-
    gsub("(?s).*(?=\nBipolar I Disorder)", "", bipolarMain[1], perl=T) ## remove redundant text before section starts and 
bipolarMain[1] <- gsub("^\n", "## ", bipolarMain[1]) ## add ## to first line
bipolarMain <- paste(bipolarMain, collapse = "") ## collapse to one
bipolarMain <- cleanText(bipolarMain)
bipolarMain <- makeHeaders(bipolarMain)
bipolarMain <- cleanMore(bipolarMain)
store <- bipolarMain
##bipolarMain <- store
writeLines(bipolarMain, "bipolarMain.txt")

## bipolarMain <- gsub("\n\nWith rapid cycling", " Specify:\n\nWith anxious distress \\(p\\. 149\\)\n\nWith mixed features \\(pp\\. 149\\-150\\)\n\nWith rapid cycling", bipolarMain)

#### chunk specific replacements
bipolarMain <- gsub("Symptom \n\nSeverity", "Symptom Severity", bipolarMain)
bipolarMain <- gsub("otic \n\nDisorder", "otic Disorder", bipolarMain)
bipolarMain <- gsub("Consequences of \n\n##", "Consequences of", bipolarMain)
bipolarMain <- gsub("Criterion \n\nA", "Criterion A", bipolarMain)
bipolarMain <- gsub("impairment \n\n\\(see", "impairment \\(see", bipolarMain)
bipolarMain <- gsub("presentations \n\n\\(associated", "presentations \\(associated", bipolarMain)
bipolarMain <- gsub("hearing \n\nGod", "hearing God", bipolarMain)
bipolarMain <- gsub("Induced \n\n##", "Induced", bipolarMain)
bipolarMain <- gsub("(with perceptual disturbances..)(\n\n)(\\(applies)", "\\1\\3", bipolarMain)
bipolarMain <- gsub("Disorder \n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", bipolarMain)
bipolarMain <- gsub("Another \n\n## Mental", "Another Mental", bipolarMain)
bipolarMain <- gsub("Due to \n\n## Another", "Due to Another", bipolarMain)
bipolarMain <- gsub("Spectrum and \n\n## Other", "Spectrum and Other", bipolarMain)
bipolarMain <- gsub("Disorder \n\n## Due", "Disorder Due", bipolarMain)
bipolarMain <- gsub("bipolar \n\nI", "bipolar \n\nI", bipolarMain)
bipolarMain <- gsub("\nSpecify.", "Specify:", bipolarMain)
bipolarMain <- gsub("Depressive \n\nEpisode", "Depressive Episode", bipolarMain)
bipolarMain <- gsub("II disorder \n\n\\(Criterion B", "II disorder \\(Criterion B", bipolarMain)
bipolarMain <- gsub("symptoms is \n\n6.5", "symptoms is 6.5", bipolarMain)
bipolarMain <- gsub("cycling.\n\nBoth", "cycling. Both", bipolarMain)
bipolarMain <- gsub("e.g.. \n\n292.84 methylphenidate", "e.g. 292.84 methylphenidate", bipolarMain)
bipolarMain <- gsub("diagnosis is \n\nF14.24", "diagnosis is F14.24", bipolarMain)
bipolarMain <- gsub("Disorder V", "Disorder", bipolarMain)
bipolarMain <- gsub("Other \n\nPsychotic", "Other Psychotic", bipolarMain)
bipolarMain <- gsub("day \n\n\\(or", "day \\(or", bipolarMain)

#### table replacement
startTag <- "(?s)(?<=Codes are as follows.\n\n)"
stopTag <- "\\(F31.4\\)\n\n(?=In distinguishing grief)"
paste(startTag, ".*", stopTag, sep= "")
bipolarMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P164-->\n\n", bipolarMain, perl=T) ## table
startTag <- "(?s)(?<=the pain of depression.\n\n)"
stopTag <- "\\(F31.9\\)\n\n(?=Severity and psychotic)"
paste(startTag, ".*", stopTag, sep= "")
bipolarMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "", bipolarMain, perl=T) ## table
## table notes
tableNote <- substr(bipolarMain,
       regexpr("Severity and psychotic specifiers do not apply", bipolarMain),
       regexpr("without codes as apply to the current or most recent episode.", bipolarMain) + attr(regexpr("without codes as apply to the current or most recent episode.", bipolarMain), "match.length"))
bipolarMain <- gsub("\nSeverity and psychotic specifiers do not apply.*without codes as apply to the current or most recent episode.\n", "\n\n", bipolarMain) ## remove table note
tableNote <- paste("NoteA", tableNote, sep="")
tableNote <- gsub("\n\nSeverity", "\n\nNoteBSeverity", tableNote)
tableNote <- gsub("\\*\\*\\*If psychotic", "NoteCIf psychotic", tableNote)
tableNote <- gsub("NoteA", "Current or most recent episode hypomanic: ", tableNote)
tableNote <- gsub("NoteB", "Current or most recent episode unspecified: ", tableNote)
tableNote <- gsub("NoteC", "\n\nWith psychotic features: ", tableNote)
tableNote <- paste("Codes in table are noted as ICD-9-CM (ICD-10-CM).\n\n", tableNote, sep="")
## Note: See csv file, to get a markdown table:
tab <- read_csv("dsm5-table-p164.csv")
## kable(tab,
##       caption = "Coding for Bipolar I disorder",
##       align=c('lcccc')
##       )
allRows <- list() 
for(i in 2:ncol(tab)-1){
   newRow <- 
paste("- If ", names(tab)[i], ": ", paste(tab[[1]], tab[[i]], collapse = ", "), sep = "")
   allRows[i-1] <- newRow
}
replaceTable <- paste(allRows, collapse = "\n\n")
replaceTable <- paste("<--TABLE-P164 REPLACEMENT-->\n\n", replaceTable, "\n\n", tableNote, "\n", sep="")
bipolarMain <- gsub("<--TABLE-P164-->\n\n", replaceTable, bipolarMain, perl=T) ## table

#### table substance induced bipolar
startTag <- "(?s)(?<=the clinician should record only the substance.induced bipolar and related disorder.)\n\n"
stopTag <- "FI 9.94\n\n(?=_Specify_ if)"
paste(startTag, ".*", stopTag, sep= "")
bipolarMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "\n\n<--TABLE-P180-->\n\n", bipolarMain, perl=T) ## table
tab <- read_csv('dsm5-table-p180.csv') ## Coding for Substance-Induced Bipolar disorder
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
bipolarMain <- gsub("<--TABLE-P180-->\n\n", replaceTable, bipolarMain, perl=T) ## table

store <- bipolarMain
##bipolarMain <- store
writeLines(bipolarMain, "bipolarMain.txt")

### Add tags
## No groups in this section
groupList <- c(
    "No groups" ## if empty, theere will be matches
)
## assign group tags
bipolarMain <- assignTag(bipolarMain, groupList, tag = "<--@GROUP-->", hash.replace = "#")

## assign diagnosis tags
bipolarMain <- assignTag(bipolarMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE) ## Noe that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

#### write
## store copy
store <- bipolarMain
##bipolarMain <- store ## recover
writeLines(bipolarMain, "bipolarMain.txt")
## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## TODO: Check that all major diagnoses are tagged (For example "Bipolar I" is not (it has only sub-codes and thus is not in list))
## Make an extra list to append to code list? Add to .csv?

### Make bib entries based on diagnoses and more

list(
    "Bipolar I Disorder", "specify"
)

## Split string by diagnosis
## make list/table, add page intervals and chapter name
text <- readr::read_file('bipolarMain.txt')

## Add @SPLIT tag
### test:
## gsub("(##)(.*?)(?=<--@DIAGNOSIS-->)", "@SPLIT\\1\\2",
##      "## Bipolar II disorder <--@DIAGNOSIS--> keep some text <--@DIAGNOSIS-->", perl=T)

## Assign @SPLIT tag at @DIAGNOSIS and split
bipolarMainSplit <- gsub("(##)(.*?)(?=<--@DIAGNOSIS-->)", "@SPLIT\\1\\2",
     bipolarMain, perl=T)
writeLines(bipolarMainSplit, "bipolarTAGTEST.txt")
bipolarMainSplit <- strsplit(bipolarMainSplit, "@SPLIT")

## test
writeLines(bipolarMainSplit[[1]][1], "bipolarTEST.txt")
writeLines(bipolarMainSplit[[1]][2], "bipolarTEST.txt")
text <- bipolarMainSplit[[1]][2]

## extract entry element data
sectionTitle <- substr(text, regexpr("(?<=## )", text, perl=T), regexpr("(?= <--@DIAGNOSIS)", text, perl=T)-1)
sectionTag <- gsub(" ", "", tolower(sectionTitle))
## TODO: Match each diagnosis/section to its chapter?

## write bib
writeLines(
    makeDsmEntry(
        chapter = paste(sectionTitle, " in ", chapterTitle, sep=""),
        pages = paste(pageIndex[chapterTitle], "ff", sep=""),
        abstract = text,
        tag=sectionTag), "test.bib")

##writeLines(makeDsmEntry(), "test.bib")

## inbook bib entry	
## A part of a book, e.g., a chpater, section, or whatever and/or a range of pages.
## Required fields: author or editor, title, chapter and/or pages, publisher, year.
## Optional fields: volume or number, series, type, address, edition, month, note.
## http://blog.apastyle.org/apastyle/2013/08/how-to-cite-the-dsm5-in-apa-style.html
## The correct citation for this book is American Psychiatric Association: Diagnostic and Statistical Manual of Mental Disorders, Fifth Edition. Arlington, VA, American Psychiatric Association, 2013.


## Notes below


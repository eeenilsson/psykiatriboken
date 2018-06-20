### Bipolar Spectrum and Other Psychotic Disorders ==============
## 161 bipolar intro
## 161:191 Bipolar main body

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
bipolarMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 161:191) ## "Bipolar disorders".
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


## Note: See csv file, to get a markdown table:
tab <- read_csv("table-p111.csv")
kable(tab[1:9, 1:5],
      caption = tab[10,]$text,
      align=c('lcccc')
      )
allRows <- list() 
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
bipolarMain <- gsub("<--TABLE-P111-->\n\n", replaceTable, bipolarMain, perl=T) ## table




store <- bipolarMain
##bipolarMain <- store
writeLines(bipolarMain, "bipolarMain.txt")

### Add tags

## Note bipolar sub-classification : 295.70 (F25.0) Bipolar type, should perhaps be marked as diagnosis, if so also Psychotic Disorder Due to Another Medical Condition

#### List groups
## No groups in this section
groupList <- c(
    "No groups" ## if empty, theere will be matches
)

## assign group tags
bipolarMain <- assignTag(bipolarMain, groupList, tag = "<--@GROUP-->", hash.replace = "#")

## assign diagnosis tags
##icd10cmDsm5 <- read_csv("icd10cm-to-dsm5.csv")

bipolarMain <- assignTag(bipolarMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE) ## Noe that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

#### write
## store copy
store <- bipolarMain
##bipolarMain <- store ## recover
writeLines(bipolarMain, "bipolarMain.txt")
## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

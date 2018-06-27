### Schizophrenia Spectrum and Other Psychotic Disorders ==============
## 125:128 schizophrenia intro
## 128 Schizophrenia start of main body
chapterTitle <- "Schizophrenia Spectrum and Other Psychotic Disorders"
pageIndex[chapterTitle] ## Chapter page index from TOC

### Schizophrenia disorders intro
schizophreniaIntro <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 125:128) ## "Schizophrenia disorders". ## Note: remove last part
schizophreniaIntro <- paste(schizophreniaIntro, collapse = "")
schizophreniaIntro <- cleanText(schizophreniaIntro)
schizophreniaIntro <- makeHeaders(schizophreniaIntro)
matchThis <- "S^izophrenïa Spectrum and \n\n## Other Psychotic Disorder·"
matchThis <- gsub("([.|()\\^{}+$*?]|\\[|\\])", "\\\\\\1", matchThis)
schizophreniaIntro <-
    gsub(paste("(?s)", "(", matchThis, ")", sep=""), "## Schizophrenia Spectrum and Other Psychotic Disorders", schizophreniaIntro, perl=T)
schizophreniaIntro <- gsub("- ", "", schizophreniaIntro)
writeLines(schizophreniaIntro, "schizophreniaIntro.txt")
## Note: Needs some manual cleaning

### Schizophrenia main body
schizophreniaMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 128:160) ## "Schizophrenia disorders".
schizophreniaMain[1] <-
    gsub("(?s).*(?=\nDelusional Disorder)", "", schizophreniaMain[1], perl=T) ## remove redundant text before section starts and 
schizophreniaMain[1] <- gsub("^\n", "## ", schizophreniaMain[1]) ## add ## to first line
schizophreniaMain <- paste(schizophreniaMain, collapse = "") ## collapse to one
schizophreniaMain <- cleanText(schizophreniaMain)
schizophreniaMain <- makeHeaders(schizophreniaMain)
schizophreniaMain <- cleanMore(schizophreniaMain)

#### chunk specific replacements
schizophreniaMain <- gsub("Symptom \n\nSeverity", "Symptom Severity", schizophreniaMain)
schizophreniaMain <- gsub("otic \n\nDisorder", "otic Disorder", schizophreniaMain)
schizophreniaMain <- gsub("Consequences of \n\n##", "Consequences of", schizophreniaMain)
schizophreniaMain <- gsub("Criterion \n\nA", "Criterion A", schizophreniaMain)
schizophreniaMain <- gsub("impairment \n\n\\(see", "impairment \\(see", schizophreniaMain)
schizophreniaMain <- gsub("presentations \n\n\\(associated", "presentations \\(associated", schizophreniaMain)
schizophreniaMain <- gsub("hearing \n\nGod", "hearing God", schizophreniaMain)
schizophreniaMain <- gsub("Induced \n\n##", "Induced", schizophreniaMain)
schizophreniaMain <- gsub("(with perceptual disturbances..)(\n\n)(\\(applies)", "\\1\\3", schizophreniaMain)
schizophreniaMain <- gsub("Disorder \n\n## Due to Another Medical Condition", "Disorder Due to Another Medical Condition", schizophreniaMain)
schizophreniaMain <- gsub("Another \n\n## Mental", "Another Mental", schizophreniaMain)
schizophreniaMain <- gsub("Due to \n\n## Another", "Due to Another", schizophreniaMain)
schizophreniaMain <- gsub("Spectrum and \n\n## Other", "Spectrum and Other", schizophreniaMain)
schizophreniaMain <- gsub("Disorder \n\n## Due", "Disorder Due", schizophreniaMain)
schizophreniaMain <- gsub("## Some signs of the disturbance", "Some signs of the disturbance", schizophreniaMain) ## false header
schizophreniaMain <- gsub("■Multiple", " Multiple", schizophreniaMain)
schizophreniaMain <- gsub("\n## Unspecified", "\nUnspecified", schizophreniaMain)
schizophreniaMain <- gsub("\n## The essential features of psychotic", "\nThe essential features of psychotic", schizophreniaMain)
schizophreniaMain <- gsub("## Examples of presentations that", "Examples of presentations that", schizophreniaMain)

#### table replacement
startTag <- "(?s)(?<=substance-induced psychotic disorder\\.\n\n)##"
stopTag <- "(?=_Specify..if \\(see Table 1)"
paste(startTag, ".*", stopTag, sep= "")
schizophreniaMain <- gsub(paste(startTag, ".*", stopTag, sep= ""), "<--TABLE-P111-->\n\n", schizophreniaMain, perl=T) ## table
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
schizophreniaMain <- gsub("<--TABLE-P111-->\n\n", replaceTable, schizophreniaMain, perl=T) ## table


store <- schizophreniaMain
##schizophreniaMain <- store
writeLines(schizophreniaMain, "schizophreniaMain.txt")

### Add tags

## Note bipolar sub-classification : 295.70 (F25.0) Bipolar type, should perhaps be marked as diagnosis, if so also Psychotic Disorder Due to Another Medical Condition

## assign group tags
schizophreniaMain <- assignTag(schizophreniaMain, groupList, tag = "<--@GROUP-->", hash.replace = "##g")

## assign diagnosis tags
##icd10cmDsm5 <- read_csv("icd10cm-to-dsm5.csv")

schizophreniaMain <- assignTag(schizophreniaMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE, hash.replace = "##d") ## Noe that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)
schizophreniaMain <- assignTagHeader(schizophreniaMain)

#### write
## store copy
store <- schizophreniaMain
##schizophreniaMain <- store ## recover
writeLines(schizophreniaMain, "schizophreniaMain.txt")
## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file

## Join intro to main
schizophreniaMain <- paste(schizophreniaIntro, schizophreniaMain, sep = "\n\n") ## join
schizophreniaMain <- gsub("^", paste("##i Introduction to ", chapterTitle, "\n\n", sep=""), schizophreniaMain) ## Add header to intro
schizophreniaMain <- gsub("^", paste("##c ", chapterTitle, "\n\n", sep=""), schizophreniaMain) ## Add chapter
writeLines(schizophreniaMain, "schizophreniaMain.txt")

## import and cleaning

### Neurodevelopmantal disorders =====================================

### Neurodevelopmental disorders intro
neurodevelopmentalIntro <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 69:71) ## "Neurodevelopmental disorders". ## Note: remove last part
neurodevelopmentalIntro <- paste(neurodevelopmentalIntro, collapse = "")
neurodevelopmentalIntro <- cleanText(neurodevelopmentalIntro)
neurodevelopmentalIntro <- makeHeaders(neurodevelopmentalIntro)
neurodevelopmentalIntro <- gsub("ΤΙί Θ Π θυΓΟ όθνθΙορΓΠ Θ Π ΐάΙ", "The neurodevelopmental", neurodevelopmentalIntro)
neurodevelopmentalIntro <- gsub("## Intellectual Disabilities.*", "", neurodevelopmentalIntro) ## remove redundant part of next chunk
neurodevelopmentalIntro <- gsub("- ", "", neurodevelopmentalIntro)
writeLines(neurodevelopmentalIntro, "neurodevelopmentalIntro.txt")

### Neurodevelopmental main body
neurodevelopmentalMain <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 71:124) ## "Neurodevelopmental disorders".
neurodevelopmentalMain[1] <-
    gsub("(?s).*(?=\nIntellectual Disabilities\n)", "", neurodevelopmentalMain[1], perl=T) ## remove redundant text before section starts and 
neurodevelopmentalMain[1] <- gsub("^\n", "## ", neurodevelopmentalMain[1]) ## add ## to first line
neurodevelopmentalMain <- paste(neurodevelopmentalMain, collapse = "") ## collapse to one
neurodevelopmentalMain <- cleanText(neurodevelopmentalMain)
neurodevelopmentalMain <- makeHeaders(neurodevelopmentalMain)
neurodevelopmentalMain <- cleanMore(neurodevelopmentalMain)

#### chunk specific replacements
neurodevelopmentalMain <- gsub("(?s)\\.&.*Æu cru", "\n\n<--TABLE REMOVED-->", neurodevelopmentalMain, perl = T)
## neurodevelopmentalMain <- gsub("c\\.2.cS.*(I  1 1)", "\n\n<--TABLE REMOVED-->", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("c\\.2.cS.*I 1 1", "\n\n<--TABLE REMOVED-->", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("Public Law \n\n111 ", "Public Law 111", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("intoxications \n\n\\(e", "intoxications \\(e", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("\n\nFragile X", "Fragile X", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("Global Developmental Delay315.8 \\(F88\\)", "## Global Developmental Delay \n\n315.8 (F88)", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("\n\n\\(Intellectual Developmental Disorder\\)319 \\(F79\\)", "(Intellectual Developmental Disorder) \n\n319 (F79)", neurodevelopmentalMain)
neurodevelopmentalMain <- gsub("(\n\n## )(\\(Intellectual)", " \\2", neurodevelopmentalMain, perl = T)

### Add tags

#### List groups
groupList <- c(
    "Intellectual Disabilities",
    "Communication Disorders",
    "Autism Spectrum Disorder",
    "Attention-Deficit/Hyperactivity Disorder",
    "Specific Learning Disorder",
    "Motor Disorders",
    "Other Neurodevelopmental Disorders"
)

## assign group tags
neurodevelopmentalMain <- assignTag(neurodevelopmentalMain, groupList, tag = "<--@GROUP-->", hash.replace = "#")

## assign diagnosis tags
##icd10cmDsm5 <- read_csv("icd10cm-to-dsm5.csv")

neurodevelopmentalMain <- assignTag(neurodevelopmentalMain, listDiagnoses, "<--@DIAGNOSIS-->", ignore.case = TRUE) ## Noe that this will replace match with diagnosis from list (inlcuding CAPS/nocaps from list)

#### write
## store copy
store <- neurodevelopmentalMain
##neurodevelopmentalMain <- store ## recover
writeLines(neurodevelopmentalMain, "neurodevelopmentalMain.txt")
## Now use elisp function "replace-bounded-hash" to flatten some lists n txt file
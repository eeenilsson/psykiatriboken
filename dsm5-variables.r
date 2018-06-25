## List with dsm 5 diagnoses and ICD codes, used for tags
icd10cmDsm5 <- read_csv("icd10-dsm5.csv")

#### clean tags list
icd10cmDsm5$dsm5textClean <- gsub("\\[.*\\+\\][[:blank:]]", "", icd10cmDsm5$dsm5text) ## remove stuff in brackets
icd10cmDsm5$icd10cmClean <- gsub("\\[.*\\+\\][[:blank:]]", "", icd10cmDsm5$icd10cm) ## remove stuff in brackets
## listBrackets <- grep("\\[.*\\+\\][[:blank:]]", icd10cmDsm5$dsm5text, value=T) ## get list of stuff in brackets ## NOT working properly
listDiagnoses <- gsub("([.|()\\^{}+$*?]|\\[|\\])", "\\\\\\1", icd10cmDsm5$dsm5textClean) ## escape regex characters
listCodes <- gsub("([.|()\\^{}+$*?]|\\[|\\])", "\\\\\\1", icd10cmDsm5$icd10cmClean)

## remove everything after comma, for matching
listDiagnoses <- lapply(listDiagnoses, function(x){gsub("([^,]*)(.*)", "\\1", x)}) ## get diagnosis before comma, for matching
listDiagnoses <- simplify2array(listDiagnoses)


## list of headers, to identify these
## Note: Ok to use jst the start of header (the end may be chapter-specific)
listHeaders <- c(
    "Diagnostic Criteria",
    "Recording Procedures",
    "Specifiers",
    "Subtypes",
"Coding and Recording Procedures",
"Diagnostic Features",
"Associated Features Supporting Diagnosis",
"Prevalence",
"Development and Course",
"Risk and Prognostic Factors",
"Culture-Related Diagnostic Issues",
"Gender-Related Diagnostic Issues",
"Suicide Risk",
"Functional Consequences of",
"Differential Diagnosis",
"Diagnostic Markers",
"Comorbidity",
"Specifiers for",
"Relationship to Other Classifications",
"Specifiers for Depressive Disorders",
"Features",
"Associated Features",
## Custom headers
"Introduction to" ## for intro sections
)

#### List groups
groupList <- c(
    ## Neurodevelopmental
    "Intellectual Disabilities",
    "Communication Disorders",
    "Autism Spectrum Disorder",
    "Attention-Deficit/Hyperactivity Disorder",
    "Specific Learning Disorder",
    "Motor Disorders",
    "Other Neurodevelopmental Disorders",
     ## Schizophrenia
    "Catatonia"
    ## Bipolar: None
    ## Depressive: None
)


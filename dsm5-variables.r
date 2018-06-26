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
"Gender-Related Issues",
"Suicide Risk",
"Functional Consequences of",
"Differential Diagnosis",
"Diagnostic Markers",
"Comorbidity",
"Specifiers for",
"Relationship to Other Classifications",
"Relationship to",
"Specifiers for Depressive Disorders",
"Features",
"Risk and Prognostic",
"Associated Features",
"Severity and Specifiers",
"Substance Intoxication",
"Route of Administration",
"Duration of Effects",
"Use of Multiple Substances",
"Associated Laboratory",
"Substance/Medication-Induced Mental Disorders",
## Custom headers
"Introduction to", ## for intro sections
## Sub-diagnoses that are to be kept as headers on same level as diagnosis
"Delayed Sleep Phase Type",
"Advanced Sleep Phase Type",
"Irregular Sleep-Wake Type",
"Non-24-Hour Sleep-Wake Type",
"Shift Work Type"
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
    "Catatonia",
    ## Bipolar: None
    ## Depressive: None
    ## Other
    "Breathing-Related Sleep Disorders",
    "Parasomnias",
    "Gender Dysphoria",
    "Substance-Related Disorders",
    "Substance Use Disorders", ## Sub to Substance-Related Disorders
    "Substance-Induced Disorders" ## Sub to Substance-Related Disorders
)

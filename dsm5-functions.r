## Functions to clean DSM5 text

## Functions
source('makeDsmEntry.r')

spellCorrect <- function(SPELL, CHUNK){
    ## Replaces matches in CHUNK from SPELL list. SPELL is a list of named elements with name = match and value = replacement 
    TEMP <- CHUNK
    for (i in 1:length(SPELL)){
    TEMP <-
        gsub(names(SPELL[i]), SPELL[i][[1]], TEMP, perl=T)
    }
    return(TEMP)    
}

makeHeaders <-function(x){
    gsub("((?<=\n)(?:(?![\\,\\.]).)+(?=\n){1}?)", "## \\1", x, perl=T)
}

cleanNewlines <- function(CHUNK){
    ## removes newlines not followed by parens, Cap, number. or multiplnumbers
    gsub("(?s)\n(?!\\(|[A-Z]|[0-9]\\.|[0-9]{3,}.*\\(F)", "", CHUNK, perl=T) 
}

cleanText <- function(CHUNK) {
    ## gathers some text cleaning functions
    TEMP <- CHUNK
    TEMP <- gsub("­\n", "", TEMP) ## remove - at end of line
    TEMP <- spellCorrect(spellList, TEMP)
    TEMP <- cleanNewlines(TEMP)
    TEMP <- gsub("\n", "\n\n", TEMP) ## double newline
    TEMP <- gsub("•", "\n•", TEMP)
    TEMP <- gsub("\\.{2,}", "\t", TEMP)
    TEMP <- gsub("((?<=\\.)[A-Z])", " \\1", TEMP, perl=T)
    return(TEMP)
}

cleanMore <- function(CHUNK){
    TEMP <- CHUNK
    TEMP <- gsub("(\n\n## )([0-9])", "\n\n\\2", TEMP, perl = T)
    TEMP <- gsub("## \\(", "\\(", TEMP) ## removes hashes before severity diagnoses
    TEMP <- gsub("## With", "With", TEMP)
    TEMP <- gsub("\n\n([A-Z].*\\))(?=(\n\n[A-Z]\\.))", "\n\n### \\1", TEMP, perl = T) ### subheaders for multiple subdiagnoses in the diagnostic criteria section
    TEMP <- gsub("\n\n## Disorder\n\n", "Disorder\n\n", TEMP) ## make ##Disorder not be separate header
    TEMP <- gsub("(### )([A-Z]\\.)", "\\2", TEMP)
    TEMP <- gsub("## Specify", "_Specify_", TEMP)
    TEMP <- gsub("(\\.)([a-z]\\.[[:blank:]][A-Z])", "\\1\n\\2", TEMP) ## lowercase lists
    TEMP <- gsub("\\/.\n\n## ", "\\/", TEMP) ## remove forwardslash
    TEMP <- gsub("(?<=(##))( .*)\n\n\\(", "\\2 (", TEMP, perl=T)
    TEMP <- gsub("([a-z])( \n\n)(\\(e\\.g\\.)", "\\1 \\3", TEMP) ## e.g
    TEMP <- gsub("[[:blank:]]{2,}", " ", TEMP) ## remove repeated spaces
     ## fix diagnostic criteria
    TEMP <- gsub("### Diagnostic Criteria", "## Diagnostic Criteria", TEMP)
    TEMP <- gsub("\n\nDiagnostic Criteria\n\n", "## Diagnostic Criteria\n\n", TEMP)
    TEMP <- gsub("\n\nDiagnostic Criteria[[:blank:]](?=[0-9])", "\n\n## Diagnostic Criteria ", TEMP, perl=T)
    TEMP <- gsub("\n\nDiagnostic Criteria[[:blank:]](?=\\()", "\n\n## Diagnostic Criteria ", TEMP, perl=T)
    TEMP <- gsub("(\n\n## Diagnostic Criteria )((.{2,})?)(?=\n\n)", "\n\n\\2\\1", TEMP, perl=T)  ## put diagnosis codes before header if they exist

return(TEMP)
}

## assignTag <- function(CHUNK, LIST, tag = "<--@TAG-->", ignore.case = FALSE, hash.replace = "##"){
##     ## Assign label 'tag' to strings in CHUNK matching LIST
##     TEMP <- CHUNK
##     for (i in 1:length(LIST)){
##         TEMP <- sub(paste("## ", LIST[i], sep = ""),
##                     paste(hash.replace, " ", LIST[i], " ", tag, sep = ""), TEMP,
##                     ignore.case = ignore.case)
##     }
##     return(TEMP)
## }

assignTag <- function(CHUNK, LIST, tag = "<--@TAG-->", ignore.case = FALSE, hash.replace = "##", first.only = TRUE){
    ## Assign label 'tag' to strings in CHUNK matching LIST
    ## If first.only = TRUE only the first match in string will be tagged, else all maches will be tagged.
    ## hash.replace is a string with wich to replace hashes
    TEMP <- CHUNK
    if(isTRUE(first.only)){
    for (i in 1:length(LIST)){
        TEMP <- sub(paste("## (", LIST[i], ")(.*)?(?=\n\n)", sep = ""),
                    paste(hash.replace, " ", LIST[i], "\\2 ", tag, sep = ""), TEMP,
                    ignore.case = ignore.case,
                    perl=T)
    }
    }else{
            for (i in 1:length(LIST)){
        TEMP <- gsub(paste("## (", LIST[i], ")(.*)?(?=\n\n)", sep = ""),
                    paste(hash.replace, " ", LIST[i], "\\2 ", tag, sep = ""), TEMP,
                    ignore.case = ignore.case,
                    perl=T)
    }
    }
    return(TEMP)
}

assignTagHeader <- function(x){
    ## Wrapper for assignTag for marking headers
    TEMP <- x
    TEMP <- assignTag(TEMP,
                         listHeaders,
                         tag = "<--@HEADER-->",
                         hash.replace = "##h",
                         ignore.case=TRUE,
                      first.only=FALSE)
    return(TEMP)
}

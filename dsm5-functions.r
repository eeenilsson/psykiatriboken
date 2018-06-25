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
    TEMP <- cleanNewlines(TEMP)
    TEMP <- gsub("\n", "\n\n", TEMP) ## double newline
    TEMP <- gsub("•", "\n•", TEMP)
    TEMP <- gsub("\\.{2,}", "\t", TEMP)
    TEMP <- gsub("((?<=\\.)[A-Z])", " \\1", TEMP, perl=T)
    TEMP <- spellCorrect(spellList, TEMP)
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
    TEMP <- gsub("## Functional Consequences of\n\n##", "## Functional Consequences of ", TEMP)
    TEMP <- gsub("■", " ", TEMP)
        TEMP <- gsub("## Functional Consequences of \n\n##", "## Functional Consequences of", TEMP) ## with blank
    TEMP <- gsub("Disorder\n\n## Due", "Disorder Due", TEMP)
    TEMP <- gsub("Induced\n\n##", "Induced", TEMP)
    TEMP <- gsub("Induced \n\n##", "Induced", TEMP) ## with blank

    TEMP <- gsub("and \n\n## Related", "and Related", TEMP)
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

getSection <- function(START, STOP, x){
    ## Exract text betwen START and STOP, which are strings of regex.
    ## x is a string (contents of long text file)
    substr(x,
           regexpr(START, x, perl=T)[1],
           regexpr(STOP, x, perl=T)[1]+
           attr(regexpr(STOP, x, perl=T), "match.length")-1)
}

parseTableUseDisorder <- function (x){ 
    ## Read a string yanked from txt file
    ## Works on substance use ICD code tables
    mySection <- x
    mySection <- gsub("\n\n", " ", mySection) ## First get rid of newlines
    mySection <- gsub("##", "", mySection)
    mySection <- gsub("FI ", "F1", mySection)
    mySection <-
        gsub("^.*Withoutusedisorder.*?(?=[A-Z])", " ", mySection, perl=T) ## clean start, repl w blank
    mySection <- gsub("ICD.*disorder", "", mySection)
    mySection <- gsub("[[:blank:]]+", " ", mySection)
    mySection <-
        gsub("([[:blank:]][a-z ,\\(\\)]*)[[:blank:]][0-9]{3}\\.[0-9]{2}", "\n\\1;", mySection, perl=T, ignore.case=T) ## Row names identified
    mySection <- gsub("(F[0-9]{2}\\.[0-9]{2,3})", "\\1;", mySection, perl=T, ignore.case=T)
    TEMP <- read_delim(mySection, delim=";", trim_ws = TRUE, col_names = FALSE)
    return(TEMP[1:ncol(TEMP)-1]) ## last col empty
    }           

formatTable <- function(TABLE, caption = NULL){
    ## Add newlines after and start/stop tags before/after.
    paste("\n\n<--@TABLESTART--> ", caption, "\n", paste(as.character(kable(TABLE, align = paste("l", paste(rep("c", ncol(TABLE)), collapse=""), sep=""))), collapse="\n"), "\n<--@TABLESTOP-->\n\n", sep="") ## add newlines after    
}

tableTransform <- function(TABLE, type = 1){
    ## Prints table as text, structured according to one of two syntaxes.
    ## For use with dsm5 import.

    ## type 1 table
    if(type == 1){
        for(i in 2:nrow(TABLE)-1){
            newRow <- 
                paste(TABLE[[1]][i],
                      ": ICD-9-CM code ", TABLE[[2]][i],
                      "; ICD-10-CM code if use disorder is mild (", TABLE[[3]][i],
                      "), -moderate or severe (", TABLE[[4]][i],
                      ") or without use disorder (", TABLE[[4]][i],
                      ")",
                      sep = "")
            allRows[i] <- newRow
        }
        OUTPUT <- paste(allRows, collapse = "\n\n")        
    }else{
        ## Type 2 table
        allRows <- list() 
        for(i in 2:ncol(TABLE)-1){
            newRow <- 
                paste("- If ", names(TABLE)[i], ": ", paste(TABLE[[1]], TABLE[[i]], collapse = ", "), sep = "")
            allRows[i-1] <- newRow
        }
        OUTPUT <- paste(allRows, collapse = "\n\n")
    }
    return(OUTPUT)
}

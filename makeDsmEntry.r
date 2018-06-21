## Function to make bib entry for DSM chapter

makeDsmEntry <- function(chapter = "", pages = "", abstract = "", tag = ""){

bibStart <- paste("@Inbook{apa2013", tag, ",\n", sep="")
bibAuthor <- "    author = {American Psychiatric Association},\n"
bibTitle <- "    title = {Diagnostic and Statistical Manual of Mental Disorders},\n"
bibChapter <- paste("    chapter = {", chapter, "},\n", sep="")
bibPages <- paste("    pages = {", pages, "},\n", sep="")
bibPublisher <- "    publisher = {American Psychiatric Association},\n"
bibAddress <- "    address = {Arlington, VA},\n"
bibYear <- "    year = {2013},\n"
bibEdition <- "    edition = {Fifth Edition},\n"
bibAbstract <- paste("    abstract = {", abstract,"},\n", sep ="")
    bibEnding <- "}\n\n"
bibEntry <- paste(bibStart, bibAuthor, bibTitle, bibChapter, bibPages, bibPublisher, bibAddress, bibYear, bibEdition, bibAbstract, bibEnding, sep="")
return(bibEntry)
}

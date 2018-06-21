## Function to make bib entry for DSM chapter

makeDsmEntry <- function(chapter = "", pages = "", abstract = "", tag = ""){
    bibStart <- paste("@Inbook{apa2013", tag, ",", sep="")
    bibAuthor <- "    author = {{American Psychiatric Association}},"
    bibTitle <- "    title = {Diagnostic and Statistical Manual of Mental Disorders},"
    bibChapter <- paste("    chapter = {", chapter, "},", sep="")
    bibPages <- paste("    pages = {", pages, "},", sep="")
    bibPublisher <- "    publisher = {{American Psychiatric Association}},"
    bibAddress <- "    address = {Arlington, {VA}},"
    bibYear <- "    year = {2013},"
    bibEdition <- "    edition = {Fifth Edition},"
    bibAbstract <- paste("    abstract = {\n\n", abstract,"},", sep ="")
    bibEnding <- "}\n\n"
    bibEntry <- paste(bibStart, bibAuthor, bibTitle, bibChapter, bibPages, bibPublisher, bibAddress, bibYear, bibEdition, bibAbstract, bibEnding, sep="\n")
    return(bibEntry)
}

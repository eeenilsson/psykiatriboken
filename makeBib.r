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

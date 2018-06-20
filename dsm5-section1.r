## Section I (Introduction/basics) ================================
section1 <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 45:66) ## "DSM-5 basics". Note that chapter title is a graphic and will not be extracted
section1 <- paste(section1, collapse = "")
section1 <- gsub("ΤΙΊΘ C rG âtion  ", "\n The creation ", section1)
section1 <- cleanText(section1)
section1 <- makeHeaders(section1)
writeLines(section1, "section1.txt")

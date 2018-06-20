## Section II Diagnostic criteria ==========================

### TOC
section2toc <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 67) ## "Diagnostic criteria and codes". [TOC]
section2toc <- paste(section2toc, collapse = "") ## collapse to one
section2toc <- gsub("\\.{2,}", "\t", section2toc)
section2toc <- gsub("\\.«.*riDiagnostic..", "## Diagnostic criteria and codes", section2toc)
writeLines(section2toc, "section2toc.txt")

### preface to section II
section2preface <- extract_text("/home/eee/Dropbox/psykiatri/documents/dsm-5-manual-2013.pdf", pages = 68) ## [Preface]
section2preface <- paste(section2preface, collapse = "")
section2preface <- cleanText(section2preface)
section2preface <- makeHeaders(section2preface)
writeLines(section2preface, "section2preface.txt")

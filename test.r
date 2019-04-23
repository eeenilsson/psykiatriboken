make_rows <- function(text, linelength = 66){

## split text into elements with nchar < linelength
    
words <- strsplit(text, " ")[[1]]
words <- paste0(words, " ")

x <- cumsum(sapply(words, nchar))

y <- cut(x, breaks = seq(from = 0, to = 1000, by = linelength))

l <- split(x, y)

l <- l[lapply(l,length)>0] 

br <- sapply(l, max)



out <- substring(
    text,
    c(1, br + 1),
    c(br, nchar(text))
)
    
    return(out[out != ""])
    
    }

## Example
## text <- "Resultaten är summerade från tre olika studier där respektive symtom efterfrågades vid totalt 87 till 564 bipolära episoder. Se [@Cassidy1998]."
## make_rows(text)

## abbreviations

abbreviations <- c(
    'Mdn' = "Median"    
)


## table bip trtr
x <-
    read_csv('abbreviations.csv')
tmp <- make_namedlist(x,"label", "variable")
abbreviations <- c(abbreviations, tmp)



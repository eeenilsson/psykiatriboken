## abbreviations

abbreviations <- c(
    'Mdn' = "Median",
    'nd' = "No data"
)


## table bip trtr
x <-
    read_csv('abbreviations.csv')
tmp <- make_namedlist(x,"label", "variable")
abbreviations <- c(abbreviations, tmp)



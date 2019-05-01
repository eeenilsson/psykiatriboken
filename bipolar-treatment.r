
pacman::p_load(tidyverse)

dta <- read_csv('../notes/bipolar_treatment.csv')

dta%>%
    rowwise()%>%
    mutate(
        prio = min(mono, adj, na.rm = TRUE)
    ) -> dta

dta%>%
    filter(
        prio == 1 | prio == 2
    ) -> dta1

## dta1%>%
##     filter(drug == "bupropion") -> dta1

dta1%>%
    mutate(
        adj = ifelse(adj == 1|adj == 2, adj, NA),
        adj_to= ifelse(adj == 1|adj == 2, adj_to, NA)
    ) -> dta1

dta1%>%
    mutate(
        adjunctive = ifelse(is.na(mono),
                                  paste0(adj, " with ", adj_to),
                                  ifelse(mono == adj, paste0("+-", adj_to),
                     ifelse(!is.na(adj), paste0("(", adj, " with ", adj_to, ")"), NA)
                     )),
        show = paste0(mono, " ", adjunctive)
    ) -> dta1

## dta[dta == 3] <- NA ## exclude third line
## dta[dta == "3l"] <- NA
## dta[dta == "3v"] <- NA
## dta[dta == "3lv"] <- NA

dta1%>%
    select(drug, phase, show)%>%
    spread(
        phase, show
    ) -> show



dta1%>%
    select(drug, phase, mono)%>%
    spread(
        phase, mono
    ) -> mono

dta1%>%
    select(drug, phase, adj_to)%>%
    spread(
        phase, adj_to
    ) -> adj

## dta%>%
##     select(drug, phase,  adj_to) -> adj_to

names(adj)[2:4] <- paste0(names(adj)[2:4], "_adj")

tbl <- left_join(mono, adj)
## tbl <- left_join(adj_to, tbl)

mono%>%
    filter(drug == "lamotrigin")

adj%>%
    filter(drug == "lamotrigin")


tmp <- sapply(tbl[2:7], is.na)

tmp <- rowSums(tmp) != 6

tbl[tmp,] -> tbl

print(tbl, n = 100)

tbl%>%
    mutate(
        maintainance = paste0(maintainance, " (", maintainance_adj, ")"),
        mania = paste0(acute_mania, " (", acute_mania_adj, ")"),
        depression = paste0(acute_bipolar1depression, " (", acute_bipolar1depression_adj, ")"),
    ) -> tbl

tbl[tbl == "NA (NA)"] <- NA

names(tbl)

## filter 1-2nd line trt
## display 3rd line separately

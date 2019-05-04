
pacman::p_load(tidyverse)

dta <- read_csv('../notes/bipolar_treatment.csv')

dta%>%
    select(drug, phase, litium:omega3) -> tmp


tmp%>%
    gather(
        adjunct, line, -c(drug, phase)
    )%>%
    filter(line < 3) -> temp

toabbrev <- unique(c(temp$drug, temp$adjunct))

tmp%>%
    gather(
        adjunct, line, -c(drug, phase)
    )%>%
    filter(line < 3)%>%
    filter(!is.na(line))%>%    
    mutate(sign = ifelse(drug == adjunct,
                         "$\\pm$", NA),
           adjunct = ifelse(drug == adjunct, NA, adjunct))%>%
    ## filter(drug == "litium")%>%
    arrange(phase)%>%
    group_by(drug, phase, line)%>%
    summarise(
        adj = paste(ifelse(length(na.omit(sign))==0 & length(na.omit(adjunct)) != 0, "med", ifelse(length(na.omit(adjunct))!=0, na.omit(sign), "mono")), paste(na.omit(substr(adjunct, 1, 2)), collapse = "/"))
    )%>%
    group_by(phase)%>%
    complete(drug, line)-> tmp2

tmp2%>%
    mutate(
        adj = ifelse(line == 2, ifelse(!is.na(adj), paste0("\\textit{", adj, "}"), adj), adj)
    ) -> tmp2

tmp2%>%
    mutate(
        line = ifelse(is.na(adj), NA, line)
      ## ,adj = ifelse(is.na(adj), "n", adj)
    ) -> tmp2

tmp2[is.na(tmp2)] <- "-"

## tmp2%>% ## with line nr
##     group_by(drug, phase)%>%
##     summarise(
##         show = paste(line, adj, collapse = "\n")
##     ) -> tmp2

tmp2%>%
    group_by(drug, phase)%>%
    summarise(
        show = paste(adj, collapse = "\n")
    ) -> tmp2
    
tmp2%>%
    select(drug, phase, show)%>%    
    spread(
        phase, show
    ) -> tbl



## write_csv(
##     data.frame(
##         label = substr(toabbrev, 1, 2),
##     variable = toabbrev
    
##     ),
##     "abbreviations_bip.csv"

## )




## #########
## dta%>%
##     rowwise()%>%
##     mutate(
##         prio = min(mono, adj, na.rm = TRUE)
##     ) -> dta

## dta%>%
##     filter(
##         prio == 1 | prio == 2
##     ) -> dta1


## dta1%>% ## remove 3rd line trt
##     mutate(
##         mono = ifelse(mono == 1|mono == 2, mono, NA),
##         adj = ifelse(adj == 1|adj == 2, adj, NA),
##         adj_to= ifelse(adj == 1|adj == 2, adj_to, NA)
##     ) -> dta1

## dta1%>%
##     mutate(
##         adjunctive = ifelse(is.na(mono),
##                                   paste0(adj, " med ", adj_to),
##                                   ifelse(mono == adj, paste0("+- ", adj_to),
##                      ifelse(!is.na(adj), paste0("(", adj, " med ", adj_to, ")"), NA)
##                      )),
##         show = paste0(mono, " ", adjunctive)
##     ) -> dta1

## ### 3rd line treatments
## dta%>%
##     filter(
##         mono == 3 | adj == 3
##     ) -> dta3

## dta3%>%
##     mutate(
##         adj = ifelse(adj == 3, adj, NA),
##         adj_to= ifelse(adj == 3, adj_to, NA),
##         mono = ifelse(mono == 3, adj, NA)
##     ) -> dta3

## dta3%>%
##     mutate(
##         adjunctive = ifelse(is.na(mono),
##                                   paste0(adj, " med ", adj_to),
##                                   ifelse(mono == adj, paste0("+- ", adj_to),
##                      ifelse(!is.na(adj), paste0("(", adj, " med ", adj_to, ")"), NA)
##                      )),
##         show = paste0(mono, " ", adjunctive)
##     ) -> dta3
## ## TODO: Finish adjunctive as separate table

## ### reshape

## ## dta[dta == 3] <- NA ## exclude third line
## ## dta[dta == "3l"] <- NA
## ## dta[dta == "3v"] <- NA
## ## dta[dta == "3lv"] <- NA

## dta1%>%
##     select(drug, phase, show)%>%
##     spread(
##         phase, show
##     ) -> show

## show <- as.tibble(sapply(show, function(x) gsub(".?NA.?", "", x)))


## tibble(drug = show$drug,
##        n = as.numeric(rowSums(sapply(show[-1], function(x) substr(x, 1, 1) == "1"), na.rm = TRUE)),
##        mnt = as.numeric(sapply(show["maintainance"], function(x) substr(x, 1, 1)), na.rm = TRUE)
##       )%>%
##     arrange(mnt, -n)-> odr

## tbl <- show[match(odr$drug, show$drug),]

## colnames(tbl) <- c("drug", "depression", "mania", "maintainance")


#####

## dta1%>%
##     select(drug, phase, mono)%>%
##     spread(
##         phase, mono
##     ) -> mono

## dta1%>%
##     select(drug, phase, adj_to)%>%
##     spread(
##         phase, adj_to
##     ) -> adj

## ## dta%>%
## ##     select(drug, phase,  adj_to) -> adj_to

## names(adj)[2:4] <- paste0(names(adj)[2:4], "_adj")

## tbl <- left_join(mono, adj)
## ## tbl <- left_join(adj_to, tbl)

## mono%>%
##     filter(drug == "lamotrigin")

## adj%>%
##     filter(drug == "lamotrigin")


## tmp <- sapply(tbl[2:7], is.na)

## tmp <- rowSums(tmp) != 6

## tbl[tmp,] -> tbl

## print(tbl, n = 100)

## tbl%>%
##     mutate(
##         maintainance = paste0(maintainance, " (", maintainance_adj, ")"),
##         mania = paste0(acute_mania, " (", acute_mania_adj, ")"),
##         depression = paste0(acute_bipolar1depression, " (", acute_bipolar1depression_adj, ")"),
##     ) -> tbl

## tbl[tbl == "NA (NA)"] <- NA

## names(tbl)

## ## filter 1-2nd line trt
## ## display 3rd line separately

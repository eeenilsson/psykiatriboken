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
        adj = paste(ifelse(length(na.omit(sign))==0 & length(na.omit(adjunct)) != 0, "$\\\\+$", ifelse(length(na.omit(adjunct))!=0, na.omit(sign), "mono")), paste(na.omit(substr(adjunct, 1, 2)), collapse = "/"))
    )%>%
    group_by(phase)%>%
    tidyr::complete(drug, line)-> tmp2

## tmp2%>%
##     mutate(
##         adj = ifelse(line == 2, ifelse(!is.na(adj), paste0("_", adj, "_"), adj), adj)
##     ) -> tmp2

## tmp2%>%
##     mutate(
##         line = ifelse(is.na(adj), NA, line)
##       ## ,adj = ifelse(is.na(adj), "n", adj)
##     ) -> tmp2

## tmp2[is.na(tmp2)] <- "NA"

## tmp2%>% ## with line nr
##     group_by(drug, phase)%>%
##     summarise(
##         show = paste(line, adj, collapse = "\n")
##     ) -> tmp2

## tmp2%>%
##     group_by(drug, phase)%>%
##     summarise(
##         show = paste(adj, collapse = "\n")
##     ) -> tmp2

tmp2%>%
    mutate(show = adj,
           hand = ifelse(line == 1, "1:a", "2:a")) -> tmp2

tmp2%>%
    select(drug, hand, phase, show)%>%
    pivot_wider(names_from = phase, values_from = show) -> tbl

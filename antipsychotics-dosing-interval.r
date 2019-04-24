## plot antipsychotics-dosing-interval

antipsychotics <- read_csv('../psykiatri_st/antipsychotics-annotated.csv')

antipsychotics%>%   
    filter(select == 1) -> antipsychotics

antipsychotics%>%    
    select(drug, dose_effective_min, dose_effective_target, dose_effective_limit, dose_max)%>%
    filter(!drug %in% c("Perphenazine", "Zuclopenthixol"))-> tmp

tmp%>%
    mutate(
        dosebracket = paste0("[",
                             dose_effective_min, ", ",
                             dose_effective_target, ", ",
                             dose_effective_limit,
                             "]")
    ) -> tmp

tmp%>%
    gather(point, dose, -c(drug, dose_effective_target, dosebracket)) -> tmplong

tmplong%>%
    mutate(
        dosep = dose/dose_effective_target * 100
    ) -> tmplong

tmplong%>%
    select(drug, point, dosep, dosebracket)%>%
    spread(point, dosep)-> tmp

tmp%>%
    mutate(
        ti = dose_effective_limit - dose_effective_min
    )%>%
    arrange(ti) -> tmp

tmp$drug <- factor(tmp$drug, levels = tmp$drug) ## factor and order

tmp%>%
    mutate(
        position_text = dose_effective_limit + nchar(dosebracket)*2 + 100
    ) -> tmp

## tmplong%>%
##     filter(point %in% c("dose_effective_min", "dose_effective_limit", "dose_max")) -> tmplong

p <- ggplot(aes(x = drug, y = 100), data = tmp)

p + geom_point() + labs(y = "Dose (% of target dose)", x = "Antipsychotic") +
    geom_errorbar(aes(ymin = dose_effective_min, ymax = dose_effective_limit)) +
    geom_point(aes(y = dose_max), color = "red") +
    geom_text(aes(y = 750, label = tmp$dosebracket)) + 
    coord_flip() +
    theme_classic() -> p

## pdf(file = "fig_antipsychotics_dose_interval.pdf")
## p
## dev.off()



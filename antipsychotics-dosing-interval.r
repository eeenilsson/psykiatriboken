## plot antipsychotics-dosing-interval

## source('varnames.r')

antipsychotics <- read_csv('../notes/antipsychotics-annotated.csv')

antipsychotics%>%
    filter(select == 1) -> antipsychotics

antipsychotics%>%
    select(drug, dose_effective_min, dose_effective_target, dose_effective_limit, dose_max)%>%
    filter(!drug %in% c("Perphenazine", "Zuclopenthixol"))-> tmp

tmp$drug <- query_label(tmp$drug, varnames)

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

p + geom_point() +
    labs(y = "Dose (% of target dose)", x = "Antipsychotic") +
    geom_errorbar(aes(ymin = dose_effective_min, ymax = dose_effective_limit)) +
    geom_point(aes(y = dose_max), color = "red", show.legend = TRUE) +
    geom_text(aes(y = 750, label = tmp$dosebracket)) +
    coord_flip() +
    theme_classic() -> p

p + scale_fill_identity(name = 'the fill', guide = 'legend',labels = c('m1')) +
    theme(legend.position="bottom") -> p

## pdf(file = "fig_antipsychotics_dose_interval.pdf")
## p
## dev.off()

## label guide test

p <- ggplot(data = tmp)

p +
    geom_point(aes(x = drug, y = dose_max, color = "red", shape = "red"), size = 3.5) +
    geom_point(aes(x = drug, y = 100, color = "cornflowerblue", shape = "cornflowerblue"), size = 3) +

    geom_text(aes(x = drug, y = 750, label = tmp$dosebracket)) +
    coord_flip() +
    theme_classic() +
    theme(legend.position="bottom",
          plot.title = element_text(hjust = 0.5),
          axis.title.y = element_blank(),
          axis.text= element_text(colour = "black")
                    ) -> p

p + scale_colour_manual(name = '',
                        values =c('red'='red', 'cornflowerblue' = 'cornflowerblue'),
                        labels = c('Måldos', 'Maxdos')) +
    scale_shape_manual(name = '',
                       values = c('red' = 18, 'cornflowerblue' = 19),
                       labels = c('Måldos', 'Maxdos')) -> p

p + geom_errorbar(aes(x = drug, ymin = dose_effective_min, ymax = dose_effective_limit)) -> p

ti <- labs(
    title = "Dosering av antipsykotiska läkemedel"
)

ax <- labs(y = "Dos (% av måldos)")

cap <- labs(
    caption = "Linjerna visar intervallet mellan minsta effektiva dos och högsta effektiva dos, över vilken större effekt inte har visats.\nKlamrarna visar (i mg) [minsta effektiva dos: måldos, högsta effektiva dos].\nAnpassat från Maudsley Prescribing Guidelines in Psychiatry, 13:e upplagan, och FASS, av Erik Nilsson.")

p + ti + ax + cap

ggsave("fig-antipsychotics-dosing-interval.pdf", device = pdf())

## p + ax

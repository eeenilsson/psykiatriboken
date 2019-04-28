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

p + geom_point() +
    labs(y = "Dose (% of target dose)", x = "Antipsychotic") +
    geom_errorbar(aes(ymin = dose_effective_min, ymax = dose_effective_limit)) +
    geom_point(aes(y = dose_max), color = "red", show.legend = TRUE) +
    geom_text(aes(y = 750, label = tmp$dosebracket)) +
    coord_flip() +
    theme_classic() -> p

p + scale_fill_identity(name = 'the fill', guide = 'legend',labels = c('m1')) +
    theme(legend.position="bottom")

## pdf(file = "fig_antipsychotics_dose_interval.pdf")
## p
## dev.off()

require(tidyverse)

p <- ggplot(data = tmp)

p +
    geom_point(aes(x = drug, y = dose_max, color = "red", shape = "red")) +
    geom_point(aes(x = drug, y = 100, color = "cornflowerblue", shape = "cornflowerblue")) +
    labs(y = "Dose (% of target dose)", x = "Antipsychotic") +
    geom_text(aes(x = drug, y = 750, label = tmp$dosebracket)) +
    coord_flip() +
    theme_classic() +
    theme(legend.position="bottom") -> p

p + scale_colour_manual(name = '',
                        values =c('red'='red', 'cornflowerblue' = 'cornflowerblue'),
                        labels = c('Target dose', 'Maximum dose')) +
    scale_shape_manual(name = '',
                       values = c('red' = 2, 'cornflowerblue' = 3),
                       labels = c('Target dose', 'Maximum dose')) -> p
p
p + geom_errorbar(aes(x = drug, ymin = dose_effective_min, ymax = dose_effective_limit))


?geom_line
?scale_colour_manual
?scale_shape_manual

## p + scale_fill_identity(guide = 'legend', labels = c(target = 'm1')) +
##     theme(legend.position="bottom") +
##     theme(legend.title=element_blank())

## test longdata
## names(tmp)
## tmp%>%
##     gather(key, value, dose_effective_limit:position_text) -> tmpl
## tmp_range = tmp%>%select(drug, dosebracket, dose_effective_min, dose_effective_limit)

## unique(tmpl$key)

## p <- ggplot(aes(x = drug, y = value, data = tmpl)

## p +
##     geom_point(aes(x = drug, y = value, fill = key), data = subset(tmpl, key == "dose_max")) +
##     geom_point(aes(x = drug, y = 100, fill = key), data = subset(tmpl, key == "dose_max")) +
##     geom_errorbar(aes(x = drug, ymin = dose_effective_min, ymax = dose_effective_limit, data = tmp_range, color = "black") +
##     geom_text(aes(x = drug, y = 750, label =  tmp_range$dosebracket), data =  tmp_range) +
##     coord_flip() +
##     theme_classic() +
##     labs(y = "Dose (% of target dose)", x = "Antipsychotic") +
##     theme(legend.position="bottom")


## -> p
## p


    errors=matrix(c(-3.800904,-3.803444,-3.805985,-3.731204,-3.743969,
                -3.756735,-3.742510,-3.764961,-3.787413,-3.731204,-3.743969,-3.756735,
                -3.711420,-3.721589,-3.731758,-3.731204,-3.743969,-3.756735,-3.636346,
                -3.675159,-3.713971,-3.731204,-3.743969,-3.756735),nrow=4,byrow=TRUE)

errors = rbind(errors[, 1:3], errors[,4:6]) # manually reshaping the data
modelName=c("model 1","model 2","model 3","model 0")
type = rep(c("model", "obs"), each = 4)

boxdata=data.frame(errors,modelName, type)

colnames(boxdata)=c("icp","pred","icm","model", "type")

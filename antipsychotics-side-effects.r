## plot antipsychotics-dosing-interval
require(tidyverse)
source('../functions/query_label.r')
source('varnames.r')

antipsychotics <- read_csv('../notes/antipsychotics-annotated.csv')

antipsychotics%>%
    filter(select == 1) -> antipsychotics

side_effects <- names(antipsychotics[9:15])

antipsychotics%>%
    select(c("drug", side_effects)) -> tmp

## tmp%>%
##     filter(!drug %in% c("Perphenazine", "Zuclopenthixol")) -> tmp

## qtt similar for those in use, so not useful

tmp$drug <- query_label(tmp$drug, varnames)

tmp%>% ## arrange according to sum side effect score
    mutate(sum = rowSums(.[-1]))%>%
    arrange(-sum)-> tmp
tmp$sum <- NULL

tmp$drug <- factor(tmp$drug, levels = tmp$drug) ## factor and order

tmp%>%
    gather(effect, level, -c(drug)) -> tmp

## tmp%>%
##     filter(!effect %in% c("qtt")) -> tmp

p <- ggplot(aes(x = drug, y = level+0, fill = drug), data = tmp)


## p1 <- ggplot(aes(x = drug, y = level+1, fill = drug), data = subset(tmp, effect %in% c("sedation", "weight_gain", "prolactin")))

## p2 <- ggplot(aes(x = drug, y = level+1, fill = drug), data = subset(tmp, !(effect %in% c("sedation", "weight_gain", "prolactin"))))

## base
p + geom_bar(position="dodge", stat="identity") + facet_grid(rows = vars(effect)) +
    labs(y = "Risk level (0, very low; 1, low; 2, moderate; 3, high)", x = "Antipsychotic") -> p

    ## labs(y = "Risk level (1, very low; 2, low; 3, moderate; 4, high)", x = "Antipsychotic") -> p


## all 4

p + facet_wrap("effect", nrow = 1
               ## , scales = "free_x" ## use if multiple rows
               ,labeller = labeller(effect = varnames)
               ) +
    coord_flip() +
    theme_classic(base_size = 12) +
   theme(legend.position = "none") +
   theme(plot.margin = unit(c(1,1,1,1), "cm")) +
    theme(axis.text= element_text(colour = "black"),
          axis.title=element_blank(),
          plot.title = element_text(hjust = 0.5),
          plot.subtitle = element_text(hjust = 0.5)) -> p4

## lbls <- labs(title = "Antipsychotics relative risk of side effects",
##              ## subtitle = "Plot of length by dose",
##               caption = "Risk level: 1, very low; 2, low; 3, moderate; 4, high. Adapted from Maudsley Prescribing Guidelines in Psychiatry, 13ed")

ti <- labs(title = "Biverkningar av antipsykotiska läkemedel"
           ## subtitle = "Plot of length by dose"
           )

cap <- labs(
              caption = "Risknivå: 1, mycket låg; 2, låg; 3, måttlig; 4, hög. Risknivåerna är en grov uppskattning av relativ risk.\n
Anpassat från Maudsley Prescribing Guidelines in Psychiatry, 13:e upplagan, av Erik Nilsson."
)

p4

## p4 + cap + ti

## ggsave("../dropbox/fig-antipsychotics-side-effects.pdf",
##       , width = 297, height = 210, units = 'mm' )

## other plot versions


## ## all
## p +
##     coord_flip() +
##     theme_classic(base_size = 10) -> p_all

## ## all 2

## p + facet_wrap("effect", nrow = 2
##              , scales = "free_x"
##                ) +
##     coord_flip() +
##     theme_classic(base_size = 12) +
##     theme(legend.position = c(1, 0), legend.justification = c(1.2, -0)) +

##     theme(axis.text= element_text(colour = "black"),
##           axis.title.y=element_blank()) -> p2

## ## all 3

## p + facet_wrap("effect", ncol = 1
##              ## , scales = "free_x"
##                ) +
##    ## coord_flip() +
##     theme_classic(base_size = 12) +
##     ## theme(legend.position = c(1, 0), legend.justification = c(1.2, -0)) +
##    theme(plot.margin = unit(c(1,1,1,1), "cm")) +
##     theme(axis.text= element_text(colour = "black"),
##           axis.title.y=element_blank()) -> p3

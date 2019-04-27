## plot antipsychotics-dosing-interval
require(tidyverse)
antipsychotics <- read_csv('../psykiatri_st/antipsychotics-annotated.csv')

antipsychotics%>%   
    filter(select == 1) -> antipsychotics

side_effects <- names(antipsychotics[8:15])

antipsychotics%>%
    select(c("drug", side_effects))%>%
    filter(!drug %in% c("Perphenazine", "Zuclopenthixol")) -> tmp ## qtt similar for those in use

tmp$drug <- factor(tmp$drug, levels = tmp$drug) ## factor and order

tmp%>%
    gather(effect, level, -c(drug)) -> tmp

tmp%>%
    filter(!effect %in% c("qtt")) -> tmp

p <- ggplot(aes(x = drug, y = level+1, fill = drug), data = tmp)

p + geom_bar(position="dodge", stat="identity") + facet_grid(rows = vars(effect)) +
    labs(y = "Risk level (1, very low; 2, low; 3, moderate; 4, high)", x = "Antipsychotic") +
    coord_flip() +
    theme_classic(base_size = 10) -> p

## pdf(file = "../dropbox/fig-antipsychotics-side-effects.pdf")
## p
## dev.off()




pacman::p_load(tidyverse)

dta <- read_csv('../notes/bipolar_treatment.csv')



dta%>%
    select(drug, phase, mono)%>%
    spread(
        phase, mono
    ) -> mono

dta%>%
    select(drug, phase, adjunct)%>%
    spread(
        phase, adjunct
    ) -> adj

names(adj)[2:4] <- paste0(names(adj)[2:4], "_adj")


left_join(mono, adj)

print(mono, n = 100)

## filter 1-2nd line trt
## display 3rd line separately

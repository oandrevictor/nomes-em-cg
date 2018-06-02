require(tidyverse)
require(here)
vias_raw = read_csv(here("data/vias_cg.csv"))

vias = vias_raw %>%
    group_by(nomelograd) %>%
    mutate(trechos = 1) %>%
    summarise_at(
        vars(
            arvore,
            bancos,
            pontoonibu,
            pontotaxi,
            pontomotot,
            semaforo,
            trechos,
            faixapedes
        ),
        sum
    ) %>% 
    mutate()

vias %>%
    write_csv(here("data/vias-tidy.csv"))
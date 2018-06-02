PROFISSOES = frame_data(
    ~profissao, ~tipo_profissao,
    "Professor", "liberal",
    "Professora", "liberal",
    "Engenheiro", "liberal",
    "Jornalista", "liberal",
    "Doutor", "liberal",
    "Coronel", "militar",
    "Capitão", "militar",
    "Almirante", "militar",
    "Major", "militar",
    "Marechal", "militar",
    "General", "militar",
    "Santa", "religioso",
    "São", "religioso",
    "Santo", "religioso",
    "Papa", "religioso",
    "Frei", "religioso",
    "Pastor", "religioso",
    "Prefeito", "político",
    "Vereador", "político",
    "Senador", "político",
    "Deputado", "político",
    "Governador", "político",
    "Presidente", "político",
    "Maestro", "artista",
    "Barão", "nobre",
    "Conde", "nobre",
    "Dom", "nobre",
    "Cantor", "artista",
    "Compositor", "artista"
)

theme_report <- function(base_size = 11,
                         strip_text_size = 12,
                         strip_text_margin = 5,
                         subtitle_size = 13,
                         subtitle_margin = 10,
                         plot_title_size = 16,
                         plot_title_margin = 10,
                         ...) {
    ret <- ggplot2::theme_minimal(base_family = "RobotoCondensed-Regular",
                                  base_size = base_size, ...)
    ret$strip.text <-
        ggplot2::element_text(
            hjust = 0,
            size = strip_text_size,
            margin = margin(b = strip_text_margin),
            family = "Roboto-Bold"
        )
    ret$plot.subtitle <-
        ggplot2::element_text(
            hjust = 0,
            size = subtitle_size,
            margin = margin(b = subtitle_margin),
            family = "PT Sans"
        )
    ret$plot.title <-
        ggplot2::element_text(
            hjust = 0,
            size = plot_title_size,
            margin = margin(b = plot_title_margin),
            family = "Oswald"
        )
    ret
}

read_projectdata <- function(){
    readr::read_csv(here("data/vias-tidy.csv"), 
                    col_types = cols(
                        nomelograd = col_character(),
                        .default = col_integer()
                    )) %>% 
        filter(
            !is.na(nomelograd),
            !nomelograd %in% c("ACESSO")
        ) %>% 
        mutate(
            nomelograd = stringr::str_to_title(nomelograd),
            profissao = stringr::word(nomelograd, 2) # infere do nome da rua
        ) %>% 
        left_join(PROFISSOES, by = "profissao") %>% 
        mutate(
            primeiro_nome = case_when(
                profissao %in% c("Das", "Da", "Do", "Dos", "Identificado") ~ NA_character_, # "Rua Das...
                profissao %in% c("Barão", "Oeste") ~ stringr::word(nomelograd, 4), 
                is.na(tipo_profissao) ~ profissao, # não achou a profissão, deve ser nome
                TRUE ~ stringr::word(nomelograd, 3) 
            )
        ) %>%  
        mutate(
            profissao = if_else(is.na(tipo_profissao) | word(nomelograd, 1, 2) == "Não Identificado", NA_character_, profissao), 
        ) 
}



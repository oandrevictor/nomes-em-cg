#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(here)
source(here("code/read_wrangle.R"))
library(ggplot2)
library(plotly)
library(DT)


vias = read_wrangle_data()

profissoes_nos_dados = vias %>% 
    filter(!is.na(profissao)) %>%  
    pull(profissao) %>% 
    unique()



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    prof_selecionada = reactive({input$profissao})
    minlen = reactive({input$minlen[1]})
    maxlen =  reactive({input$minlen[2]})
    
    output$distPlot <- renderPlotly({
        vias_profissao = vias %>%
            filter(profissao == prof_selecionada(), 
                   comprimento >= minlen(),
                   comprimento <= maxlen())
        
        plot_profissoes = vias_profissao %>%
            ggplot(aes(x=logradouro,
                       y=comprimento,
                       fill = as.factor(profissao),
                       text = paste(nomelograd, " - ",
                                    comprimento,"m"))) +
            geom_point() +
            theme(axis.text.x = element_text(angle = 90,
                                             hjust = 1),
                  legend.position="none") + 
            labs(x = "Logradouro", y = "Comprimento (m)")
        
        ggplotly(plot_profissoes, tooltip = c("text")) %>%
            layout(margin = list(b = 100))
        })
    
    # PLOTS
    output$distViasProf <- renderPlotly({
        vias_profissao_validas = vias %>% filter(!is.na(profissao),
                                                 comprimento >= minlen(),
                                                 comprimento <= maxlen())
        plot = vias_profissao_validas %>% 
            ggplot(aes(x = profissao),
                   stat=count) +
            geom_bar(aes(x = profissao,
                         fill = as.factor(profissao),
                         text = paste(profissao),
                         label = ..count..), 
                     position = "dodge",
                     stat = "count"
                     )  +
            theme(axis.text.x = element_text(angle = 90,
                                             hjust = 1),
                  legend.position="none") + 
            labs(x = "Profissão", y = "Total")
        
        ggplotly(plot, tooltip = c("text","label")) %>%
            layout(margin = list(b = 100))
        
    })
    
      output$ex1 <- DT::renderDataTable(
        DT::datatable( vias %>%
                           filter(!is.na(profissao)) %>%
                           filter(comprimento >= minlen(),
                                  comprimento <= maxlen()) %>%
                           select(logradouro,nomelograd,comprimento),
                       options = list(pageLength = 10))
    )
    
})

library(shiny)
library(tidyverse)
library(here)
source(here("code/read_wrangle.R"))
library(DT)
library(plotly)


profissoes_nos_dados = read_wrangle_data() %>% 
    filter(!is.na(profissao)) %>%  
    pull(profissao) %>% 
    unique()


# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Nome das ruas por profissão"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("minlen", "Tamanho mínimo e máximo da via:", value = c(0,20000), min = 1, max = 20000),
            selectInput("profissao", 
                        "Profissão", 
                        choices = profissoes_nos_dados) 
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            titlePanel("Quantidade de vias por profissão"),
            plotlyOutput("distViasProf"),
            titlePanel("Vias para a profissão escolhida"),
            plotlyOutput("distPlot"), 
            DT::dataTableOutput('ex1')
        )
    )
))

library(shiny)
library(tidyverse) #only use for local operation #
# library(tidyverse, lib.loc = "/usr/local/lib/vance/tidyverse")
library(readr)
library(lubridate)
library(readxl)
library(ggiraph)
library(ggplot2)
library(dplyr)
library(RODBC)
library(DT)



shinyUI(fluidPage(

    titlePanel("PRISM Data Query"),

    sidebarLayout(
        sidebarPanel(
            selectInput("stud","Boar Stud:", choices = c('High Desert',
                                                         'MB 7081',
                                                         'MB 7082',
                                                         'MB 7092',
                                                         'MB 7093',
                                                         'MB 7094',
                                                         'MBW Cimarron',
                                                         'MBW Cyclone',
                                                         'MBW Yuma',
                                                         'Skyline Boar Stud',
                                                         'SPGNC',
                                                         'SPGVA',
                                                         'SPG9644')),
            dateInput("date1","Start Date:", value = NULL, min = '2020-01-01', max = NULL, weekstart = 1),
            dateInput("date2","End Date:", value = NULL, min = '2020-01-01', max = NULL, weekstart = 1),
            selectInput("breed","Breed:", choices = c('SPG240','SPG120','SPG110','PICL02','PICL03','DNA200','DNA400','TNLR'))
        ),

        mainPanel(
            fluidRow(column(12, DT::dataTableOutput("table"))),
            fluidRow(column(12, align='center', downloadButton("download","Download")))
            
        )
    )
))


library(ggplot2)
library(shiny)
library(plotly)
library(dplyr)
library(rsconnect)

#setwd("C:/Users/junio/Desktop/COURSERA/DATA SCIENCE/COURSE 9 - Data Products/WEEK 4/")
ruta <- file.path("Data/WHO.csv")

who = read.csv(ruta, header = TRUE)
who <- who[!is.na(who$GNI), c("Country", "Region", "LifeExpectancy", "GNI", "Population")]
who <- who %>% mutate(Population = Population*1000)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Sidebar with a slider input for number of bins
        sidebarLayout(
                sidebarPanel(

                        h2("Inputs"),
                        p("Set a Range of GNI for the Interactive Plot, it's in the first tab.", style = "font-family: 'times'; font-si16pt"),
                        sliderInput("sliderX", "Gross National Income (GNI)", min = 300, max = 90000, value = c(2300, 18000)),
                        p("Set a Range of LE for the Interactive Plot, it's in the first tab.", style = "font-family: 'times'; font-si16pt"),
                        sliderInput("sliderY", "Life Expectancy (LE)", min = 40, max = 90, value = c(64, 76)),
                        p("Select one or more regions from the list, this shows a table in the second tab.
                          You could also drop the regions that you selected.", style = "font-family: 'times'; font-si16pt"),
                        selectizeInput("selectR", "Region", choices = who[ ,"Region"], multiple = TRUE, selected = "Americas"),
                        p("Select one or more countries from the list, this shows a table in the third tab.
                          You could also drop the countries that you selected.", style = "font-family: 'times'; font-si16pt"),
                        selectizeInput("selectC", "Country", choices = who[ ,"Country"], multiple = TRUE, selected = "Peru")               
                        ),

    # Show a plot of the generated distribution
                mainPanel(
                        
                        tabsetPanel(
                        
                                type = 'tabs',
                                tabPanel("Interactive Plot", plotlyOutput("plotly1")),
                                tabPanel("Data Table by Region", DT::dataTableOutput("dtblR")),
                                tabPanel("Data Table by Country", DT::dataTableOutput("dtblC"))
                                
                                )
                        
                        )
                )

))

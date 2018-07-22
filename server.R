
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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        
        data <- reactive({
                
                        minX <- input$sliderX[1]
                        maxX <- input$sliderX[2]
                        minY <- input$sliderY[1]
                        maxY <- input$sliderY[2]
                        who[(who$GNI %in% minX:maxX) & (who$LifeExpectancy %in% minY:maxY), ]
        })
        
        output$plotly1 <- renderPlotly({
                
                m <- list(l = 50, r = 50, b = 0, t = 70, pad = 4)

                p <- plot_ly(data(), x = ~GNI, y = ~LifeExpectancy, type = "scatter", mode = "markers", hoverinfo = 'text', 
                             text = ~paste('</br> Country: ', Country, '</br> GNI: $ ', format(GNI, big.mark = ",", digits = 6), '</br> Life Expectancy: ',
                             LifeExpectancy, 'years','</br> Population: ', format(Population, big.mark = ",", digits = 11), " people"),
                             color = ~as.factor(Region), size = ~Population, height = 600) %>%
                             layout(title = 'GNI vs LE (2015)', titlefont = list(size = 30), xaxis = list(title =
                             'Gross National Income per Capita ($ per year)'), yaxis = list(title = 'Life Expectancy (Years)'),
                             legend = list(y = -0.2, orientation = 'h'), margin = m, autosize = TRUE)
                p 

        })
        
        output$dtblR <- DT::renderDataTable({
                
                dt <- who[who$Region %in% req(input$selectR),]
                DT::datatable(dt, options = list(orderClasses = TRUE))
                
        })
        
        output$dtblC <- DT::renderDataTable({
                
                dt <- who[who$Country %in% req(input$selectC), ]
                DT::datatable(dt, options = list(orderClasses = TRUE))
                
        })
        

})

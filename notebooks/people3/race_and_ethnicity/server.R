#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw bar chart and pie chart
shinyServer(function(input, output) {

    output$raceChart <- plotly::renderPlotly({
      # interactive bar chart for race variables
      p <- dav_race_only_est %>% 
        filter(race != 'total') %>% 
        ggplot(aes(x = reorder(race, -estimate), y = estimate, fill = ethnicity)) +
        geom_col(stat = 'identity') +
        labs(title = 'Race by Ethnicity', x = 'Race', y = 'Population Estimate', fill = 'Ethnicity') +
        scale_x_discrete(labels = c('White','African American','Asian American', 'Other', 'Multiracial', 'Native American', 'Pacific Islander')) +
        coord_flip()
      
      ggplotly(p)
    })
    
    output$langPie <- plotly::renderPlotly({
      # Donut chart for languages spoken at home; 
      # Highlights % who speak English and top 5 other non-English languages
      dav_lang_only_est %>% 
        slice(-1) %>% 
        filter(str_detect(language, 'Engless', negate = TRUE)) %>% 
        filter(language != 'langTotal') %>% 
        head(n = 6) %>% 
        plot_ly(labels = ~language, values = ~estimate) %>% 
        add_pie(hole = 0.5)
    })

})
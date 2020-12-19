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

  # I would LOVE to rename Hisp and nonHisp to 'Hispanic or Latinx' and 
  # 'Non-Hispanic or Latinx', respectively...but I can't figure it out...
  # So this might be as good as this plot gets
    output$raceChart <- plotly::renderPlotly({
      # interactive bar chart for race variables
      p <- dav_race_only_est %>%
        filter(race != 'total') %>%
        ggplot(aes(x = reorder(race, -estimate), y = estimate, fill = ethnicity)) +
        geom_col() +
        labs(title = 'Race by Ethnicity', x = NULL, y = 'Population Estimate', fill = 'Ethnicity') +
        scale_x_discrete(labels = c('White',
                                    'African American',
                                    'Asian American',
                                    'Other',
                                    'Multiracial',
                                    'Native American',
                                    'Pacific Islander')) +
        scale_y_continuous(labels = scales::comma) +
        scale_fill_discrete(name = 'Ethnicity') +
        coord_flip()

      ggplotly(p, tooltip = c(x = NULL, text = 'ethnicity' , y = 'estimate'))
      
      # dav_race_only_est %>% 
      #   filter(race != 'total') %>% 
      #   plot_ly(x = ~race,
      #           y = ~estimate,
      #           type = 'bar') %>% 
      #   layout(barmode = 'stack')
    })
    langLabels <- c('English', 
               'Spanish', 
               'Other Indo-European Languages', 
               'French, Haitian, Cajun',
               'Russian, Polish, and Slavic Languages',
               'German and West Germanic Languages')
    output$langPie <- plotly::renderPlotly({
      # Donut chart for languages spoken at home; 
      # Highlights % who speak English and top 5 other non-English languages
      dav_lang_only_est %>% 
        slice(-1) %>% 
        filter(str_detect(language, 'Engless', negate = TRUE)) %>% 
        filter(language != 'langTotal') %>% 
        head(n = 6) %>% 
        plot_ly(labels = langLabels, values = ~estimate) %>% 
        add_pie(hole = 0.5) %>%
        layout(title = "Top Languages Spoken At Home",  showlegend = T,
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })

})
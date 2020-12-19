#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Race and Languages Spoken"),

    # Sidebar with a select input for location of interest
    sidebarLayout(
        sidebarPanel(
            selectInput('location', 
                        'Choose a Location', 
                        choices = unique(dav_race_only_est$location)),
        ),

        # Show a plot of the generated bar chart and pie chart
        mainPanel(
            plotly::plotlyOutput('raceChart'),
            plotly::plotlyOutput('langPie')
        )
    )
))

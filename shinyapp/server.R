# All libraries are imported in global.R

# Define the Application server logic
shinyServer(function(input, output) {
    
    # Reactive Expression: Get filtered penguins when needed
    # based on input$island from ui.R
    
    filtered_dav_race_only_est <- reactive({
        dav_race_only_est %>% filter(county == input$county)
    })
    
    filtered_dav_lang_only_est <- reactive({
        dav_lang_only_est %>% filter(county == input$county)
    })
    
    # Alexa's work: Age
    # -----------------
    
    output$decadeCensus <- renderPlotly({
        decade_gg <- plot_ly(dec_Davidson, x=~labels, y=~women, type='bar', name='Female',color = I('#9C877B'))
        decade_gg <- decade_gg %>% add_trace(y=~men, name='Male',color= I('#DCC5A8'))
        decade_gg <- decade_gg %>%  layout (yaxis=list(title='Population'),
                                            xaxis=list(title='Age Group', tickangle=-45),
                                            barmode='stack')
    })
    
    output$generationCensus <- renderPlotly({
        gen_gg <- plot_ly(gen_Davidsonmf, x=~generation, y=~women_gen, type='bar', name='Female', color = I('#9C877B'))
        gen_gg <- gen_gg %>% add_trace(y=~men_gen, name='Male', color= I('#DCC5A8'))
        gen_gg <- gen_gg %>%  layout (yaxis=list(title='Population'),
                                      xaxis=list(title='Generation'),
                                      barmode='stack')
    })
    
    output$genderCensus <- renderPlotly({
        
        gender_gg <- gender_Davidson %>%
            plot_ly(labels= ~variable, values= ~estimate, marker = list(colors = c('#F6DDB6','#F0C37F')))
        
        gender_gg <- gender_gg %>%
            add_pie(hole=0.5)
        
        gender_gg <- gender_gg %>%
            layout(#title='Male and Female Population',
                   xaxis=list(showgrid=FALSE, zeroline= FALSE, showticklabels= FALSE),
                   yaxis= list(showgrid=FALSE,zeroline=FALSE,showticklabels=FALSE))
    })
    
    # Oluchi's work: Race
    # -------------------
    # I would LOVE to rename Hisp and nonHisp to 'Hispanic or Latinx' and 
    # 'Non-Hispanic or Latinx', respectively...but I can't figure it out...
    # So this might be as good as this plot gets
    output$raceCensus <- plotly::renderPlotly({
        # interactive bar chart for race variables
        p <- filtered_dav_race_only_est() %>%
            filter(race != 'total') %>%
            ggplot(aes(x = reorder(race, -estimate), y = estimate, fill = ethnicity)) +
            geom_col() +
            labs(#title = 'Race by Ethnicity', 
                 x = NULL, y = 'Population', fill = NULL) +
            # scale_x_discrete(labels = c('White',
            #                             'African American',
            #                             'Asian American',
            #                             'Other',
            #                             'Multiracial',
            #                             'Native American',
            #                             'Pacific Islander')) +
            scale_y_continuous(
                limits=c(0, 450000), 
                breaks=c(0, 50000, 100000, 150000, 200000, 250000, 300000, 350000, 400000, 450000), 
                labels=c("0", "50K", "100K", "150K", "200K", "250K", "300K", "350K", "400K", "450K")
            ) +
            #scale_y_continuous(labels = scales::comma) +
            # Rotate x-axis text labels
            theme_minimal() +
            theme(axis.text.x = element_text(angle = 45))
            #scale_fill_discrete(name = 'Ethnicity') +
            #coord_flip()
        
        ggplotly(p, tooltip = c(x = NULL, text = 'ethnicity' , y = 'estimate'))
        
        # dav_race_only_est %>% 
        #   filter(race != 'total') %>% 
        #   plot_ly(x = ~race,
        #           y = ~estimate,
        #           type = 'bar') %>% 
        #   layout(barmode = 'stack')
    })

    output$languageCensus <- plotly::renderPlotly({
        # Donut chart for languages spoken at home; 
        # Highlights % who speak English and top 5 other non-English languages
        filtered_dav_lang_only_est() %>% 
            slice(-1) %>% 
            filter(str_detect(language, 'Engless', negate = TRUE)) %>% 
            filter(language != 'langTotal') %>% 
            head(n = 6) %>% 
            plot_ly(labels = langLabels, values = ~estimate) %>% 
            add_pie(hole = 0.5) %>%
            layout(#title = "Top Languages Spoken At Home",
                   showlegend = T,
                   xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                   yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })
    
    
    
    
    
    
    
    
    
    
    
    
    
    # Reactive Expression: Get filtered penguins when needed
    # based on input$island from ui.R
    filtered_penguins <- reactive({
        penguins %>% filter(island == input$location)
    })
    
    # Generate Histogram of body mass with bins 
    # based on input$binscount from ui.R
    output$educationOutput1 <- renderPlot({
        
        filtered_penguins() %>% # Reactive: Change according to user input for input$island 
            drop_na(body_mass_g) %>%
            ggplot(aes(
                x=body_mass_g
            )) +
            geom_histogram(bins=40)
    })
    
    output$educationOutput3 <- renderPlot({
        filtered_penguins() %>% # Reactive: Change according to user input for input$island 
            ggplot(aes(
                y=sex
            )) +
            geom_bar()
    })
    
    # Generate a barchart of sex
    # based on input$binscount from ui.R
    output$ageOutput1 <- renderPlot({
        filtered_penguins() %>% # Reactive: Change according to user input for input$island 
            ggplot(aes(
                y=sex
            )) +
            geom_bar()
    })
    
    output$ageOutput2 <- renderPlot({
        filtered_penguins() %>% # Reactive: Change according to user input for input$island 
            ggplot(aes(
                y=sex
            )) +
            geom_bar()
    })
    
    output$ageOutput4 <- renderPlot({
        filtered_penguins() %>% # Reactive: Change according to user input for input$island 
            drop_na(body_mass_g) %>%
            ggplot(aes(
                x=body_mass_g
            )) +
            geom_histogram(bins=40)
    })
    
    output$ageOutput3 <- renderPlot({
        filtered_penguins() %>% # Reactive: Change according to user input for input$island 
            ggplot(aes(
                y=sex
            )) +
            geom_bar()
    })
    
    # Generate a barchart of sex
    # based on input$binscount from ui.R
    output$raceOutput1 <- renderPlot({
        filtered_penguins() %>% # Reactive: Change according to user input for input$island 
            ggplot(aes(
                y=sex
            )) +
            geom_bar()
    })
    
    output$raceOutput3 <- renderPlot({
        filtered_penguins() %>% # Reactive: Change according to user input for input$island 
            ggplot(aes(
                y=sex
            )) +
            geom_bar()
    })
    
    # Handle file uploads
    # Use browser() for debugging: temp is in input$userfileupload$datapath
    observeEvent(input$userfileupload, {
        # Assume the file is a csv file
        user_data <- read_csv(input$userfileupload$datapath)
    })
})

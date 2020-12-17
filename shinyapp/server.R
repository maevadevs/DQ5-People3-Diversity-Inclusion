# All libraries are imported in global.R

# Define the Application server logic
shinyServer(function(input, output) {
    
    # Reactive Expressions
    # --------------------
    
    filtered_dav_race_only_est <- reactive({
        dav_race_only_est %>% filter(county == input$county)
    })
    
    filtered_dav_lang_only_est <- reactive({
        dav_lang_only_est %>% filter(county == input$county)
    })
    
    filtered_edu_data <- reactive({
        data_edu_bygenderandrace_details %>% 
            filter(county == input$county) %>%
            filter(edulevel != 'total') %>%
            select(gender, edulevel, estimate) %>% 
            group_by(edulevel) %>% 
            summarise(
                male = sum(estimate[gender=="male"], na.rm = TRUE),
                female = sum(estimate[gender=="female"], na.rm = TRUE)
            ) %>%
            ungroup()
    })
    
    filtered_edu_data_by_race <- reactive({
        data_edu_bygenderandrace_details %>%
            filter(county == input$county) %>%
            filter(edulevel != 'total') %>%
            select(race, edulevel, estimate) %>%
            group_by(edulevel) %>%
            summarise(
                "African American" = sum(estimate[race=="aframer"], na.rm = TRUE),
                Asian = sum(estimate[race=="asian"], na.rm = TRUE),
                "Hawaiian/Pacific Islanders" = sum(estimate[race=="hawpac"], na.rm = TRUE),
                "Hispanic" = sum(estimate[race=="hisp"], na.rm = TRUE),
                "Native American" = sum(estimate[race=="native"], na.rm = TRUE),
                "Non-Hispanic" = sum(estimate[race=="angloexcl"], na.rm = TRUE),
                Others = sum(estimate[race=="others"], na.rm = TRUE),
                "Two or More Races" = sum(estimate[race=="twoormore"], na.rm = TRUE),
                "Whites" = sum(estimate[race=="anglo"], na.rm = TRUE),
            ) %>%
            pivot_longer(c("African American":"Whites"),
                           names_to="race",
                           values_to="estimate") %>%
            ungroup()

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
    
    # Alexa's work: Education
    # -----------------------
    
    output$educationCensus <- renderPlotly({
        # Remove the last row total
        #data_edulevels_bygender_summary_long <- data_edulevels_bygender_summary_long %>% head(-1)
        edu_data <- filtered_edu_data()
        
        education <- plot_ly(edu_data, x=~edulevel, y=~female, type='bar', name='Female', color = I('#9C877B'))
        education <- education %>% add_trace(y=~male, name='Male', color= I('#DCC5A8'))
        education <- education %>%  layout (yaxis=list(title='Population'),
                                            xaxis=list(title='Education Level'),
                                            barmode='stack')
    })
    
    # Extra Education Data
    # output$educationByRace <- plotly::renderPlotly({
    #     
    #     print(filtered_edu_data_by_race())
    #     
    #     p <- filtered_edu_data_by_race() %>%
    #         filter(race != 'total') %>%
    #         ggplot(aes(x = reorder(race, -estimate), y = estimate, fill = edulevel)) +
    #         geom_col() +
    #         labs(#title = 'Race by Ethnicity', 
    #             x = NULL, y = 'Population', fill = NULL) +
    #         # scale_x_discrete(labels = c('White',
    #         #                             'African American',
    #         #                             'Asian American',
    #         #                             'Other',
    #         #                             'Multiracial',
    #         #                             'Native American',
    #         #                             'Pacific Islander')) +
    #         # scale_y_continuous(
    #         #     limits=c(0, 450000), 
    #         #     breaks=c(0, 50000, 100000, 150000, 200000, 250000, 300000, 350000, 400000, 450000), 
    #         #     labels=c("0", "50K", "100K", "150K", "200K", "250K", "300K", "350K", "400K", "450K")
    #         # ) +
    #         #scale_y_continuous(labels = scales::comma) +
    #         # Rotate x-axis text labels
    #         theme_minimal() +
    #         theme(axis.text.x = element_text(angle = 45))
    #     #scale_fill_discrete(name = 'Ethnicity') +
    #     #coord_flip()
    #     
    #     ggplotly(p, tooltip = c(x = NULL, text = 'ethnicity' , y = 'estimate'))
    #     
    #     # dav_race_only_est %>% 
    #     #   filter(race != 'total') %>% 
    #     #   plot_ly(x = ~race,
    #     #           y = ~estimate,
    #     #           type = 'bar') %>% 
    #     #   layout(barmode = 'stack')
    # 
    #     
    # })
    
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
        
        ggplotly(p, tooltip = c(x = NULL, text = 'race' , y = 'estimate'))
        
        # dav_race_only_est %>% 
        #   filter(race != 'total') %>% 
        #   plot_ly(x = ~race,
        #           y = ~estimate,
        #           type = 'bar') %>% 
        #   layout(barmode = 'stack')
    })

    # This is throwing an error
    # -------------------------
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
    
    # Handle file uploads
    # Use browser() for debugging: temp is in input$userfileupload$datapath
    observeEvent(input$userfileupload, {
        # Assume the file is a csv file
        user_data <- read_csv(input$userfileupload$datapath)
    })
})

# All libraries are imported in global.R

# Define the Application server logic
shinyServer(function(input, output) {
    
    # Handling file uploads
    # Use browser() for debugging: temp is in input$userfileupload$datapath
    # Handling file uploads
    # Use browser() for debugging: temp is in input$userfileupload$datapath
    observeEvent(input$userfileupload, {
        # Assume the file is a xlsx file
        # Should have 3 tabs: Age, Race, Education
        user_data_age <- read_excel(input$userfileupload$datapath, sheet = "Age")
        user_data_race <- read_excel(input$userfileupload$datapath, sheet = "Race")
        user_data_edu <- read_excel(input$userfileupload$datapath, sheet = "Education")
        
        # Handle Age Transformation
        clean_user_data_age <- user_data_age %>% 
          select(-Total) %>%
          tail(-1) %>%
          rename(
            "<20"="Under 20 years",
            "20-29"="20 to 29 years",
            "30-39"="30 to 39 years",
            "40-49"="40 to 49 years",
            "50-59"="50 to 59 years",
            "60>"="60 years and over",
          ) %>%
          pivot_longer(c("<20":"60>"),
                       names_to="labels",
                       values_to="value") %>%
          pivot_wider(names_from="Sex")
        
        # Handle Race Transformation
        clean_user_data_race <- user_data_race %>% 
          select(-Total) %>%
          tail(-1) %>%
          rename(
            "white"="White alone",
            "afam"="Black or African American",
            "natv"="American Indian and Alaska Native",
            "asam"="Asian",
            "paci"="Native Hawaiian and Other Pacific Islander",
            "othr"="Some other race",
            "mixd"="Two or more races:",
            "remove0"="Two races including Some other race",
            "remove1"="Two races excluding Some other race, and three or more races"
          ) %>%
          select(-remove0, -remove1) %>%
          pivot_longer(c("white":"mixd"),
                       names_to="race",
                       values_to="estimate") %>%
          rename(ethnicity=Ethnicity)
        
        # Handle Education Transformation
        clean_user_data_edu <- user_data_edu %>%
          select(-Total) %>%
          tail(-1) %>%
          rename(
            "nohs"="No High School Diploma",
            "hs"="High school graduate (includes equivalency)",
            "somecollege"="Some college, no degree",
            "associate"="Associate's degree",
            "bachelor"="Bachelor's degree",
            "master"="Master's degree",
            "prof"="Professional school degree",
            "doctorate"="Doctorate degree",
          ) %>%
          pivot_longer(c("nohs":"doctorate"),
                       names_to="edulevel",
                       values_to="estimate") %>%
          rename(
            gender=Sex
          ) %>% 
          group_by(edulevel) %>% 
          summarise(
            male = sum(estimate[gender=="Male"], na.rm = TRUE),
            female = sum(estimate[gender=="Female"], na.rm = TRUE)
          ) %>%
          ungroup()
        
        # Handle Gender Transformation
        clean_user_data_gender <- user_data_edu %>%
            tail(-1) %>%
            select(Sex, Total) %>%
            rename(
                gender=Sex,
                estimate=Total
            )
        
        # Plot for Age
        output$decadeFile <- renderPlotly({
          decade_gg <- plot_ly(clean_user_data_age, x=~labels, y=~Female, type='bar', name='Female',color = I('#B8ABA5'))
          decade_gg <- decade_gg %>% add_trace(y=~Male, name='Male',color= I('#E8D8C5'))
          decade_gg <- decade_gg %>%  layout (yaxis=list(title='Population'),
                                              xaxis=list(title='Age Group', tickangle=-45),
                                              barmode='stack')
        })
        
        # Plot for Race
        output$raceFile <- plotly::renderPlotly({
          # interactive bar chart for race variables
          p <- clean_user_data_race %>%
            #filter(race != 'total') %>%
            ggplot(aes(x = reorder(race, -estimate), y = estimate, fill = ethnicity)) +
            geom_col() +
            scale_fill_manual(values = c('Hispanic or Latino' = '#E8D8C5',
                                         'Not Hispanic or Latino' = '#B8ABA5')) +
            labs(#title = 'Race by Ethnicity', 
              x = NULL, y = 'Population', fill = NULL) +
            # scale_x_discrete(labels = c('White',
            #                             'African American',
            #                             'Asian American',
            #                             'Other',
            #                             'Multiracial',
            #                             'Native American',
            #                             'Pacific Islander')) +
            # scale_y_continuous(
            #   limits=c(0, 450000), 
            #   breaks=c(0, 50000, 100000, 150000, 200000, 250000, 300000, 350000, 400000, 450000), 
            #   labels=c("0", "50K", "100K", "150K", "200K", "250K", "300K", "350K", "400K", "450K")
            # ) +
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
        
        # Plot for education
        output$educationFile <- renderPlotly({
          # Remove the last row total
          #data_edulevels_bygender_summary_long <- data_edulevels_bygender_summary_long %>% head(-1)

          education <- plot_ly(clean_user_data_edu, x=~edulevel, y=~female, type='bar', name='Female', color = I('#B8ABA5'))
          education <- education %>% add_trace(y=~male, name='Male', color= I('#E8D8C5'))
          education <- education %>%  layout (yaxis=list(title='Population'),
                                              xaxis=list(title='Education Level', tickangle=-45),
                                              barmode='stack')
        })
        
        # Plot for Gender
        output$genderFile <- renderPlotly({
            
            gender_gg <- clean_user_data_gender %>%
                plot_ly(labels= ~gender, values= ~estimate, marker = list(colors = c('#DBBFA5','#E8D8C5')))
            
            gender_gg <- gender_gg %>%
                add_pie(hole=0.5)
            
            gender_gg <- gender_gg %>%
                layout(#title='Male and Female Population',
                    xaxis=list(showgrid=FALSE, zeroline= FALSE, showticklabels= FALSE),
                    yaxis= list(showgrid=FALSE,zeroline=FALSE,showticklabels=FALSE))
        })
    })
    
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
                                            xaxis=list(title='Education Level', tickangle=-45),
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
            scale_fill_manual(values = c('Hisp' = '#DCC5A8',
                                          'nonHisp' = '#C2B5AE')) +
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

    # This was throwing an error
    # Error has been fixed; values for langLabels were commented out 
    # in the global script (see lines 27-32)
    # I opted to go with the ugly variable names within the data set
    # instead to ensure that they're accurate
    # -------------------------
    output$languageCensus <- plotly::renderPlotly({
        # Donut chart for languages spoken at home;
        # Highlights % who speak English and top 5 other non-English languages
        filtered_dav_lang_only_est() %>%
            slice(-1) %>%
            filter(str_detect(language, 'Engless', negate = TRUE)) %>%
            filter(language != 'langTotal') %>%
            head(n = 6) %>%
            plot_ly(labels = ~language, 
                    values = ~estimate, 
                    type = 'pie',
                    marker = list(colors = c('#E59824', '#957E76', '#333333', '#B8ABA5', '#FFD966', '#E8D8C5'))) %>%
            add_pie(hole = 0.5) %>%
            layout(#title = "Top Languages Spoken At Home",
                   showlegend = T,
                   xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                   yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })
})

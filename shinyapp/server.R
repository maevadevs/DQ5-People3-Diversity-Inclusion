# All libraries are imported in global.R

# Define the Application server logic
shinyServer(function(input, output) {
    
    # Reactive Expression: Get filtered penguins when needed
    # based on input$island from ui.R
    filtered_penguins <- reactive({
        penguins %>% filter(island == input$location)
    })
    
    # Generate Histogram of body mass with bins 
    # based on input$binscount from ui.R
    output$educationOutput <- renderPlot({
        filtered_penguins() %>% # Reactive: Change according to user input for input$island 
            drop_na(body_mass_g) %>%
            ggplot(aes(
                x=body_mass_g
            )) +
            geom_histogram(bins=40)
    })
    
    # Generate a barchart of sex
    # based on input$binscount from ui.R
    output$ageOutput <- renderPlot({
        filtered_penguins() %>% # Reactive: Change according to user input for input$island 
            ggplot(aes(
                y=sex
            )) +
            geom_bar()
    })
    
    # Generate a barchart of sex
    # based on input$binscount from ui.R
    output$raceOutput <- renderPlot({
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

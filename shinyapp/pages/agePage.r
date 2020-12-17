# This is the Age page and all of its contents
agePage <- tabPanel("Age",
                    #titlePanel("This can be use if needed"), 
                    # A column of width 3 to contain the sidebar
                    column(class="customWellCol", 
                           width=3, 
                           tags$div(class="customWell", 
                                    # Select Input for location
                                    selectInput('age_location', 
                                                'Choose a location for Age', 
                                                location_choices),
                                    # File input for user to upload their own file
                                    #fileInput("age_userfileupload", "Upload Comparison Data"),
                                    # Download Section: Label and Button
                                    radioButtons("age_downloadReportFormat", 
                                                 "Download Age Report",
                                                 choices=list("Excel", "CSV", "PDF")),
                                    actionButton("age_downloadReportButton", "Download Report")
                           ),
                    ),
                    # A column of width 9 to contain the plots
                    # Or customize this with whatever fits
                    column(width=9, 
                           plotOutput('ageOutput'))
)
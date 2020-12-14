# This is the Education page and all of its contents
educationPage <- tabPanel("Education",
                    #titlePanel("This can be use if needed"), 
                    # A column of width 3 to contain the sidebar
                    column(class="customWellCol", 
                           width=3, 
                           tags$div(class="customWell", 
                                    # Select Input for location
                                    selectInput('edu_location', 
                                                'Choose a location', 
                                                location_choices),
                                    # File input for user to upload their own file
                                    #fileInput("edu_userfileupload", "Upload Comparison Data"),
                                    # Download Section: Label and Button
                                    radioButtons("edu_downloadReportFormat", 
                                                 "Download Report",
                                                 choices=list("Excel", "CSV", "PDF")),
                                    actionButton("edu_downloadReportButton", "Download Report")
                           ),
                    ),
                    # A column of width 9 to contain the plots
                    # Or customize this with whatever fits
                    column(width=9, 
                           plotOutput('educationOutput'))
)
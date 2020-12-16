# This is the Analysis page and all of its contents
# This is the Analysis page and all of its contents
analysisPage <- tabPanel("Analysis",
                         #titlePanel("This can be use if needed"),
                         #A column of width 3 to contain the sidebar
                         column(class="customWellCol",
                                width=3,
                                tags$div(class="customWell",
                                         # Select Input for location
                                         selectInput('location',
                                                     'Choose a location',
                                                     location_choices),
                                         # File input for user to upload their own file
                                         fileInput("userfileupload", 
                                                   label="Upload Comparison Data",
                                                   #width=400,
                                                   #buttonLabel="Choose File",
                                                   placeholder=".xls, .xlsx",
                                                   accept=c(".xls", ".xlsx"), # Only accept these file types, still need validation in server
                                                   multiple=FALSE),
                                         # Download Section: Label and Button
                                         radioButtons("downloadReportFormat",
                                                      "Download Report",
                                                      choices=list("CSV", "PDF")),
                                         actionButton("downloadReportButton", "Download Report")
                                ),
                         ),
                         #A column of width 9 to contain the plots
                         #Or customize this with whatever fits
                         column(width=9,
                                HTML("<p><strong>The default baseline data come from the Census.org American Community Survey 1-Year Estimates (ACS1). To compare with additional data, upload your data file from the sidebar menu.</strong></p>"),
                                tabsetPanel(type="tabs",
                                            tabPanel("Age",
                                                     plotOutput("ageOutput")),
                                            tabPanel("Education",
                                                     plotOutput("educationOutput")),
                                            tabPanel("Race",
                                                     plotOutput("raceOutput"))
                                )
                         )
                         
                         # sidebarLayout(
                         #   sidebarPanel(
                         #     # Select Input for location
                         #     selectInput('location', 
                         #                 'Choose a location', 
                         #                 location_choices),
                         #     # File input for user to upload their own file
                         #     #fileInput("age_userfileupload", "Upload Comparison Data"),
                         #     # Download Section: Label and Button
                         #     radioButtons("downloadReportFormat", 
                         #                  "Download Report",
                         #                  choices=list("Excel", "CSV", "PDF")),
                         #     actionButton("downloadReportButton", "Download Report")
                         #   ),
                         #   mainPanel(
                         #     tabsetPanel(type="tabs",
                         #                 tabPanel("Age", 
                         #                          plotOutput("ageOutput")),
                         #                 tabPanel("Education", 
                         #                          plotOutput("educationOutput")),
                         #                 tabPanel("Race", 
                         #                          plotOutput("raceOutput"))
                         #     )
                         #   )
                         # )
)
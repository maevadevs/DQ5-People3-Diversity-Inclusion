# This is the Upload Data page and all of its contents
uploadDataPage <- tabPanel("Upload Data",
                           # File input for user to upload their own file
                           column(width=8, 
                                  align="center", 
                                  offset = 2,
                                  tags$div(class="uploader",
                                    tags$p("Upload comparison data to compare with the existing data from census.gov"),
                                    tags$p(tags$strong("Accepted file format:"), ".xlsx"),
                                    fileInput("userfileupload", ""),
                                    #tags$style(type="text/css", "#string { height: 50px; width: 100%; text-align:center; font-size: 30px;}")
                                  )
                            )
                           #tags$div(class="uploader",
                            #        fileInput("userfileupload", "Upload Comparison Data")
                             #       )
)






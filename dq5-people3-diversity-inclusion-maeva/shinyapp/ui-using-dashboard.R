# All libraries are imported in global.R

# A Custom dashboard header with 3 dropdown menus
customHeader <- dashboardHeader(
    title = "People3 Dashboard", # Title will be replaced by logo
    # Dropdown menu for messages
    dropdownMenu(type = "messages", badgeStatus = "success",
                 messageItem("Support Team",
                             "This is the content of a message.",
                             time = "5 mins"
                 ),
                 messageItem("Support Team",
                             "This is the content of another message.",
                             time = "2 hours"
                 ),
                 messageItem("New User",
                             "Can I get some help?",
                             time = "Today"
                 )
    ),
    
    # Dropdown menu for notifications
    dropdownMenu(type = "notifications", badgeStatus = "warning",
                 notificationItem(icon = icon("users"), status = "info",
                                  "5 new members joined today"
                 ),
                 notificationItem(icon = icon("warning"), status = "danger",
                                  "Resource usage near limit."
                 ),
                 notificationItem(icon = icon("shopping-cart", lib = "glyphicon"),
                                  status = "success", "25 sales made"
                 ),
                 notificationItem(icon = icon("user", lib = "glyphicon"),
                                  status = "danger", "You changed your username"
                 )
    ),
    
    # Dropdown menu for tasks, with progress bar
    dropdownMenu(type = "tasks", badgeStatus = "danger",
                 taskItem(value = 20, color = "aqua",
                          "Refactor code"
                 ),
                 taskItem(value = 40, color = "green",
                          "Design new layout"
                 ),
                 taskItem(value = 60, color = "yellow",
                          "Another task"
                 ),
                 taskItem(value = 80, color = "red",
                          "Write documentation"
                 )
    )
)

# Replacing title with logo
customHeader$children[[2]]$children <- tags$a(href='https://people3.co',
                                              tags$img(src='img/people3logo.png',
                                                       height='30',
                                                       width='140'
                                                       ))

# Define the Application UI: Using Dashboard Layout
shinyUI(dashboardPage(
    
    skin="black",
    
    # Application Header and Navigation Bar
    customHeader,
    
    # Sidebar Area---------------------------------------------------------
    dashboardSidebar(
        
        # STYLING Option 1: We can use the skin argument
        # But this is very limited
        #skin = 'red',
        
        # STYLING OPTION 2: Link a CSS file to the app
        tags$head(
            tags$link(
                type="text/css",
                rel="stylesheet",
                href="styles.css"
            )
        ),
        
        # An example of a simple paragraph text
        tags$p("This is a simple text example"),
        
        # Slider input for number of bins
        sliderInput("binscount",
                    "Number of bins:",
                    min = 1,
                    max = 50,
                    value = 30),
        
        # Select Input for the user to choose an island
        selectInput("island", 
                    "Select an island", 
                    islands_choices),
        
        # File input for user to upload a file
        fileInput("userfileupload", 
                  "Upload data file")
    ),

    # Main Area------------------------------------------------------------
    dashboardBody(
        
        # An example of a simple paragraph text
        tags$p(HTML("This is a <strong>simple text example</strong>")),
        
        # Start of the fluid body
        fluidRow(
            # Total width = 12 Units / 2 columns --> width=6
            column(width=6, 
                   box(width=NULL,
                       title="Penguins Body Mass",
                       plotOutput("distPlot_body_mass"))),
            
            column(width=6, 
                   box(width=NULL,
                       title="Penguins Gender",
                       plotOutput("barchart_gender")))
        )
    )
))

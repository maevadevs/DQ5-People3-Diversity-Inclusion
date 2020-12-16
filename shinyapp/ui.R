# All libraries are imported in global.R

# Source codes that defines the Home Page
# homePage variable is defined here
source("pages/homePage.r") # -> homePage

# Source codes that defines the Analysis Page
# analysisPage variable
source("pages/analysisPage.r") # -> analysisPage

# Source codes that defines the Age Page
# agePage variable
#source("pages/agePage.r") # -> agePage

# Source codes that defines the Education Page
# educationPage variable
#source("pages/educationPage.r") # -> educationPage

# Source codes that defines the Race and Ethnicity Page
# racePage variable
#source("pages/racePage.r") # -> racePage

# Source codes that defines the Upload Data Page
# uploadDataPage variable
#source("pages/uploadDataPage.r") # -> uploadDataPage

# Source codes that defines the DataSources Page
# dataSourcesPage variable
source("pages/creditsPage.r") # -> creditsPage


# Putting the UI Together
shinyUI(
  # Using Navbar with custom CSS
  navbarPage(title=tags$a(href='https://people3.co',
                          tags$img(src='img/people3logo.png', height='30', width='140')),
             theme="styles.css", # Shiny will look in the www folder for this
             homePage,
             #agePage,
             #educationPage,
             #racePage,
             analysisPage,
             #uploadDataPage,
             creditsPage)
)
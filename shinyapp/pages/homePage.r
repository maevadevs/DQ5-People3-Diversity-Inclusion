# This is the Home page and all of its contents
homePage <- tabPanel("Home",
                     tags$div(class="titlePanel",
                              tags$h1(class="title",
                                      tags$span(class="representation", "Representation"),
                                      "&",
                                      tags$span(class="inclusion","Inclusion"),
                                      "Opportunity Dashboard"
                              )
                     ),
                     br(),
                     br(),
                     tags$div(class="bodyTextContainer",
                              tags$p("Insert a brief description of the app here, letting people know how it works and what to expect from it. Also let people know what information/file formats they will need to take full advantage of the app."),
                              br(),
                              tags$p("For more information about People3, please visit ",
                                     tags$a("our site", href="https://people3.co")
                              )
                     )
)
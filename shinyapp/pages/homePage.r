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
                              HTML("<p>The Representation & Inclusion Opportunity (R.I.O.) Dashboard equips you with census data to navigate diversity issues within organizations, and between organizations and the people they serve.</p>"),
                              tags$h4("Pinpoint opportunities for outreach"),
                              HTML("<p>Click on <em>Analyze</em> in the navigation bar at the top of the page to obtain demographic information for a specific location of interest. Compare the demographics of an organization's clientele with those of the people in their county."),
                              tags$h4("Identify areas for improvement"),
                              HTML("<p>Upload workforce demographic information from an organization. Compare these data to the census data available for people in a specified county.</p>"),
                              br(),
                              tags$p("For more information about People3, visit ",
                                     tags$a("people3.co", href="https://people3.co")
                              )
                     )
)
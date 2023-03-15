#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(sf)
library(ggplot2)
library(tmap)
library(tmaptools)
library(leaflet)
library(dplyr)

constituencies <-
  readr::read_csv("honours  - 2019.csv", col_select = 2)


scotland <- st_read("westminster_const_region.shp")
data19 <- readr::read_csv("honours  - 2019.csv")
map19 <- inner_join(scotland, data19)
rm(data19)
data17 <- readr::read_csv("honours  - 2017.csv")
map17 <- inner_join(scotland, data17)
rm(data17)
data15 <- readr::read_csv("honours  - 2015.csv")
map15 <- inner_join(scotland, data15)
rm(data15)
rm(scotland)

map <- map19

# Define UI for application that draws a histogram
ui <- fluidPage(navbarPage(
  "Scottish Election Results",
  tabPanel(
    "Information",
    verticalLayout(
      h2("What is the purpose of this site"),
      (
        "This website is a university project to determine if there is a correlation between data visualisation and influencing electoral turnout in Scotland"
      ),
      h2("How to use this website"),
      (
        "There are three different general elections that you can choose to view, 2019, 2017 and 2015 which are all viewable from the results tab (found at the top of the page). From there you are shown a map of Scotland, colour coded by what each constituency voted for. You can hover your mouse, and click or tap your screen on a constituency to reveal more information. Below this map is a table of election data. The side menu on the left of your screen gives you the option to view each scottish constituency individually for each election or change election year. Clicking this will update the map and table to highlight what constituency you have selected. This can be changed back at anytime by selecting Scotland from the menu. Information may take a moment to load, so please be patient while the website fetches the information."
      ),
      h2("Register to vote"),
      ("If you have not done so already, you can register to vote at"),
      a(
        href = "https://www.gov.uk/register-to-vote",
        "https://www.gov.uk/register-to-vote",
        target = "_blank"
      ),
      h2("Manifestos and party information"),
      (
        "Listed below in alphabetical order are the 4 parties that had a seat in the last 3 general elections in Scotland. Here you can find information on them and thier manifestos. There are more parties to vote for other than these which can be found at"
      ),
      p(
        a(
          href = "https://www.parliament.uk/about/mps-and-lords/members/parties/",
          "https://www.parliament.uk/about/mps-and-lords/members/parties/",
          target = "_blank"
        )
      ),
      p(strong("The Conservative Party:")),
      a(
        href = "https://www.scottishconservatives.com",
        "https://www.scottishconservatives.com",
        target = "_blank"
      ),
      ("Policies and manifestos:"),
      p(
        a(
          href = "https://www.scottishconservatives.com/policy-area/",
          "https://www.scottishconservatives.com/policy-area/",
          target = "_blank"
        )
      ),
      p(strong("The Labour Party:")),
      a(
        href = "https://scottishlabour.org.uk",
        "https://scottishlabour.org.uk",
        target = "_blank"
      ),
      ("Policies and manifestos:"),
      p(
        a(
          href = "https://scottishlabour.org.uk/where-we-stand/",
          "https://scottishlabour.org.uk/where-we-stand/",
          target = "_blank"
        )
      ),
      p(strong("The Liberal Democrats:")),
      a(
        href = "https://www.scotlibdems.org.uk",
        "https://www.scotlibdems.org.uk",
        target = "_blank"
      ),
      ("Policies and manifestos:"),
      p(
        a(
          href = "https://www.scotlibdems.org.uk/about-us/our-policy",
          "https://www.scotlibdems.org.uk/about-us/our-policy",
          target = "_blank"
        )
      ),
      p(strong("The Scottish National Party:")),
      a(href = "https://www.snp.org", "https://www.snp.org", target =
          "_blank"),
      ("Policies and manifestos:"),
      a(
        href = "https://www.snp.org/policies/",
        "https://www.snp.org/policies/",
        target = "_blank"
      ),
            ("Policies and manifestos:"),
      a(
        href = "https://www.snp.org/policies/",
        "https://www.snp.org/policies/",
        target = "_blank"
      ),
      h2("Acknowledgements"),
      (
        "Use of official election data taken was from the House of Commons library under the Open parliament licence, for further details please visit:"
      ),
      p(
        a(
          href = "https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence/",
          "https://www.parliament.uk/site-information/copyright-parliament/open-parliament-licence/",
          target = "_blank"
        )
      ),
      ("Use of Westminster election boundaries have been taken from Ordanance Survey OpenData under the Open Governemnt Licence, for further details, please visit:"),
      a(
        href = "https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/",
        "https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/",
        target = "_blank"
      ),
    )
  ),
  tabPanel("Results",
           sidebarLayout(
             sidebarPanel(
               radioButtons(
                 "year",
                 "General election year:",
                 c(
                   "2019" = "2019",
                   "2017" = "2017",
                   "2015" = "2015"
                 )
               ),
               selectInput("var", "Select a Constituency", c("Scotland", constituencies))
             ),
             mainPanel(tmapOutput("map"), tableOutput("table"))
           ))
  
))

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  filterConst <- reactive({
    if (input$year == "2019") {
      map <- map19 %>%
        map19[ - c(2:16,25), ]
    }
    if (input$year == "2017") {
      map <- map17 %>%
        map19[ - c(2:16,25), ]
    }
    if (input$year == "2015") {
      map <- map15 %>%
        map19[ - c(2:16,25), ]
    }
    if (input$var == "Scotland") {
      map
    } else{
      map %>% filter(NAME == input$var)
    }
  })
  output$map <- renderTmap({
    tm_shape(filterConst()) +
      tm_polygons(
        "first_party",
        title = "Results",
        palette = c(
          "Conservative" = "deepskyblue",
          "Labour" = "red",
          "Liberal Democrat" = "orange",
          "SNP" = "yellow"
        ),
        popup.vars = c("Winner:" = "first_party", "MP" = "mp"),
        zindex = 401
      ) +
      tm_layout(frame = FALSE) +
      tmap_mode("view")
  })
  
  output$table <- renderTable({
    filterConst() %>%
      st_drop_geometry() %>%
      rename("Constituency" = "NAME",
             "MP" = "mp",
             "Result" = "result",
             "Winner " = "first_party",
             "Second Party" = "second_party",
             "Electorate" = "electorate",
             "Valid votes" = "valid_votes",
             "Invalid Votes" = "invalid_votes",
             "Majority" = "majority",)
      
  })
  

}
  gc()
# Run the application
shinyApp(ui = ui, server = server)

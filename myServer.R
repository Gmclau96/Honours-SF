myServer <- function(input, output, session) {
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
  
  filterConst <- reactive({
    if (input$year == "2019") {
      map <- map19 %>%
        map19[-c(2:16, 25),]
    }
    if (input$year == "2017") {
      map <- map17 %>%
        map19[-c(2:16, 25),]
    }
    if (input$year == "2015") {
      map <- map15 %>%
        map19[-c(2:16, 25),]
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
      rename(
        "Constituency" = "NAME",
        "MP" = "mp",
        "Result" = "result",
        "Winner " = "first_party",
        "Second Party" = "second_party",
        "Electorate" = "electorate",
        "Valid votes" = "valid_votes",
        "Invalid Votes" = "invalid_votes",
        "Majority" = "majority",
      )
  })
}
gc()
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(sf)
library(tmap)
library(dplyr)

# Run the application
source('myUI.R')
source('myServer.R')

shinyApp(ui = myUI,
         server = myServer)
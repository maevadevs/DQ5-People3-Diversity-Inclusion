# This file is run only once at the start of the app

# Import all needed libraries
library(dplyr)
library(tidyverse)
library(shiny)
library(shinydashboard)

# Import all needed data files
penguins <- read_csv("data/test-data-penguins.csv")

# Static list of islands from the dataset
location_choices <- penguins$island %>% unique %>% sort
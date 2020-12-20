# This file is run only once at the start of the app

# Import all needed libraries
library(dplyr)
library(tidyverse)
library(shiny)
library(shinydashboard)
library(tidycensus)
library(plotly)
library(janitor)
library(readxl)
library(ggplot2)

# install rsconnect
#install.packages('rsconnect')

# Import all needed data files
# Age and Gender
dec_Davidson <- read_csv("data/dq5decades_Davidson_mf.csv")
gender_Davidson <- read_csv("data/dq5gender_Davidson.csv")
gen_Davidsonmf <- read_csv("data/dq5generations_Davidson_mf.csv")
# Education
data_edulevels_bygender_summary_long <- read_csv("data/data_edulevels_bygender_summary_long.csv")
data_edu_bygenderandrace_details <- read_csv("data/data_edu_bygenderandrace_details.csv")
# Race/Ethnicity
dav_lang_only_est <- read_csv("data/tn_lang_only_est.csv")
dav_race_only_est <- read_csv("data/tn_race_only_est.csv") 
#test_xslx_file <- read_excel("data/Example_Profile.xlsx")

# Data for Oluchi's parts
#langLabels <- c('English',
#                'Spanish',
#                'Other Indo-European Languages',
#                'French, Haitian, Cajun',
#                'Russian, Polish, and Slavic Languages',
#                'German and West Germanic Languages')

# This is for test only
#penguins <- read_csv("data/test-data-penguins.csv")

# Static list of county from the dataset
county_choices <- c("Davidson County", "Hamilton County", "Knox County", "Montgomery County", "Shelby County", "Williamson County")
# county_choices <- dav_lang_only_est$county %>% unique %>% sort
# county_choices <- data_edu_bygenderandrace_details$county %>% unique %>% sort
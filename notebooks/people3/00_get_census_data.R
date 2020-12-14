# install tidycensus package
# install.packages("tidycensus")

# load tidycensus package
library(tidycensus)
library(tidyverse)
library(dplyr)

source('./helper-function.R')                   # copy and paste whatever is inside of helper function file to this spot
envfile <- "./.env"                             # env file is located here (where path is specified)
api_key <- get_key(envfile, "census_api_key")   # function imported from helper-function.R

# Set census API key with census_api_key()
census_api_key(api_key, install = TRUE)

# Reload environment so I can use the key without restarting R (first time only)
readRenviron("~/.Renviron")

# Check environment
Sys.getenv("CENSUS_API_KEY")

# Examine variables in 2019 1-year ACS data set
v19 <- load_variables(2019, "acs1", cache = TRUE)
View(v19)

# Choose and rename variables of interest
pop_vars <- c(total_pop = "B01001_001")
# B030002 is our race/ethnicity variable of choice for all data sets
# B03002_012 represents all Hispanic or Latinx respondents, regardless of the
# Race that they selected
race_vars <- c(nonHisp_total = "B03002_002",
               Hisp_total = "B03002_012",
               nonHisp_natv = "B03002_005",
               Hisp_natv = "B03002_015",    
               nonHisp_paci = "B03002_007",
               Hisp_paci = "B03002_017",    
               nonHisp_afam = "B03002_004",
               Hisp_afam = "B03002_014",
               Hisp_allRaces = "B03002_012",
               nonHisp_asam = "B03002_006",
               Hisp_asam = "B03002_016",
               nonHisp_white = "B03002_003",
               Hisp_white = "B03002_013",
               nonHisp_mixd = "B03002_009",
               Hisp_mixd = "B03002_019",
               nonHisp_othr = "B03002_008",
               Hisp_othr = "B03002_018"
)
# C160001 is our language variable of choice for all data sets
# Using this set of variables, use mutate to create a column that
# Orders their values in descending order. From there, use head()
# To return top 5 or 10 values for each location
lang_vars <- c(langTotal = "C16001_001", 
               english = "C16001_002",
               spanish = "C16001_003",
               spEngless = "C16001_005",
               frHaitcaj = "C16001_006",
               frEngless = "C16001_008",
               germanic = "C16001_009",
               gerEngless = "C16001_011",
               rusPolslav = "C16001_012",
               rusEngless = "C16001_014",
               othrIndoeuro = "C16001_015",
               indeuroEngless = "C16001_017",
               korean = "C16001_018",
               korEngless = "C16001_020",
               chinese = "C16001_021",
               chEngless = "C16001_023",
               vietnamese = "C16001_024",
               vietEngless = "C16001_026",
               tagalog = "C16001_027",
               tgEngless = "C16001_029",
               othrPaci = "C16001_030",
               paciEngless = "C16001_032",
               arabic = "C16001_033",
               arEngless = "C16001_035",
               othrUnspec = "C16001_036",
               unspecEngless = "C16001_038"
)

#sex_vars <- c(male = 'B01001_002',
#              female = 'B01001_026')

#age_cat_vars <- c(genz_m = c('B01001_007','B01001_008','B01001_009','B01001_010'),
#              genz_f = c('B01001_031', 'B01001_032','B01001_033','B01001_034'),
#              millen_m = c('B01001_011','B01001_012','B01001_013'),
#              millen_f = c('B01001_035','B01001_036','B01001_037'),
#              genx_m = c('B01001_014','B01001_015','B01001_016'),
#              genx_f = c('B01001_038','B01001_039','B01001_040'),
#              boomer_m = c('B01001_017','B01001_018','B01001_019','B01001_020','B01001_021','B01001_022'),
#              boomer_f = c('B01001_041','B01001_042','B01001_043','B01001_044','B01001_045','B01001_046'),
#              silent_m = c('B01001_023','B01001_024','B01001_025'),
#              silent_f = c('B01001_047','B01001_048','B01001_049')
#)

# combine all variable categories into one list
my_vars <- c(pop_vars, race_vars, lang_vars)

# Pull ACS 2019 1-year data for all counties in TN; specify Davidson+ counties after
tn_race_lang_data <- get_acs(
  geography = "county",
  year = 2019,
  survey = "acs1",
  state = "TN",
  variables = my_vars
  #output = "wide"
)

dav_county_race_lang <- tn_race_lang_data %>%
  filter(NAME == 'Davidson County, Tennessee')

# TN and Davidson County (below) data frames for race data only
tn_race_only_data <- get_acs(
  geography = "county",
  year = 2019,
  survey = "acs1",
  state = "TN",
  variables = c(pop_vars, race_vars)
  #output = "wide"
)

dav_county_race_only <- tn_race_only_data %>%
  filter(NAME == 'Davidson County, Tennessee')

# TN and Davidson County (below) data frames for lang data only
tn_lang_only_data <- get_acs(
  geography = "county",
  year = 2019,
  survey = "acs1",
  state = "TN",
  variables = c(pop_vars, lang_vars)
  #output = "wide"
)

dav_county_lang_only <- tn_lang_only_data %>%
  filter(NAME == 'Davidson County, Tennessee')
library(tidyverse)
library(dplyr)
library(plotly)
library(stringr)

# Drop the MOE column since we don't need it
# Create a new data set in case you do need MOE later
dav_race_lang_est <- dav_county_race_lang %>% 
  select(-moe)
dav_race_only_est <- dav_county_race_only %>% 
  select(-moe)
dav_lang_only_est <- dav_county_lang_only %>% 
  select(-moe)

# Rename variable columns
tn_lang_only_data <- tn_lang_only_data %>% 
  rename(language = variable,
         geoid = GEOID,
         location = NAME)
dav_lang_only_est <- dav_lang_only_est %>% 
  rename(language = variable,
         geoid = GEOID,
         location = NAME)
tn_race_only_data <- tn_race_only_data %>% 
  rename(race = variable,
         geoid = GEOID,
         location = NAME)
dav_race_only_est <- dav_race_only_est %>% 
  rename(race = variable,
         geoid = GEOID,
         location = NAME)

# Separate hisp and nonHisp race variables so that ethnicity becomes its own column
ethnic_groups <- c('Hisp', 'nonHisp')
race_groups <- c('natv', 'paci', 'afam', 'asam', 'white', 'mixd', 'othr', 'total')
dav_race_only_est <- dav_race_only_est %>% 
  group_by(ethnicity = str_extract(race, paste(ethnic_groups, collapse = '|'))) %>%
  ungroup()
dav_race_only_est <- dav_race_only_est %>%
  slice(-1) %>% 
  group_by(race = str_extract(race, paste(race_groups, collapse = '|'))) %>%
  ungroup()

# Pivot the data table to facilitate analysis
dav_race_analysis <- dav_race_only_est %>% 
  group_by(ethnicity) %>% 
  pivot_wider(names_from = race, values_from = estimate) %>% 
  ungroup()

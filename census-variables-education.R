# Imports
# -------

library(tidyverse)
library(dplyr)
library(tidycensus)
library(janitor)

# Setups and variables
# --------------------

envfile <- "./.env" # Contains all secrets
source("./helper-functions.R") # Collection of helper functions
api_key <- get_key(envfile, "census_api_key") # Get the API key from .env using helper function
census_api_key(api_key, install=TRUE, overwrite=TRUE) # Set API Key for Tidy Census, overwrite if needed
readRenviron("~/.Renviron") # Restart R environment after overwriting API key
csv_dest <- "./data/"

# Education Variables in ACS1
# ---------------------------

v19 <- load_variables(2019, "acs1", cache=TRUE) # v19 is the most recent ACS1
# v19 %>% View

# For Education, we want to look at "Sex by Educational Attainment": B15002
# Note: These data are limited only for people over 25 years old
# This one contain education level in general
edulevels_bygender <- c(all_total="B15002_001",
                        male_total="B15002_002",
                        male_noschool="B15002_003",
                        male_hsorequi="B15002_011",
                        male_somecollege="B15002_013", # Maybe add B15002_012?
                        male_associate="B15002_014",
                        male_bachelor="B15002_015",
                        male_master="B15002_016",
                        male_profschool="B15002_017",
                        male_doctor="B15002_018",
                        female_total="B15002_019",
                        female_noschool="B15002_020",
                        female_hsorequi="B15002_028",
                        female_somecollege="B15002_030", # Maybe add B15002_029?
                        female_associate="B15002_031",
                        female_bachelor="B15002_032",
                        female_master="B15002_033",
                        female_profschool="B15002_034",
                        female_doctor="B15002_035"
                        )

# These ones contain education level by race
# Whites
edulevels_anglo <- c(all_total_anglo="B15002A_001",
                       male_total_anglo="B15002A_002",
                       # male_noschool="", # Does not exist in this dimension
                       male_hs_anglo="B15002A_005",
                       male_somecollege_anglo="B15002A_007",
                       male_associate_anglo="B15002A_008",
                       male_bachelor_anglo="B15002A_009",
                       # male_master="", # Does not exist in this dimension
                       male_gradprof_anglo="B15002A_010",
                       # male_doctor="", # Does not exist in this dimension
                       female_total_anglo="B15002A_011",
                       # female_noschool="", # Does not exist in this dimension
                       female_hs_anglo="B15002A_014",
                       female_somecollege_anglo="B15002A_016",
                       female_associate_anglo="B15002A_017",
                       female_bachelor_anglo="B15002A_018",
                       # female_master="", # Does not exist in this dimension
                       female_gradprof_anglo="B15002A_019"
                       # female_doctor="" # Does not exist in this dimension
                       )

# African American
edulevels_aframer <- c(all_total_aframer="B15002B_001",
                        male_total_aframer="B15002B_002",
                        # male_noschool="", # Does not exist in this dimension
                        male_hs_aframer="B15002B_005",
                        male_somecollege_aframer="B15002B_007",
                        male_associate_aframer="B15002B_008",
                        male_bachelor_aframer="B15002B_009",
                        # male_master="", # Does not exist in this dimension
                        male_gradprof_aframer="B15002B_010",
                        # male_doctor="", # Does not exist in this dimension
                        female_total_aframer="B15002B_011",
                        # female_noschool="", # Does not exist in this dimension
                        female_hs_aframer="B15002B_014",
                        female_somecollege_aframer="B15002B_016",
                        female_associate_aframer="B15002B_017",
                        female_bachelor_aframer="B15002B_018",
                        # female_master="", # Does not exist in this dimension
                        female_gradprof_aframer="B15002B_019"
                        # female_doctor="" # Does not exist in this dimension
                        )

# Native American
edulevels_native <- c(all_total_native="B15002C_001",
                       male_total_native="B15002C_002",
                       # male_noschool="", # Does not exist in this dimension
                       male_hs_native="B15002C_005",
                       male_somecollege_native="B15002C_007",
                       male_associate_native="B15002C_008",
                       male_bachelor_native="B15002C_009",
                       # male_master="", # Does not exist in this dimension
                       male_gradprof_native="B15002C_010",
                       # male_doctor="", # Does not exist in this dimension
                       female_total_native="B15002C_011",
                       # female_noschool="", # Does not exist in this dimension
                       female_hs_native="B15002C_014",
                       female_somecollege_native="B15002C_016",
                       female_associate_native="B15002C_017",
                       female_bachelor_native="B15002C_018",
                       # female_master="", # Does not exist in this dimension
                       female_gradprof_native="B15002C_019"
                       # female_doctor="" # Does not exist in this dimension
                       )

# Asian
edulevels_asian <- c(all_total_asian="B15002D_001",
                      male_total_asian="B15002D_002",
                      # male_noschool="", # Does not exist in this dimension
                      male_hs_asian="B15002D_005",
                      male_somecollege_asian="B15002D_007",
                      male_associate_asian="B15002D_008",
                      male_bachelor_asian="B15002D_009",
                      # male_master="", # Does not exist in this dimension
                      male_gradprof_asian="B15002D_010",
                      # male_doctor="", # Does not exist in this dimension
                      female_total_asian="B15002D_011",
                      # female_noschool="", # Does not exist in this dimension
                      female_hs_asian="B15002D_014",
                      female_somecollege_asian="B15002D_016",
                      female_associate_asian="B15002D_017",
                      female_bachelor_asian="B15002D_018",
                      # female_master="", # Does not exist in this dimension
                      female_gradprof_asian="B15002D_019"
                      # female_doctor="" # Does not exist in this dimension
                      )

# Hawaiian/Pacific Islanders
edulevels_hawpac <- c(all_total_hawpac="B15002E_001",
                        male_total_hawpac="B15002E_002",
                        # male_noschool="", # Does not exist in this dimension
                        male_hs_hawpac="B15002E_005",
                        male_somecollege_hawpac="B15002E_007",
                        male_associate_hawpac="B15002E_008",
                        male_bachelor_hawpac="B15002E_009",
                        # male_master="", # Does not exist in this dimension
                        male_gradprof_hawpac="B15002E_010",
                        # male_doctor="", # Does not exist in this dimension
                        female_total_hawpac="B15002E_011",
                        # female_noschool="", # Does not exist in this dimension
                        female_hs_hawpac="B15002E_014",
                        female_somecollege_hawpac="B15002E_016",
                        female_associate_hawpac="B15002E_017",
                        female_bachelor_hawpac="B15002E_018",
                        # female_master="", # Does not exist in this dimension
                        female_gradprof_hawpac="B15002E_019"
                        # female_doctor="" # Does not exist in this dimension
                        )

# Other Races
edulevels_others <- c(all_total_others="B15002F_001",
                       male_total_others="B15002F_002",
                       # male_noschool="", # Does not exist in this dimension
                       male_hs_others="B15002F_005",
                       male_somecollege_others="B15002F_007",
                       male_associate_others="B15002F_008",
                       male_bachelor_others="B15002F_009",
                       # male_master="", # Does not exist in this dimension
                       male_gradprof_others="B15002F_010",
                       # male_doctor="", # Does not exist in this dimension
                       female_total_others="B15002F_011",
                       # female_noschool="", # Does not exist in this dimension
                       female_hs_others="B15002F_014",
                       female_somecollege_others="B15002F_016",
                       female_associate_others="B15002F_017",
                       female_bachelor_others="B15002F_018",
                       # female_master="", # Does not exist in this dimension
                       female_gradprof_others="B15002F_019"
                       # female_doctor="" # Does not exist in this dimension
                       )

# Two or More Races
edulevels_twoormore <- c(all_total_twoormore="B15002G_001",
                         male_total_twoormore="B15002G_002",
                         # male_noschool="", # Does not exist in this dimension
                         male_hs_twoormore="B15002G_005",
                         male_somecollege_twoormore="B15002G_007",
                         male_associate_twoormore="B15002G_008",
                         male_bachelor_twoormore="B15002G_009",
                         # male_master="", # Does not exist in this dimension
                         male_gradprof_twoormore="B15002G_010",
                         # male_doctor="", # Does not exist in this dimension
                         female_total_twoormore="B15002G_011",
                         # female_noschool="", # Does not exist in this dimension
                         female_hs_twoormore="B15002G_014",
                         female_somecollege_twoormore="B15002G_016",
                         female_associate_twoormore="B15002G_017",
                         female_bachelor_twoormore="B15002G_018",
                         # female_master="", # Does not exist in this dimension
                         female_gradprof_twoormore="B15002G_019"
                         # female_doctor="" # Does not exist in this dimension
                         )

# White, Not Hispanic or Latino
edulevels_angloexcl <- c(all_total_angloexcl="B15002H_001",
                                male_total_angloexcl="B15002H_002",
                                # male_noschool="", # Does not exist in this dimension
                                male_hs_angloexcl="B15002H_005",
                                male_somecollege_angloexcl="B15002H_007",
                                male_associate_angloexcl="B15002H_008",
                                male_bachelor_angloexcl="B15002H_009",
                                # male_master="", # Does not exist in this dimension
                                male_gradprof_angloexcl="B15002H_010",
                                # male_doctor="", # Does not exist in this dimension
                                female_total_angloexcl="B15002H_011",
                                # female_noschool="", # Does not exist in this dimension
                                female_hs_angloexcl="B15002H_014",
                                female_somecollege_angloexcl="B15002H_016",
                                female_associate_angloexcl="B15002H_017",
                                female_bachelor_angloexcl="B15002H_018",
                                # female_master="", # Does not exist in this dimension
                                female_gradprof_angloexcl="B15002H_019"
                                # female_doctor="" # Does not exist in this dimension
                                )

# White, Hispanic or Latino
edulevels_hispanic <- c(all_total_hispanic="B15002I_001",
                         male_total_hispanic="B15002I_002",
                         # male_noschool="", # Does not exist in this dimension
                         male_hs_hispanic="B15002I_005",
                         male_somecollege_hispanic="B15002I_007",
                         male_associate_hispanic="B15002I_008",
                         male_bachelor_hispanic="B15002I_009",
                         # male_master="", # Does not exist in this dimension
                         male_gradprof_hispanic="B15002I_010",
                         # male_doctor="", # Does not exist in this dimension
                         female_total_hispanic="B15002I_011",
                         # female_noschool="", # Does not exist in this dimension
                         female_hs_hispanic="B15002I_014",
                         female_somecollege_hispanic="B15002I_016",
                         female_associate_hispanic="B15002I_017",
                         female_bachelor_hispanic="B15002I_018",
                         # female_master="", # Does not exist in this dimension
                         female_gradprof_hispanic="B15002I_019"
                         # female_doctor="" # Does not exist in this dimension
                         )

# We are going to get 2 datasets:
# - data_edulevels_bygender
# - data_edulevels_bygenderandrace

# Combine all by-race variable categories into one list
edulevels_bygenderandrace <- c(edulevels_anglo, 
                        edulevels_aframer, 
                        edulevels_native,
                        edulevels_asian,
                        edulevels_hawpac,
                        edulevels_others,
                        edulevels_twoormore,
                        edulevels_angloexcl,
                        edulevels_hispanic)

# Pulling ACS 2019 1-year data for all counties in TN
data_edulevels_bygender <- get_acs(geography="county",
                                   year=2019,
                                   survey="acs1",
                                   state="TN",
                                   variables=edulevels_bygender)

# For education level by race
data_edu_bygenderandrace <- get_acs(geography="county", 
                                   year=2019,
                                   survey="acs1",
                                   state="TN",
                                   variables=edulevels_bygenderandrace)

# Only keep "estimate" columns and drop "moe"
data_edulevels_bygender <- data_edulevels_bygender %>% 
  select(-moe)
  
data_edu_bygenderandrace <- data_edu_bygenderandrace %>%
  select(-moe)

# Separate out the "Variable" column into "gender", "edulevel"
data_edulevels_bygender <- data_edulevels_bygender %>%
  separate(col=variable, #Original column to split
           into=c("gender", "edulevel"), #New columns after the split
           sep="_", #Split the value at this character
           remove=TRUE, #Remove the original colums
           extra="warn", #Warn if the separator is not formatted correctly
           )

# Separate out the "Variable" column into "gender", "race", "edulevel"
data_edu_bygenderandrace <- data_edu_bygenderandrace %>%
  separate(col=variable, #Original column to split
           into=c("gender", "edulevel", "race"), #New columns after the split
           sep="_", #Split the value at this character
           remove=TRUE, #Remove the original columns
           extra="warn", #Warn if the separator is not formatted correctly
  )

# Separate out the "NAME" column into "county" and "state"
data_edulevels_bygender <- data_edulevels_bygender %>%
  separate(col=NAME, #Original column to split
           into=c("county", "state"), #New columns after the split
           sep=", ", #Split the value at this character
           remove=TRUE, #Remove the original colums
           extra="warn", #Warn if the separator is not formatted correctly
  )
data_edu_bygenderandrace <- data_edu_bygenderandrace %>%
  separate(col=NAME, #Original column to split
           into=c("county", "state"), #New columns after the split
           sep=", ", #Split the value at this character
           remove=TRUE, #Remove the original columns
           extra="warn", #Warn if the separator is not formatted correctly
  )

# Rename GEOID to geoid
data_edulevels_bygender <- data_edulevels_bygender %>%
  rename(geoid=GEOID)

data_edu_bygenderandrace <- data_edu_bygenderandrace %>%
  rename(geoid=GEOID)

# Here, we are going to match the exports to contain the same data
# as the example profile excel, both in a wide and long format
data_edulevels_bygender_summary_long <- data_edulevels_bygender %>%
  filter(edulevel != "total") %>%
  group_by(edulevel) %>%
  summarise(
    male=sum(estimate[gender=="male"], na.rm=TRUE),
    female=sum(estimate[gender=="female"], na.rm=TRUE)
  ) %>%
  ungroup() %>%
  adorn_totals("row")

data_edulevels_bygender_summary_wide <- data_edulevels_bygender %>%
  filter(edulevel != "total") %>%
  group_by(gender) %>%
  summarise(
    noschool=sum(estimate[edulevel=="noschool"], na.rm=TRUE),
    hsorequi=sum(estimate[edulevel=="hsorequi"], na.rm=TRUE),
    somecollege=sum(estimate[edulevel=="somecollege"], na.rm=TRUE),
    associate=sum(estimate[edulevel=="associate"], na.rm=TRUE),
    bachelor=sum(estimate[edulevel=="bachelor"], na.rm=TRUE),
    master=sum(estimate[edulevel=="master"], na.rm=TRUE),
    profschool=sum(estimate[edulevel=="profschool"], na.rm=TRUE),
    doctor=sum(estimate[edulevel=="doctor"], na.rm=TRUE),
  ) %>%
  ungroup() %>%
  adorn_totals("col")

## Export these data into CSV files
data_edulevels_bygender %>%
  write.csv(
    row.names = FALSE,
    paste0(csv_dest,"edulevels_bygender_details.csv")
  )

data_edu_bygenderandrace %>%
  write.csv(
    row.names = FALSE,
    paste0(csv_dest,"data_edu_bygenderandrace_details.csv")
  )

data_edulevels_bygender_summary_long %>%
  write.csv(
    row.names = FALSE,
    paste0(csv_dest,"data_edulevels_bygender_summary_long.csv")
  )

data_edulevels_bygender_summary_wide %>%
  write.csv(
    row.names = FALSE,
    paste0(csv_dest,"data_edulevels_bygender_summary_wide.csv")
  )

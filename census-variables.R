# Imports
# -------

library(tidyverse)
library(dplyr)
library(tidycensus)

# Setups and variables
# --------------------

envfile <- "./.env" # Contains all secrets
source('./helper-functions.R') # Collection of helper functions
api_key <- get_key(envfile, "census_api_key") # Get the API key from .env using helper function
census_api_key(api_key, install=TRUE, overwrite=TRUE) # Set API Key for Tidy Census, overwrite if needed
readRenviron("~/.Renviron") # Restart R environment after overwriting API key

# Education Variables in ACS1
# ---------------------------

v19 <- load_variables(2019, "acs1", cache=TRUE) # v19 is the most recent ACS1
# v19 %>% View

# For Education, we want to look at "Sex by Educational Attainment": B15002
# Note: These data are limited only for people over 25 years old
# This one contain education level in general
edu_levels_general <- c(grand_total="B15002_001",
                        male_total="B15002_002",
                        male_no_school="B15002_003",
                        male_hs_or_equi="B15002_011",
                        male_some_college="B15002_013", # Maybe add B15002_012?
                        male_associate="B15002_014",
                        male_bachelor="B15002_015",
                        male_master="B15002_016",
                        male_prof_school="B15002_017",
                        male_doctor="B15002_018",
                        female_total="B15002_019",
                        female_no_school="B15002_020",
                        female_hs_or_equi="B15002_028",
                        female_some_college="B15002_030", # Maybe add B15002_029?
                        female_associate="B15002_031",
                        female_bachelor="B15002_032",
                        female_master="B15002_033",
                        female_prof_school="B15002_034",
                        female_doctor="B15002_035"
                        )

# These ones contain education level by race
# Whites
edu_levels_whites <- c(grand_total_whites="B15002A_001",
                       male_total_whites="B15002A_002",
                       # male_no_school="", # Does not exist in this dimension
                       male_hs_whites="B15002A_005",
                       male_some_college_whites="B15002A_007",
                       male_associate_whites="B15002A_008",
                       male_bachelor_whites="B15002A_009",
                       # male_master="", # Does not exist in this dimension
                       male_grad_prof_whites="B15002A_010",
                       # male_doctor="", # Does not exist in this dimension
                       female_total_whites="B15002A_011",
                       # female_no_school="", # Does not exist in this dimension
                       female_hs_whites="B15002A_014",
                       female_some_college_whites="B15002A_016",
                       female_associate_whites="B15002A_017",
                       female_bachelor_whites="B15002A_018",
                       # female_master="", # Does not exist in this dimension
                       female_grad_prof_whites="B15002A_019"
                       # female_doctor="" # Does not exist in this dimension
                       )

# African American
edu_levels_aframer <- c(grand_total_aframer="B15002B_001",
                        male_total_aframer="B15002B_002",
                        # male_no_school="", # Does not exist in this dimension
                        male_hs_aframer="B15002B_005",
                        male_some_college_aframer="B15002B_007",
                        male_associate_aframer="B15002B_008",
                        male_bachelor_aframer="B15002B_009",
                        # male_master="", # Does not exist in this dimension
                        male_grad_prof_aframer="B15002B_010",
                        # male_doctor="", # Does not exist in this dimension
                        female_total_aframer="B15002B_011",
                        # female_no_school="", # Does not exist in this dimension
                        female_hs_aframer="B15002B_014",
                        female_some_college_aframer="B15002B_016",
                        female_associate_aframer="B15002B_017",
                        female_bachelor_aframer="B15002B_018",
                        # female_master="", # Does not exist in this dimension
                        female_grad_prof_aframer="B15002B_019"
                        # female_doctor="" # Does not exist in this dimension
                        )

# Native American
edu_levels_native <- c(grand_total_native="B15002C_001",
                       male_total_native="B15002C_002",
                       # male_no_school="", # Does not exist in this dimension
                       male_hs_native="B15002C_005",
                       male_some_college_native="B15002C_007",
                       male_associate_native="B15002C_008",
                       male_bachelor_native="B15002C_009",
                       # male_master="", # Does not exist in this dimension
                       male_grad_prof_native="B15002C_010",
                       # male_doctor="", # Does not exist in this dimension
                       female_total_native="B15002C_011",
                       # female_no_school="", # Does not exist in this dimension
                       female_hs_native="B15002C_014",
                       female_some_college_native="B15002C_016",
                       female_associate_native="B15002C_017",
                       female_bachelor_native="B15002C_018",
                       # female_master="", # Does not exist in this dimension
                       female_grad_prof_native="B15002C_019"
                       # female_doctor="" # Does not exist in this dimension
                       )

# Asian
edu_levels_asian <- c(grand_total_asian="B15002D_001",
                      male_total_asian="B15002D_002",
                      # male_no_school="", # Does not exist in this dimension
                      male_hs_asian="B15002D_005",
                      male_some_college_asian="B15002D_007",
                      male_associate_asian="B15002D_008",
                      male_bachelor_asian="B15002D_009",
                      # male_master="", # Does not exist in this dimension
                      male_grad_prof_asian="B15002D_010",
                      # male_doctor="", # Does not exist in this dimension
                      female_total_asian="B15002D_011",
                      # female_no_school="", # Does not exist in this dimension
                      female_hs_asian="B15002D_014",
                      female_some_college_asian="B15002D_016",
                      female_associate_asian="B15002D_017",
                      female_bachelor_asian="B15002D_018",
                      # female_master="", # Does not exist in this dimension
                      female_grad_prof_asian="B15002D_019"
                      # female_doctor="" # Does not exist in this dimension
                      )

# Hawaiian/Pacific Islanders
edu_levels_haw_pac <- c(grand_total_haw_pac="B15002E_001",
                        male_total_haw_pac="B15002E_002",
                        # male_no_school="", # Does not exist in this dimension
                        male_hs_haw_pac="B15002E_005",
                        male_some_college_haw_pac="B15002E_007",
                        male_associate_haw_pac="B15002E_008",
                        male_bachelor_haw_pac="B15002E_009",
                        # male_master="", # Does not exist in this dimension
                        male_grad_prof_haw_pac="B15002E_010",
                        # male_doctor="", # Does not exist in this dimension
                        female_total_haw_pac="B15002E_011",
                        # female_no_school="", # Does not exist in this dimension
                        female_hs_haw_pac="B15002E_014",
                        female_some_college_haw_pac="B15002E_016",
                        female_associate_haw_pac="B15002E_017",
                        female_bachelor_haw_pac="B15002E_018",
                        # female_master="", # Does not exist in this dimension
                        female_grad_prof_haw_pac="B15002E_019"
                        # female_doctor="" # Does not exist in this dimension
                        )

# Other Races
edu_levels_others <- c(grand_total_others="B15002F_001",
                       male_total_others="B15002F_002",
                       # male_no_school="", # Does not exist in this dimension
                       male_hs_others="B15002F_005",
                       male_some_college_others="B15002F_007",
                       male_associate_others="B15002F_008",
                       male_bachelor_others="B15002F_009",
                       # male_master="", # Does not exist in this dimension
                       male_grad_prof_others="B15002F_010",
                       # male_doctor="", # Does not exist in this dimension
                       female_total_others="B15002F_011",
                       # female_no_school="", # Does not exist in this dimension
                       female_hs_others="B15002F_014",
                       female_some_college_others="B15002F_016",
                       female_associate_others="B15002F_017",
                       female_bachelor_others="B15002F_018",
                       # female_master="", # Does not exist in this dimension
                       female_grad_prof_others="B15002F_019"
                       # female_doctor="" # Does not exist in this dimension
                       )

# Two or More Races
edu_levels_two_plus <- c(grand_total_two_plus="B15002G_001",
                         male_total_two_plus="B15002G_002",
                         # male_no_school="", # Does not exist in this dimension
                         male_hs_two_plus="B15002G_005",
                         male_some_college_two_plus="B15002G_007",
                         male_associate_two_plus="B15002G_008",
                         male_bachelor_two_plus="B15002G_009",
                         # male_master="", # Does not exist in this dimension
                         male_grad_prof_two_plus="B15002G_010",
                         # male_doctor="", # Does not exist in this dimension
                         female_total_two_plus="B15002G_011",
                         # female_no_school="", # Does not exist in this dimension
                         female_hs_two_plus="B15002G_014",
                         female_some_college_two_plus="B15002G_016",
                         female_associate_two_plus="B15002G_017",
                         female_bachelor_two_plus="B15002G_018",
                         # female_master="", # Does not exist in this dimension
                         female_grad_prof_two_plus="B15002G_019"
                         # female_doctor="" # Does not exist in this dimension
                         )

# White, Not Hispanic or Latino
edu_levels_white_exclusive <- c(grand_total_white_exclusive="B15002H_001",
                                male_total_white_exclusive="B15002H_002",
                                # male_no_school="", # Does not exist in this dimension
                                male_hs_white_exclusive="B15002H_005",
                                male_some_college_white_exclusive="B15002H_007",
                                male_associate_white_exclusive="B15002H_008",
                                male_bachelor_white_exclusive="B15002H_009",
                                # male_master="", # Does not exist in this dimension
                                male_grad_prof_white_exclusive="B15002H_010",
                                # male_doctor="", # Does not exist in this dimension
                                female_total_white_exclusive="B15002H_011",
                                # female_no_school="", # Does not exist in this dimension
                                female_hs_white_exclusive="B15002H_014",
                                female_some_college_white_exclusive="B15002H_016",
                                female_associate_white_exclusive="B15002H_017",
                                female_bachelor_white_exclusive="B15002H_018",
                                # female_master="", # Does not exist in this dimension
                                female_grad_prof_white_exclusive="B15002H_019"
                                # female_doctor="" # Does not exist in this dimension
                                )

# White, Hispanic or Latino
edu_levels_hispanic <- c(grand_total_hispanic="B15002I_001",
                         male_total_hispanic="B15002I_002",
                         # male_no_school="", # Does not exist in this dimension
                         male_hs_hispanic="B15002I_005",
                         male_some_college_hispanic="B15002I_007",
                         male_associate_hispanic="B15002I_008",
                         male_bachelor="B15002I_009",
                         # male_master="", # Does not exist in this dimension
                         male_grad_prof_hispanic="B15002I_010",
                         # male_doctor="", # Does not exist in this dimension
                         female_total_hispanic="B15002I_011",
                         # female_no_school="", # Does not exist in this dimension
                         female_hs_hispanic="B15002I_014",
                         female_some_college_hispanic="B15002I_016",
                         female_associate_hispanic="B15002I_017",
                         female_bachelor_hispanic="B15002I_018",
                         # female_master="", # Does not exist in this dimension
                         female_grad_prof_hispanic="B15002I_019"
                         # female_doctor="" # Does not exist in this dimension
                         )

# We are going to get 2 datasets:
# - data_edu_levels_general
# - data_edu_levels_by_race

# Combine all by-race variable categories into one list
edu_levels_by_race <- c(edu_levels_whites, 
                        edu_levels_aframer, 
                        edu_levels_native,
                        edu_levels_asian,
                        edu_levels_haw_pac,
                        edu_levels_others,
                        edu_levels_two_plus,
                        edu_levels_white_exclusive,
                        edu_levels_hispanic)

# Pulling ACS 2019 1-year data for all counties in TN
data_edu_levels_general <- get_acs(geography="county",
                                   year=2019,
                                   survey="acs1",
                                   state="TN",
                                   variables=edu_levels_general,
                                   output="wide")

# For education level by race
data_edu_levels_by_race <- get_acs(geography="county", 
                                   year=2019,
                                   survey="acs1",
                                   state="TN",
                                   variables=edu_levels_by_race,
                                   output="wide")

## TODO: Export these data into CSV files
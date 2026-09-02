# Author: Selene Banuelos
# Date: 8/21/2026
# Description: Create data dictionary for raw lead dried blood spot data

# setup
library(dplyr)
library(janitor)

# import data ------------------------------------------------------------------
# define path to PEARLS box directory
pearls_dir <- paste0(
  dirname(getwd()), 
  '/Research on Stress and Inequitable Environments Lab/Studies/PEARLS/')

# raw lead DBS data from Specht lab
lead_dbs <- read.csv(paste0(pearls_dir,
                            'Lead-DBS/data-raw/Blood Spots Rose 8-20-2026.csv'))

# data wrangling ---------------------------------------------------------------
# get list of variable names
vars <- as.character(lead_dbs[1,]) %>%
  # remove empty spaces from variable names
  gsub(' ', '', .) %>%
  # remove duplicates of variable names
  unique(.)

# get list of elements measured
elements <- lead_dbs %>%
  # remove non-element variable names
  select(!c(X, contains('X.'))) %>%
  # get vector of element names
  names()
  
# identify all possible units
units <- lead_dbs %>%
  # convert first row into column names
  row_to_names(row_number = 1) %>%
  clean_names() %>%
  # keep columns that correspond to units
  select(contains('unit')) %>%
  # remove duplicate rows 
  distinct() %>%
  # save all units in vector
  as.character(.[1,]) %>%
  # keep unique values
  unique() %>%  
  # remove empty spaces from elements
  gsub(' ', '', .)

# look at different formats that 'C' column can take
c <- lead_dbs %>%
  # convert first row into column names
  row_to_names(row_number = 1) %>%
  clean_names() %>%
  # keep columns that correspond to units
  select(contains('c'))
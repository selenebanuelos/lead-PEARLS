# Author: Selene Banuelos
# Date: 9/11/2026
# Description: Check which participants are missing CalEnviroScreen and 
# AirToxScreen data

# setup
library(dplyr)

# import data ------------------------------------------------------------------
# CalEnviroScreen data for PEARLS participants
cal <- read.csv('data-raw/pearls_calenviro_export.csv')

# 2017 & 2018 AirToxScreen data for PEARLS participants
air_2017 <- read.csv('data-raw/PEARLS_AirTox_2017_export.csv')
air_2018 <- read.csv('data-raw/PEARLS_AirTox_2018_export.csv')

# PEARLS demo data
demo <- read.csv('data-raw/pearls_dataset_2022-07-08.csv')

# data wrangling ---------------------------------------------------------------
# get df of all PEARLS participant IDs (555 total)
ids <- distinct(select(demo, pearls_id))

# check which participants are missing CalEnviroScreen data
missing_cal <- ids %>%
    # join available CalEnviroScreen data to all participant IDs
    left_join(., cal, by = 'pearls_id') %>%
    # find participants missing all CalEnviroScreen data
    filter(if_all(c(-pearls_id), is.na))
# 8 participants are missing CalEnviroScreen data

# check which particpants are missing 2017 AirToxScreen data
missing_2017 <- ids %>%
    # join available AirToxScreen data to all participant IDs
    left_join(., air_2017, by = 'pearls_id') %>%
    # filer for participants missing all AirToxScreen data
    filter(if_all(c(-pearls_id), is.na))
# no participants missing 2017 AirToxScreen data

# check which particpants are missing 2018 AirToxScreen data
missing_2018 <- ids %>%
    # join available AirToxScreen data to all participant IDs
    left_join(., air_2018, by = 'pearls_id') %>%
    # filer for participants missing all AirToxScreen data
    filter(if_all(c(-pearls_id), is.na))
# no participants missing 2018 AirToxScreen data
    


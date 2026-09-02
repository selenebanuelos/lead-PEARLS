# Author: Selene Banuelos
# Date: 9/2/2026
# Description: Clean raw dried blood spot EDXRF data from PEARLS participants

# setup
library(dplyr)
library(janitor)

# import data ------------------------------------------------------------------
# raw EDXRF data
raw <- read.csv('data-raw/Blood Spots Rose 8-20-2026.csv')

# data wrangling ---------------------------------------------------------------
# get element symbols from column names
e_symbols <- names(raw) %>%
    # change elements in vector that don't correspond to a symbol to empty string
    

# get data type names from 1st row of dataframe
data_names <- as.character(raw[1,]) %>%
    # change any 


df <- raw %>%
    # add element symbols stored in column names as row in dataframe
    rbind(names(.)) %>%
    # 
    
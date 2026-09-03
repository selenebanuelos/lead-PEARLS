# Author: Selene Banuelos
# Date: 9/2/2026
# Description: Clean raw dried blood spot EDXRF data from PEARLS participants

# setup
library(dplyr)
library(janitor)
library(stringr)
library(tidyr)

# import data ------------------------------------------------------------------
# raw EDXRF data
raw <- read.csv('data-raw/Blood Spots Rose 8-20-2026.csv')

# data wrangling ---------------------------------------------------------------
# helper function that fills vector with element symbols
fill_in <- function(x){
    
    # find first non-empty string position in vector
    first_element <- min(which(x != ''))
    
    # create new vector that will have filled-in element symbols
    filled_x <- x
    
    # replace empty strings with element symbols
    for(i in first_element:length(x)) {
        # starting at first non-empty index (first element symbol), 
        filled_x[i] <- ifelse(x[i] == '', # if position in OG vector is empty string
                              # replace with element symbol from previous position
                              filled_x[i-1], 
                              # else, keep current element symbol from OG vector
                              x[i] 
                              )
    }
    
    return(filled_x)
}
    
# create vector of element symbol
elements <- names(raw) %>% # get element symbols from column names
    # change items that don't correspond to an element symbol to empty string
    gsub('X.*', '', .) %>%
    # fill empty strings with element symbols
    fill_in(.)

# get variable names from 1st row of dataframe
var_names <- as.character(raw[1,]) %>%
    # strip empty strings from variable names
    str_trim(.)

# combine element symbols with variable names
var_element <- paste(var_names, elements, sep = '_')

# vector of elements without back-calculated concentrations
no_conc <- unique(elements) %>%
    # remove empty empty elements
    stringi::stri_remove_empty(.) %>%
    # extract elements that don't have back-calculated concentrations
    setdiff(., c('Pb', 'As', 'Cd', 'Hg'))

df <- raw %>%
    # set var_element vector as new column names
    setNames(var_element) %>%
    # remove first row, which contains old variable names
    # and remove last 2 rows with average and SD of data
    slice(2:(nrow(.)-2)) %>%
    # remove columns with row number and 'Seq', which is the same for all obs
    select(-c(Nr_, Seq_)) %>%
    # remove any columns corresponding to Vanadium, since no intensity was 
    # recorded for this element
    select(-contains('_V')) %>%
    # make data longer for storage
    pivot_longer(cols = contains(c('Iraw_', 'Inet_', 'C_', 'Unit_')),
                 names_to = c('.value', 'element'),
                 names_sep = '_'
    ) %>%
    pivot_longer(cols = c(Iraw, Inet, C),
                 names_to = 'measure',
                 values_to = 'value'
    ) %>%
    # remove concentration rows for elements with intensity only
    filter(!(element %in% no_conc & measure == 'C'))
# clean up variable names
    
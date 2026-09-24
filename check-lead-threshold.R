# Author: Selene Banuelos
# Date: 9/8/2026
# Description: Count number of participants with blood lead levels exceeding
# the CDC action threshold of 3.5 ug/dl

# setup
library(dplyr)
library(stringr)

# import data ------------------------------------------------------------------
# x-ray fluorescence data from dried blood spots
edxrf <- read.csv('data-processed/blood-edxrf.csv')

# data wrangling ---------------------------------------------------------------
# separate and clean lead concentration data 
lead <- edxrf %>%
    # keep only lead data
    filter(element == 'Pb',
           # keep only concentrations, don't need intensity data
           measure == 'C') %>%
    # convert concentrations to ug/dL (1 ug/L = 0.1 ug/dL)
    mutate(pb_ugdL = value / 10) %>%
    # remove unnecessary columns
    select(-c(element, unit, measure, value))

# get vector of IDs for samples run in duplicate
duplicates <- grep('-2', lead$ident, value = TRUE) %>%
    # remove '-2' suffix
    str_remove('-2') %>%
    # remove whitespaces from elements
    str_trim(.)

# calculate percent coefficient of variation for duplicates
cv <- lead %>%
    # create separate column with sample ID without '-2' suffix for all samples
    mutate(sample_id = str_remove(ident, '-2'),
           sample_id = str_trim(sample_id)) %>%
    # keep samples that were run in duplicate
    filter(sample_id %in% duplicates) %>%
    # calculate difference between duplicate measures
    group_by(sample_id) %>%
    summarize(diff = diff(pb_ugdL))
    # calculate inter-assay %CV for duplicates
    #mutate(perc_cv <- )
    
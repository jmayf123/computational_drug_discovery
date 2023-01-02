library(shiny)
library(tidyverse)
library(dplyr)
library(shinydashboard)
library(reticulate)

#Reading in our python functions so we can use the chembl webresource client 
source_python("python_notebooks/functions.py")

#DF of target information, filtered to target type = single protein 
# and organism = homo sapien
targets <- read_csv("data/target_data.csv")



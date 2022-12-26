library(shiny)
library(tidyverse)
library(dplyr)
library(shinydashboard)
library(reticulate)



#Reading in our python functions so we can use the chembl webresource client 
source_python("python_notebooks/functions.py")

target_names_options <- read_csv("data/target_data.csv")




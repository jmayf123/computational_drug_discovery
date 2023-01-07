library(shiny)
library(shinyWidgets)
library(tidyverse)
library(dplyr)
library(shinydashboard)
library(reticulate)

use_condaenv("drug_discovery")
#Reading in our python functions so we can use the chembl webresource client 
source_python("python_notebooks/functions.py")

source_python("python_notebooks/functions_2.py")



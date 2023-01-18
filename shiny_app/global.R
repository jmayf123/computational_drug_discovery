
reticulate::use_condaenv("drug_discovery")
#Reading in our python functions so we can use the chembl webresource client 
reticulate::source_python("python/functions.py")
reticulate::source_python("python/functions_2.py")


library(shiny)
library(shinyWidgets)
library(tidyverse)
library(dplyr)
library(shinydashboard)
library(shinydashboardPlus)
library(randomForest)
library(caret)
library(rcdk)
library(fingerprint)



box_plotter <- function(df, y_data, y_label) {
  ggplot(data = df, aes(x = bioactivity_class, y = y_data, fill = bioactivity_class)) +
    geom_boxplot() +
    xlab("Bioactivity Class") +
    ylab(y_label)+
    guides(fill = FALSE)    
}


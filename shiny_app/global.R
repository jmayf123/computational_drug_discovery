library(shiny)
library(shinyWidgets)
library(tidyverse)
library(dplyr)
library(shinydashboard)

reticulate::use_condaenv("drug_discovery")
#Reading in our python functions so we can use the chembl webresource client 
reticulate::source_python("python_notebooks/functions.py")
reticulate::source_python("python_notebooks/functions_2.py")

box_plotter <- function(df, y_data, y_label) {
  ggplot(data = df, aes(x = bioactivity_class, y = y_data, fill = bioactivity_class)) +
    geom_boxplot() +
    xlab("Bioactivity Class") +
    ylab(y_label)
}

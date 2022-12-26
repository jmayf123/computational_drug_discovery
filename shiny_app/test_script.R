library(shiny)
library(tidyverse)
library(dplyr)
library(shinydashboard)
library(reticulate)


use_python("C:/Users/jacks/anaconda3/python.exe")

source_python("python_notebooks/functions.py")

target_search("Acetylcholinesterase")

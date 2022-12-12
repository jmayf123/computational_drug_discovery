# library(shiny)
# library(tidyverse)
# library(shinydashboard)
# library(httr)
# library(jsonlite)

get_search_data <- function(search_term) {
  
  res = GET(paste("https://www.ebi.ac.uk/chembl/api/data/target/search.json?q=",search_term, sep = ""))
  data = fromJSON(rawToChar(res$content))
  return(data$targets)
}
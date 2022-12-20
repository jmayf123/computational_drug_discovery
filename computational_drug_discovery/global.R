library(shiny)
library(tidyverse)
library(dplyr)
library(shinydashboard)
library(httr)
library(jsonlite)

target_data = read.csv("data/target_data.csv") %>% 
                filter(Activities > 0)

get_bioactivities_data <- function(target_chembl_ID) {
  
  offset <- 0
  # Set the URL for the API endpoint
  url <- paste("https://www.ebi.ac.uk/chembl/api/data/activity?format=json&limit=1000&offset=",
               as.character(offset),
               "&standard_type=IC50&target_chembl_id__in=",
               target_chembl_ID,
               sep = "")
  
  # Set a counter to track the number of API requests made
  counter <- 0
  
  # Set a flag to indicate when all entries have been gathered
  all_entries_gathered <- FALSE
  
  # Create an empty list to store the API responses
  responses <- list()
  
  # Loop the API request until all entries are gathered
  while (!all_entries_gathered) {
    # Make the API request
    res <- GET(url)
    
    # Increment the counter
    counter <- counter + 1
    
    # Check the status code of the API response
    if (status_code(res) == 200) {
      # If the API request was successful, parse the response
      
      res_df <- tibble(fromJSON(rawToChar(res$content))$activities)
      
      # Check if all entries have been gathered
      if (nrow(res_df) < 1000) {
        # If there are fewer than 100 rows in the response data frame, set the flag to indicate that all entries have been gathered
        all_entries_gathered <- TRUE
      } else {
        # If there are 100 rows in the response data frame, update the parameters for the next API request
        offset <- offset + 1000
        url <- paste("https://www.ebi.ac.uk/chembl/api/data/activity?format=json&limit=1000&offset=",
                     as.character(offset),
                     "&standard_type=IC50&target_chembl_id__in=",
                     target_chembl_ID,
                     sep = "")
      }
      
      # Append the response data frame to the list of responses
      responses <- c(responses, list(res_df))
    } else {
      # If the API request was unsuccessful, print an error message and stop the loop
      stop("API request failed with status code: ", status_code(res))
    }
  }
  
  # Bind the responses into a single data frame
  final_df <- bind_rows(responses)
  return(final_df)
}


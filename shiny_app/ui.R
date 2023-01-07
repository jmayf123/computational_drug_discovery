#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


shinyUI(
  
  fluidPage(
    
    #App title 
    titlePanel("Computational Drug Discovery Dashboard"),
    
    #Sidebar
    sidebarPanel(
      
      searchInput(
        inputId = "target_name",
        label = "Search Target:",
        value = "",
        placeholder = "Enter Target name here ...",
        btnSearch = icon("magnifying-glass"),
        btnReset = icon("xmark"),
        resetValue = "",
        width = NULL
      ),
      
      searchInput(
        inputId = "chembl_id",
        label = "Search Target ChEMBL ID:",
        value = "",
        placeholder = "Enter Target ChEMBL ID here ...",
        btnSearch = icon("magnifying-glass"),
        btnReset = icon("xmark"),
        resetValue = "",
        width = NULL
      )
    ),
    
    #Body
    mainPanel(
      
      tabsetPanel(
        # 1st Tab
        tabPanel(
          "Data Tables",
          fluidRow(
      
      
            column(
              width = 6,
              dataTableOutput("target_search_results")
            ),
            column(
              width = 6,
              valueBoxOutput("bioactivities_box")
            )
            
          )
          
        ),
        # 2nd Tab
        tabPanel("EDA"),
        # 3rd Tab
        tabPanel("ML Drug Discovery")
      )
    )
    
  )
)



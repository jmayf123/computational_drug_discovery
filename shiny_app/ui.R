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
        value = "SARS",
        placeholder = "Enter Target name here ...",
        btnSearch = icon("magnifying-glass"),
        btnReset = icon("xmark"),
        resetValue = "",
        width = NULL
      ),
      
      searchInput(
        inputId = "chembl_id",
        label = "Search Target ChEMBL ID:",
        value = "CHEMBL3927",
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
        # Data Table Tab
        tabPanel("Data Tables",
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
        # Statistical Data analysis on Lipinski Descriptors
        tabPanel("EDA",
                 fluidRow(
                   column(
                     width = 9,
                     plotOutput('eda_plot')
                   )
                   # column(
                   #   width = 3,
                   #   textOutput('lipinski_text')
                   # )
                 )
        ),
        # ML model to predict different candidates for Drug Therapies
        tabPanel("ML Drug Discovery")
      )
    )
    
  )
)



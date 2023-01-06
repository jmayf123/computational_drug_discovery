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
      
      textInput("target_name",
                h3("Search Target"), 
                value = "Enter text..."
      ),
      
      textInput("chembl_id",
                h3("Chembl ID"),
                value = "Enter text..."
                
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
              dataTableOutput('bioactivities_search_results')
            )
          ),
        ),
        # 2nd Tab
        tabPanel("EDA"),
        # 3rd Tab
        tabPanel("ML Drug Discovery")
      )
    )
  )
)


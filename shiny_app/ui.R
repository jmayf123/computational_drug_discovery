#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


shinyUI(
  
  dashboardPage(
    
    #App title 
    dashboardHeader(
      title = "Computational Drug Discovery Dashboard",
      titleWidth = 500
    ),
    
    #Sidebar
    dashboardSidebar(
      width = 300,
      
      textInput("target_name",
                h3("Search Target"), 
                value = "Enter text..."
      ) 
      
    ),
    
    #Body
    dashboardBody(
      
      fluidRow(
        column(
          width = 12,
          dataTableOutput("target_search_results")
        )
      )
    )
  )
)


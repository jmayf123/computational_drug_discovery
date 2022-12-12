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
    dashboardHeader(title = "Computational Drug Discovery Dashborad"),
    
    #Sidebar
    dashboardSidebar(
      
      sidebarSearchForm("search", "Search Bar", label = "Search...",
                        icon = shiny::icon("search"))
      
    ),
    
    #Body
    dashboardBody(
      
      fluidRow(
        dataTableOutput("filteredTable")
      )
      
    )
    
    
    
  )
)

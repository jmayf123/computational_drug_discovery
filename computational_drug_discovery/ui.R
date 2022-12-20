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
      title = "Computational Drug Discovery Dashborad"
      
    ),
    
    #Sidebar
    dashboardSidebar(
      
      selectizeInput(
        'target', 
        'Target Selection:', 
        choices = sort(target_data$Name),
        options = list(
          placeholder = 'Please select an option below',
          onInitialize = I('function() { this.setValue(""); }')
        )
        
      )
    ),
    
    #Body
    dashboardBody(
      
      # fluidRow(
      #   dataTableOutput("filteredTable")
      # )
      
    )
    
    
    
  )
)


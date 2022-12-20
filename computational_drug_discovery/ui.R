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
      
      fluidRow(
        column(
          width = 12,
          dataTableOutput("bioactivity_data"),
          style = "height:500px; overflow-y: scroll;overflow-x: scroll;"
        )
      )
      
    )
    
    
    
  )
)


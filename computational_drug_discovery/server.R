#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyServer(function(input, output) {
  
  targets_data_filtered <- reactive({
    get_search_data(input$search)
    
  })
  
  output$filteredTable <- renderDataTable({
    targets_data_filtered()
  })
  
})
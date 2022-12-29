#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyServer(function(input, output) {
  
  
  target_chembl_ID <- reactive({
    
    target_search(input$target_name) %>%
      select(target_chembl_id) %>% 
      slice(1)
    
    # df[1,]

  })
  output$target_data <- renderDataTable({
    target_chembl_ID
  })
  output$bioactivities_data <- renderDataTable({
    get_bioactivities_data(target_chembl_ID())
  })
  
})
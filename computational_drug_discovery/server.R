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
    
    target_data %>% 
      filter(Name == input$target) %>% 
      select(ChEMBL.ID)
    
  })
  
  output$bioactivity_data <- renderDataTable({
    withProgress(
    get_bioactivities_data(target_chembl_ID())
    )
  })
  
})
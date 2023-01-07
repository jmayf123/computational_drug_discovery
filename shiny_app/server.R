#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyServer(function(input, output, session) {
  
  
  output$target_search_results <- renderDataTable({
    target_search(input$target_name)
  })
  
  
  output$bioactivities_box <- renderValueBox({
    
    valueBox(
      "Number of Bioactivites Found for your Target:",
      nrow(get_bioactivities_data(input$chembl_id)),
      icon = icon(name = "pills", lib = "font-awesome"),
      width = NULL,
      color = "red"
        
    )
  })
  
  observeEvent(input$chembl_id_search, {
    df_bioactivities <- get_bioactivities_data(input$chembl_id)
  })
  
  
  
})
#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyServer(function(input, output) {
  
  target_name <- reactive({
    input$target_name
  })
  
  chembl_id <- reactive({
    input$chembl_id
  })
  
 output$target_search_results <- renderDataTable({
   target_search(target_name())
 })
 

 
 
 output$bioactivities_box <- renderValueBox({
   valueBox(
     "Number of Bioactivites Found for your Target:",
     length(get_bioactivities_data(chembl_id()))
     
   )
 })

  
})
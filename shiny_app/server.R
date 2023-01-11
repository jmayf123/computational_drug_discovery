#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyServer(function(input, output) {
  
  
  output$target_search_results <- renderDataTable({
    target_search(input$target_name)
  })
  
  
  output$bioactivities_box <- renderValueBox({
    
    valueBox(
      "Number of Bioactivites Found for your Target:",
      nrow(get_bioactivities_data(input$chembl_id)),
      icon = icon(name = "pills", lib = "font-awesome"),
      width = 9,
      color = "red"
        
    )
    
  })
  
  df_bioactivities <- eventReactive(input$chembl_id_search, {
    
    get_bioactivities_data(input$chembl_id)
    
  })
  
  
  
  #EDA stuff
  output$eda_plot <- renderPlot({
    #Create facet grid of 4 lipinski descriptor comparisons, ACTIVE vs INACTIVE
    
    df_2_class <- df_bioactivities() %>%#Remove the intermediate Class
                    filter(bioactivity_class != "intermediate")
    
    freq_graph(df_2_class)
  })
  output$lipinksi_text <- renderText({
    "Input the stuff about lipinski descriptors Here"
  })
  
  
})
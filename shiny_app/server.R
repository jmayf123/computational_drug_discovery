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
      width = NULL,
      color = "red"
        
    )
    
  })
  
  df_bioactivities_cleaned <- eventReactive(input$chembl_id_search, {
    
    df_bioactivities <- get_bioactivities_data(input$chembl_id) 
    df_lipinski <- lipinski(df_bioactivities$canonical_smiles)
    df_combined <-  bind_cols(df_bioactivities, df_lipinski)
    df_norm <- norm_value(df_combined)
    df_bioactivities_cleaned <- pIC50(df_norm)
    
    
  })
  
  
  
  #EDA stuff
  output$freq_graph <- renderPlot({
    
    
    df_bioactivities_cleaned() %>%#Remove the intermediate Class
      filter(bioactivity_class != "intermediate") %>% 
      ggplot(aes(x = bioactivity_class)) +
      geom_bar(aes(y = (after_stat(count))/sum(after_stat(count))), stat = "count", fill = "steelblue") +
      xlab("Bioactivity Class") +
      ylab("Frequency") +
      geom_text(aes(label = scales::percent(after_stat(count)/sum(after_stat(count))), 
                    y = (after_stat(count))/sum(after_stat(count))), stat = "count", 
                vjust = -0.25, size = 3.5)
    
    
  })
  
  output$logp_vs_mw_graph <- renderPlot({
    
    df_bioactivities_cleaned() %>% 
      filter(bioactivity_class != "intermediate") %>% 
      ggplot(aes(x = MW, y = LogP, color = bioactivity_class, size = pIC50)) + 
      geom_point() + 
      xlab("MW") + ylab("LogP") + 
      scale_size_continuous(range = c(1,5)) + 
      theme_classic() +
      guides(size = guide_legend(title = "pIC50"), color = guide_legend(title = "Bioactivity Class"))
    
  })
  
  output$box_1 <- renderPlot({
    
    df <- df_bioactivities_cleaned() %>% 
      filter(bioactivity_class != "intermediate")
    box_plotter(df,
                y_data = df$pIC50,
                y_label = "pIC50 Value"
    )
    
  })
  
  output$box_2 <- renderPlot({
    
    df <- df_bioactivities_cleaned() %>% 
      filter(bioactivity_class != "intermediate")
    box_plotter(df,
                y_data = df$MW,
                y_label = "MW Value"
    )
    
  })
  output$box_3 <- renderPlot({
    
    df <- df_bioactivities_cleaned() %>% 
      filter(bioactivity_class != "intermediate")
    box_plotter(df,
                y_data = df$LogP,
                y_label = "LogP Value"
    )
    
  })
  output$box_4 <- renderPlot({
    
    df <- df_bioactivities_cleaned() %>% 
      filter(bioactivity_class != "intermediate")
    box_plotter(df,
                y_data = df$NumHDonors,
                y_label = "Number of H Donors"
    )
    
  })
  output$box_5 <- renderPlot({
    
    df <- df_bioactivities_cleaned() %>% 
      filter(bioactivity_class != "intermediate")
    box_plotter(df,
                y_data = df$NumHAcceptors,
                y_label = "Number of H Acceptors"
    )
    
  })
  output$lipinksi_text <- renderText({
    "Input the stuff about lipinski descriptors Here"
  })
  #Create facet grid of 4 lipinski descriptor comparisons, ACTIVE vs INACTIVE
  
})
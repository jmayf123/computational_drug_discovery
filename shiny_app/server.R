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
      value = nrow(get_bioactivities_data(input$chembl_id)),
      subtitle = "Number of Bioactivites Found for your Target",
      icon = icon(name = "pills", lib = "font-awesome"),
      width = 4,
      color = "red",
      href = NULL)
    
  })
  
  df_bioactivities_cleaned <- eventReactive(input$chembl_id_search, {
    
    df_bioactivities <- get_bioactivities_data(input$chembl_id) %>% drop_na()
    df_lipinski <- lipinski(df_bioactivities$canonical_smiles)
    df_combined <-  bind_cols(df_bioactivities, df_lipinski)
    df_norm <- norm_value(df_combined)
    
    df_bioactivities_cleaned <- pIC50(df_norm)
    
    
  })
  
  output$download_data <- downloadHandler(
    filename = paste("bioactivities_for_target",".csv", sep = ""),
    content = function(file) {
      write.csv(df_bioactivities_cleaned(), file, row.names = FALSE)
    }
  )
  
  #EDA stuff
  output$freq_graph <- renderPlot({
    
    df_bioactivities_cleaned() %>%#Remove the intermediate Class
      filter(bioactivity_class != "intermediate") %>% 
      ggplot(aes(x = bioactivity_class, fill = bioactivity_class)) +
      geom_bar(aes(y = (after_stat(count))/sum(after_stat(count))), stat = "count") +
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
  
  #Create facet grid of 4 Lipinski descriptor comparisons and the pIC50 value, ACTIVE vs INACTIVE
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
  
  #Mann-Whitney Statistical Significance Table for all the Lipinski Descriptors
  output$mann_whitney_table <- renderDataTable({
    
    df <- df_bioactivities_cleaned() %>% 
      filter(bioactivity_class != "intermediate")
    
    mw_pIC50 <- mannwhitney('pIC50', df)
    mw_MW <- mannwhitney('MW', df)
    mw_LogP <- mannwhitney('LogP', df)
    mw_H_donors <- mannwhitney('NumHDonors', df)
    mw_H_acceptors <- mannwhitney('NumHAcceptors', df)
    
    do.call("rbind", list(mw_pIC50, mw_MW, mw_LogP, mw_H_donors, mw_H_acceptors))
  })
  
  #ML Random Forest Regression Model
  
  output$test_input_img <- renderImage({
    
    list(src = "www/test_input_img.png")
    
  }, deleteFile = F)
  
  in_df <- reactive({
    inFile <- input$df_bio_input#Input with 1st Col = canonical_smile, 2nd - chembl_id
    in_df <- read_csv(inFile)
  })
  
  output$predictedIC50 <- renderDataTable({
    
    in_df <- in_df()
    sp <- get.smiles.parser()
    smiles <- in_df$canonical_smile
    mols <- parse.smiles(smiles)
    
    fps <- lapply(mols, get.fingerprint, type='pubchem')
    
    col.from <- c(paste0("V",as.character(1:881)))
    col.to <- c(paste0("PubchemFP",as.character(0:880)))
    
    fp_df <- as_tibble(fp.to.matrix(fps)) %>% 
      rename_at(vars(col.from), function(x) col.to)
    
    
    model <- readRDS('ML_model_CHEMBL1966.rds')
    
    model %>% 
      predict(fp_df) %>% 
      mutate(CHEMBL_ID = in_df$chembl_id, .before = .pred) %>% 
      rename(Predicted_pIC50_Value = .pred)
  })
  
})
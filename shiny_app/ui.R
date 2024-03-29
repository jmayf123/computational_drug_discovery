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
    skin = 'midnight',
    
    #App title 
    dashboardHeader(
      title = span("Computational Drug Discovery Dashboard", 
                   style = "color: Green; font-size: 28px; font-weight: bold;"),
      titleWidth = 650
    ),
    
    #Sidebar
    dashboardSidebar(
      width = 450,
      
      searchInput(
        inputId = "target_name",
        label = "STEP 1 - Search Target:",
        value = "SARS",
        placeholder = "Enter Target name here ...",
        btnSearch = icon("magnifying-glass"),
        btnReset = icon("xmark"),
        resetValue = "",
        width = NULL
      ),
      
      searchInput(
        inputId = "chembl_id",
        label = "STEP 2 - Copy Desired ChEMBL ID from table:",
        value = "CHEMBL3927",
        placeholder = "Enter Target ChEMBL ID here ...",
        btnSearch = icon("magnifying-glass"),
        btnReset = icon("xmark"),
        resetValue = "",
        width = NULL
      ),
      
      box(width = 12,
          title = "Information for EDA Tab:",
          
          "Christopher Lipinski, a scientist at Pfizer, came up with a set of 
      rule-of-thumb for evaluating the druglikeness of compounds. Such druglikeness 
      is based on the Absorption, Distribution, Metabolism and Excretion (ADME) 
      that is also known as the pharmacokinetic profile. Lipinski analyzed all 
      orally active FDA-approved drugs in the formulation of what is to be known 
      as the Rule-of-Five or Lipinski's Rule.",
      br(),br(),
      "The Lipinski's Rule stated the following:",
      br(),br(),
      "1. Molecular weight < 500 Dalton",
      br(),
      "2. Octanol-water partition coefficient (LogP) < 5",
      br(),
      "3. Hydrogen bond donors < 5",
      br(),
      "4. Hydrogen bond acceptors < 10",
      br(),br(),
      "All of the active molecules were defined by having a standard IC50 value
      of less than 1000 nM (nano mol/L), and the inactive molecules having a 
      value greater than 10,000 nM.",
      br(), br(),
      "Half-maximal inhibitory concentration (IC50) is the most widely used 
        and informative measure of a drug's efficacy. It indicates how much drug 
        is needed to inhibit a biological process by half, thus providing a
        measure of potency of an antagonist drug in pharmacological research.",
      br(),br(),
      "Simply stated, pIC50 is the negative log of the IC50 value when converted to molar.
        This will give us a look at the IC50 values in a logrithmic sense."
      
      )
      
      
    ),
    
    #Body
    dashboardBody(
      
      
      tabsetPanel(
        # Data Table Tab
        tabPanel(
          "1) Target Selection",
          fluidRow(
            column(
              width = 6,
              dataTableOutput("target_search_results")
            ),
            column(
              width = 6,
              fluidRow(
                box(width = 12,
                    title = "Welcome to the Computational Drug Discovery Dashboard!", 
                    "STEP - 1: ",
                    "To begin, search for an intended target protein with the first search bar.",
                    br(),br(),
                    "STEP - 2: ",
                    "After You have found your selected target in the provided table, ",
                    "copy and paste the CHEMBL ID Number into the second search bar on the left.",
                    br(),br(),
                    "STEP - 3: ",
                    "After you have entered your desired CHEMBL ID, ",
                    "the number of Bioactive molecules will appear in the value box below.",
                    "Click the 'Download Data' to download your bioactivities as a .csv file",
                    br(),br(),
                    "You are then free to explore the Experimental Data Analysis (EDA) Tab,",
                    "which has information on the bioactive molecules that were found for your target.",
                    br(),br(),                              
                    "The Machine Learning Drug Discovery tab will provide insight into possible candidates",
                    "of molecuels to move forward with in your drug discovery research."
                    
                ),
                box(width = 12,
                    title = "Selected Target Bioactivity Data Table Information",
                    valueBoxOutput(width = 12, "bioactivities_box"),
                    downloadButton(width = 12, "download_data", "Download Data")
                )
              )
            )
          )
        ),
        # Statistical Data analysis on Lipinski Descriptors
        tabPanel(
          "2) EDA",
          fluidRow(
            column(
              width = 6,
              plotOutput('freq_graph')
            ),
            column(
              width = 6,
              plotOutput('logp_vs_mw_graph')
            )
          ),
          fluidRow(
            splitLayout(cellWidths = c('20%','20%','20%','20%','20%'),
                        plotOutput('box_1'),
                        plotOutput('box_2'),
                        plotOutput('box_3'),
                        plotOutput('box_4'),
                        plotOutput('box_5')
            )
          ),
          fluidRow(
            dataTableOutput("mann_whitney_table")
          )
        ),
        # ML model to predict different candidates for Drug Therapies
        tabPanel(
          "3) ML Drug Discovery",
          box(
            id = 'input_box',
            title = "Input: Possible New Drug Candidates for your Target",
            width = 12,
            fluidRow(
              column(
                width = 7,
                
                "If you are interested in checking out more molecules that are not included",
                "in the bioactivites list, you can input them here ",
                "Please Input .csv file containing up to 10 candidates for a new drug therapy.",
                "The ML algorithm will predict a pIC50 value for your choices.",
                "Input format chould be in canonical_smile,chembl_id .csv form.",
                "Please see example below:",
                br()
                
                
                
              ),
              column(
                width = 5,
                
                fileInput(
                  inputId = 'df_bio_input',
                  label = "Choose File",
                  buttonLabel = "Browse...",
                  placeholder = "No file selected...",
                  accept = c(
                    "text/csv",
                    "text/comma-separated-values,text/plain",
                    ".csv")
                )
                
              )
            )
            
          ),
          
          
          div(tags$img(src = "test_input_img.png",
                       width = "700px",
                       height = "150px",
                       alt = "Something's Wrong",
                       deleteFile = FALSE
                      ),
              style = "text-align: center;"
          ),
          
          br(),br(),
          
          fluidRow(
            box(width = 12,
                title = "ML Model Target Selection",
                selectInput(
                  inputId = 'target_ml_model',
                  label = 'Choose a Target to Predict pIC50 Values For:',
                  choices = c('CHEMBL1966 - Dihydroorotate dehydrogenase')
                ),
                "Work in Progress - Will add option for selecting", 
                "other targets, For now I have provided an integrated",
                "ML Model based on the molecular fingerprint for",
                "CHEMBL1966 - Dihydroorotate dehydrogenase",
                "Inhibitors of this target protein are known to be a cure for",
                "Rheumatoid Arthritis and othe autoimmune diseases."
            )
          ),
          
          
          
          
          fluidRow(
            box(width = 12,
                title = "Output: Predicted pIC50 Values",
                tableOutput("predictedIC50")
            )
          )
        )
      )
    )
    
  )
)



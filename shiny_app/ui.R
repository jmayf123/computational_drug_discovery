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
    skin = 'green',
    
    #App title 
    dashboardHeader(
      title = "Computational Drug Discovery Dashboard",
      titleWidth = 450
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
      
   
      p("Christopher Lipinski, a scientist at Pfizer, came up with a set of 
      rule-of-thumb for evaluating the druglikeness of compounds. Such druglikeness 
      is based on the Absorption, Distribution, Metabolism and Excretion (ADME) 
      that is also known as the pharmacokinetic profile. Lipinski analyzed all 
      orally active FDA-approved drugs in the formulation of what is to be known 
      as the Rule-of-Five or Lipinski's Rule.", 
      style = "font-family: 'times'; font-si16pt"),
      
      p("The Lipinski's Rule stated the following:",
        style = "font-family: 'times'; font-si16pt"),
      
      p("1. Molecular weight < 500 Dalton",
        style = "font-family: 'times'; font-si16pt"),
      
      p("2. Octanol-water partition coefficient (LogP) < 5",
        style = "font-family: 'times'; font-si16pt"),
      
      p("3. Hydrogen bond donors < 5",
        style = "font-family: 'times'; font-si16pt"),
      
      p("4. Hydrogen bond acceptors < 10",
        style = "font-family: 'times'; font-si16pt"),
      
      p("Half-maximal inhibitory concentration (IC50) is the most widely used 
        and informative measure of a drug's efficacy. It indicates how much drug 
        is needed to inhibit a biological process by half, thus providing a
        measure of potency of an antagonist drug in pharmacological research.",
        style = "font-family: 'times'; font-si16pt"),
      
      p("Simply stated, pIC50 is the negative log of the IC50 value when converted to molar.
        This will give us a look at the IC50 values in a logrithmic sense.",
        style = "font-family: 'times'; font-si16pt")
      
      
      
    ),
    
    #Body
    dashboardBody(

      tabsetPanel(
        # Data Table Tab
        tabPanel("1) Target Selection",
                 fluidRow(
                   column(
                     width = 12,
                     dataTableOutput("target_search_results")
                   ),
                   column(
                     width = 12,
                     valueBoxOutput("bioactivities_box")
                   )
                 )
        ),
        # Statistical Data analysis on Lipinski Descriptors
        tabPanel("2) EDA",
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
        tabPanel("3) ML Drug Discovery")
      )
    )
    
  )
)



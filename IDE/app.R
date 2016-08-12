library(shiny)
library(haven)
library(data.table)

table_stock <- read_sas(paste0(getwd(),"/Data_IDE/stocks_dgtpe_00_15_20160628.sas7bdat"))
table_stock <- dplyr::select(table_stock,-1:-4,-6,-7,-9,-10,-12,-13,-15)
#crée les character pour la selection 
pays <- unique(table_stock$ZONE_GEO_CPIE_VF)
operation <- unique(table_stock$TYPE_OPERATION_VF)
annee <- unique(table_stock$ANNEE)
secteur <- unique(table_stock$SECTEUR_ACTIVITE_VF)

#Interface utilisateur
ui <- shinyUI(fluidPage(
   
   # Titre
   titlePanel("Données IDE - Banque de France"),
   
   # Barre de selection des données 
   sidebarLayout(
      sidebarPanel(
         selectInput(
           "Pays","Pays partenaire",pays
         ),
         selectInput(
           "Operation","Flux",operation
         ),
         selectInput(
           "Annee","Année",c("All",annee)
         ),
         selectInput(
           "Secteur","Secteur",c("All",secteur)
         )
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        DT::dataTableOutput("table")
      )
   )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {

  
  output$table <- DT::renderDataTable(DT::datatable({
    data <- table_stock
    if (input$Pays != "All") {
      data <- data[data$ZONE_GEO_CPIE_VF == input$Pays,]
    }
    if (input$Operation != "All") {
      data <- data[data$TYPE_OPERATION_VF == input$Operation,]
    }
    if (input$Annee != "All") {
      data <- data[data$ANNEE == input$Annee,]
    }
    if (input$Secteur != "All") {
      data <- data[data$SECTEUR_ACTIVITE_VF == input$Secteur,]
    }
    data
  }))
})

# Run the application 
shinyApp(ui = ui, server = server)


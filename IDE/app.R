library(shiny)
library(haven)
library(data.table)

table_stock <- fread(paste0(getwd(),"/Data_IDE/table_stock.csv"), stringsAsFactors = FALSE, drop = 1)

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
      
      # Tableau comme élément principal de la page
      mainPanel(
        DT::dataTableOutput("table")
      )
   )
))

# Cote serveur
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

# Lance l'application 
shinyApp(ui = ui, server = server)



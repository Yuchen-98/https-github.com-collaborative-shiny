library(dplyr)
library(shiny)
library(shiny.collections)

ui <- fluidPage(
  titlePanel("flip together app"),
  
  
  sidebarLayout(
    
    sidebarPanel(
  
      textInput("uname","Username", width="200px"),
      actionButton("heads","Heads"),
      actionButton("tails","Tails"),
      actionButton("reset","Reset")
      
    ),
    
    mainPanel(
      plotOutput("fliphist"),
      # DT::dataTableOutput("flipdata")
      
    )
  )
  
  
  
)

connection <- shiny.collections::connect(host="localhost", db_name = "shiny")


server <- function(input, output, session) {
  
  
  messages <- shiny.collections::collection("messages", connection)
  flips <- shiny.collections::collection("flips", connection)
  

  observeEvent(input$heads, {
    newflip <- list(user = input$uname,
                    text = "H")
    shiny.collections::insert(flips, newflip)
    # output$flipdata <- DT::renderDataTable(DT::datatable(flips$collection))
    
  })
  
  observeEvent(input$tails, {
    newflip <- list(user = input$uname,
                    text = "T")
    shiny.collections::insert(flips, newflip)
    # output$flipdata <- DT::renderDataTable(DT::datatable(flips$collection))
    
  })
  
  observeEvent(input$reset, {
    getallIDs <- flips$collection %>% select(id) %>% pull()
    for (id in getallIDs) {
      shiny.collections::delete(flips, id)
    } 
#    shiny.collections::insert(flips, newflip)
    # output$flipdata <- DT::renderDataTable(DT::datatable(flips$collection))
  })

    output$fliphist <- renderPlot({
    # if (!is_empty(flips$collection)) {
      flips$collection %>% select(text) %>% table() %>% barplot()
    # }
  })
  
}

shinyApp(ui, server)
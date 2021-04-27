






#first = c(1,2)
#second = c(3,4)
#third = c('moose','gnu')
#df = data.frame(first,second,third)
#df
#turtle_df
library(shiny)
library(ggplot2)  # for the diamonds dataset
library(readxl)


df7 = read_excel('/Users/Hutch/Desktop/turtle_chart3.xlsx',
col_names=c("name","scientific name","weight","length","longevity","food","fun facts","nesting","geography","migration"),skip = 1)

df6 = read_excel('/Users/Hutch/Desktop/turtle_chart3.xlsx', skip = 1)

Turtles = df6
ui <- fluidPage(
  title = "Examples of DataTables",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "Turtles"',
        checkboxGroupInput("show_vars", "Choose information to show:",
                           names(Turtles), selected = names(Turtles))
      )
      
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("Turtles", DT::dataTableOutput("mytable1"))
        
      
      )
    )
  )
)

server <- function(input, output) {
  
  # choose columns to display

  output$mytable1 <- DT::renderDataTable({
    DT::datatable(Turtles[, input$show_vars, drop = FALSE])
  })
  
}

shinyApp(ui, server)

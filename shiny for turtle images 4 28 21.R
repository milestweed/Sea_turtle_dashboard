library(shiny)

library(magick)

library(shiny)
library(ggplot2)

ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
    
      selectInput(
        inputId = "turt",
        label = "Choose a species of turtle:",
        choices = list("Loggerhead"= 5, "Green turtle"= 1, "Leatherback" = 4, "Hawksbill" = 2,
        "Kemp’s ridley" = 3,"Olive ridley" = 6 )
      )
    ),
    mainPanel(
      plotOutput("turt_image")
    )
  )
  
)

server <- function(input, output) {
  output$turt_image <- renderPlot({
    x = input$turt
    all = list.files(path = "./t_image", pattern = ".jpg", full.names = T)
  
    if (input$turt==1){x = 1}
    if (input$turt==2){x = 2}
    if (input$turt==3){x = 3}
    if (input$turt==4){x = 4}
    if (input$turt==5){x = 5}
    if (input$turt==6){x = 6}
    
    
    #logo = image_read("/Users/Hutch/Desktop/t_image/olive.jpg")
    logo = image_read(all[x])
    # Plot image with ggplot2
    library(ggplot2)
    myplot <- image_ggplot(logo)
    myplot + ggtitle("photo courtesy of NOAA")
  
  })
  
}

shinyApp(ui = ui, server = server)


#https://rdrr.io/cran/magick/man/image_ggplot.html

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(plotly)
library(DT)


dashboardPage(
  
  dashboardHeader(title = "Sea Turtle Tracking"),
  
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Basic Info", tabName = 'info', icon = icon("book")),
      menuItem("Regional Plots", tabName = 'region', icon = icon("globe-americas")),
      menuItem("Individual Turtles", tabName = 'turtles', icon = icon('crosshairs'))
    )
    
  ),
  dashboardBody(
    tabItems(
        tabItem(tabName = 'info',
            column(width = 12,
                fluidRow(
                   box(checkboxGroupInput("show_vars", "Choose information to show:",
                                          names(Turtles), selected = names(Turtles))),
                   box(selectInput(
                     inputId = "turt",
                     label = "Choose a species of turtle:",
                     choices = list("Loggerhead"= 5, 
                                    "Green turtle"= 1, 
                                    "Leatherback" = 4, 
                                    "Hawksbill" = 2,
                                    "Kemp’s ridley" = 3,
                                    "Olive ridley" = 6 )),
                     plotOutput("turt_image")
                   )),
                fluidRow(
                  box(DT::dataTableOutput("mytable1"))
                ))),
        
        tabItem(tabName = 'region',
                 fluidRow(
                   box(title = "Sea Turtle Paths By Region",
                       selectInput(inputId = "location",
                                   label = "Select a region:",
                                   choices = locations$location),
                       plotlyOutput('regionPlot'))
                 )),
        
        tabItem(tabName = 'turtles', 
                fluidRow(
                  box(title = "Individual Sea Turtle Paths",
                    selectInput(inputId = 'type',
                                label = 'Select a type:',
                                choices = unique(animals$vernacularName)),
                    selectInput(inputId = "turtle",
                                label = "Select a Turtle:",
                                choices = NULL)),
                  plotlyOutput("indivPlot")))
      )
    )
)
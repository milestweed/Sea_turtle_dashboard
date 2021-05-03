#getwd()

#setwd('/Users/Hutch/Desktop/vprog')

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(plotly)
library(DT)
library(readxl)

df1 = read_excel('/Users/Hutch/Desktop/vprog/turtle_chart3.xlsx', col_names=c("name","scientific name","weight","length","longevity","food","fun facts","nesting","geography","migration"),skip = 2)
df2 = read_csv2('/Users/Hutch/Desktop/vprog/finalAnimals.csv')
df3 = read_csv2('/Users/Hutch/Desktop/vprog/locations.csv')

Turtles = df1
locations = df3
animals = df2


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
              
                     fluidRow(
                      column(width = 6,
                       box(checkboxGroupInput("show_vars", "Choose up to 4 info categories:",
                                              names(Turtles), selected = 'name')),
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
              column(width = 6,
                box(title = "Sea Turtle Paths By Region",
                    selectInput(inputId = "location",
                                label = "Select a region:",
                                choices = locations$location),
                    plotlyOutput('regionPlot'))
              ))),
      
      tabItem(tabName = 'turtles', 
              column(width = 4,
              fluidRow(
                box(title = "Individual Sea Turtle Paths",
                    selectInput(inputId = 'type',
                                label = 'Select a type:',
                                choices = unique(animals$vernacularName)),
                    selectInput(inputId = "turtle",
                                label = "Select a Turtle:",
                                choices = NULL)),
                plotlyOutput("indivPlot"))))
    )
  )
)
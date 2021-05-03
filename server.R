library(shiny)
library(tidyverse)
library(lubridate)
library(slider)
library(magick)
library(readxl)
library(tsibble)
library(ggplot2)
library(plotly)
library(shinydashboard)
library(DT)

shinyServer(function(input, output, session){
  
  
  output$turt_image <- renderPlot({
    x = input$turt
    all = list.files(path = "./t_image", pattern = ".jpg", full.names = T)
    
    if (input$turt==1){x = 1}
    if (input$turt==2){x = 2}
    if (input$turt==3){x = 3}
    if (input$turt==4){x = 4}
    if (input$turt==5){x = 5}
    if (input$turt==6){x = 6}
    
    
    logo = image_read(all[x])
    # Plot image with ggplot2
    library(ggplot2)
    myplot <- image_ggplot(logo)
    myplot + ggtitle("photo courtesy of NOAA")
    
  })
  
  
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(Turtles[, input$show_vars, drop = FALSE])
  })
  
  
  loc <- reactive({locations %>% filter(location==input$location)})
  
  df.region <-  reactive({animals %>% 
      filter(locationName == input$location) %>%  
      as_tsibble(key = eventDate, index = index)%>% 
      mutate(sevenDayAvgLat = slide_index_dbl(.x = decimalLatitude,
                                              .i = eventDate,
                                              .f = mean,
                                              .before = 6),
             sevenDayAvgLon = slide_index_dbl(.x = decimalLongitude,
                                              .i = eventDate,
                                              .f = mean,
                                              .before = 6))})
  
  output$regionPlot <- renderPlotly({
    center = loc()
    plotdf <- df.region()
    p <- plot_ly(
      data = plotdf,
      type = "scattermapbox",
      mode = "markers",
      lat = ~sevenDayAvgLat,
      lon = ~sevenDayAvgLon,
      legendgroup = ~vernacularName,
      color = ~vernacularName,
      marker = list(opacity = 0.5),
      hovertemplate = paste("<b>Event Date:</b>", plotdf$eventDate, "<br>",
                            "<b>Vernacular Name:</b>", plotdf$vernacularName, "<br>",
                            "<b>Organism ID:</b>", plotdf$organismID,"<br>",
                            "<extra></extra>"))
    
    
    p <- p %>%  layout(legend = list(traceorder = 'grouped'),
                       autosize=FALSE,
                       mapbox= list(
                         style = "white-bg",
                         bearing=0,
                         zoom = center$zoom,
                         center = list(lon = center$lons ,
                                       lat = center$lats),
                         layers = list(list(
                           below = 'traces',
                           sourcetype = "raster",
                           source = list("https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}")))),
                       margin = list(t=0, r=0, l=0, b=0)) %>% 
      config(displayModeBar = FALSE)
  })
  
  
  observe({
    choices <- animals %>% filter(vernacularName == input$type) %>% select(organismID)
    updateSelectInput(session, inputId = 'turtle', choices = choices)
  })
  
  df.indiv <-  reactive({if(!is.na(input$turtle)){animals %>% 
      filter(organismID == input$turtle) %>%  
      as_tsibble(key = eventDate, index = index)%>% 
      mutate(sevenDayAvgLat = slide_index_dbl(.x = decimalLatitude,
                                              .i = eventDate,
                                              .f = mean,
                                              .before = 6),
             sevenDayAvgLon = slide_index_dbl(.x = decimalLongitude,
                                              .i = eventDate,
                                              .f = mean,
                                              .before = 6))}
    else{animals %>%  
        as_tsibble(key = eventDate, index = index)%>% 
        mutate(sevenDayAvgLat = slide_index_dbl(.x = decimalLatitude,
                                                .i = eventDate,
                                                .f = mean,
                                                .before = 6),
               sevenDayAvgLon = slide_index_dbl(.x = decimalLongitude,
                                                .i = eventDate,
                                                .f = mean,
                                                .before = 6))}
    
  })
  
  output$indivPlot <- renderPlotly({
    
    plotdf <- df.indiv()
    plot_ly(data = plotdf,
            type = "scattermapbox",
            mode = "markers+lines",
            lat = ~sevenDayAvgLat,
            lon = ~sevenDayAvgLon,
            color = ~vernacularName,
            hovertemplate = paste("<b>Event Date:</b>", plotdf$eventDate, "<br>",
                                  "<b>Vernacular Name:</b>", plotdf$vernacularName, "<br>",
                                  "<b>Organism ID:</b>", plotdf$organismID,"<br>",
                                  "<extra></extra>"),
            hoverlabel = list(align = "left")) %>% 
      layout(legend = list(traceorder = 'grouped'),
             autosize=FALSE,
             mapbox= list(
               style = "white-bg",
               bearing=0,
               zoom = 3,
               center = list(lon = mean(plotdf$decimalLongitude) ,
                             lat = mean(plotdf$decimalLatitude)),
               layers = list(list(
                 below = 'traces',
                 sourcetype = "raster",
                 source = list("https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}")))),
             margin = list(t=0, r=0, l=0, b=0))
  })
  
  
})
## Packages Needed to be installed
# install.packages('leaflet')
# install.packages('magrittr')
# install.packages('sf')
# install.packages('geojsonio')
# install.packages('htmltools')
# install.packages('htmlwidgets')
# install.packages('stringi')
# install.packages('RColorBrewer')
# install.packages('shinyWidgets')

## Library of installed packages
library(leaflet)
library(magrittr)
library(sf)
library(geojsonio)
library(htmltools)
library(htmlwidgets)
library(stringi)
library(RColorBrewer)
library(shiny)
library(shinyWidgets)

# initializing a map widget
# Here you will have a map with no geographic features
m <- leaflet()

# I read the shape file of vancouver's local-area-boundary
vancouver <- read_sf('~/Desktop/local-area-boundary/local-area-boundary.shp')

# Census Data (statistical data)
census_all <- read.csv('~/Desktop/Census_all_flip.csv')
census_all_un <- read.csv('~/Desktop/Census_all.csv')
  
  
#
is.element(census_all$name, vancouver$name) %>%
  all()

# Merging vancouver with census data back into vancouver
vancouver <- merge(vancouver, census_all, by = 'name', all.x = F)

paletteNum <- colorNumeric('Blues', domain = NULL)


# Labeling

vancouverLabels <- sprintf('<b>%s</b><br/>%g people',
                           vancouver$name, vancouver$X0.to.14.years) %>%
  lapply(function(x) HTML(x))

vancouver <- cbind(vancouver, matrix(vancouverLabels, ncol = 1, dimnames = list(c(), c('vancouverLabels'))))


# Integrating Leaflet with Shiny
ui <- fluidPage(
  
  # Title
  titlePanel("Census Data"),
  
  #Leaflet Map
  leafletOutput("mymap"),
  
  absolutePanel(
    pickerInput(
      inputId = "agegroup",
      label = "Select an Age Group",
      choices = unique(census_all_un$name)),
  )

  
  )

server <- function(input, output, session) {
  
  ## (SOMETHING WRONG HERE) !!
  filteredDataUpdate <- reactive({
    vancouver[input$agegroup,]
  })
  
  ## (SOMETHING WRONG HERE) !!
  # # This reactive expression represents the palette function,
  # # which changes as the user makes selections in UI.
  # # If you uncomment paletteNum below, my map won't show up (error)
  
  # paletteNum <- reactive({
  #   colorNumeric('blues', vancouver[input$agegroup,])
  # })
  
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.PositronNoLabels) %>% 
      setView(lng = -123.11934, lat = 49.24966, zoom = 11) %>% 
      addPolygons(data = vancouver,
                  color = 'white',
                  weight = 1,
                  smoothFactor = .3,
                  fillOpacity = .75,
                  fillColor = ~paletteNum(vancouver$X0.to.14.years),
                  label = ~vancouverLabels,
                  labelOptions = labelOptions(
                    style = list(color = 'gray30'),
                    textsize = '10px'),
                  highlightOptions = highlightOptions(
                    weight = 3,
                    color = 'dodgerblue'
                  )
      ) %>% 
      addLegend(pal = paletteNum, values = vancouver$X0.to.14.years,
                title = '<small>2016 Vancouver Census Data <br> Population: Ages 0 to 14 </small>',
                position = 'bottomleft')
  })
  
  ## (SOMETHING HAS TO BE ADDED HERE) !!
  # I believe it is leafletProxy() that will update: 
  # 1) fillColor in the addPolygons()
  # 2) values and title in the addLegend()
  
}

shinyApp(ui, server)

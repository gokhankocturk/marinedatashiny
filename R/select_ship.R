#' Module UI and SERVER functions
#'
#' @param id
#'
#' @return
#' @export
#'
#' @import data.table dplyr forcats geosphere ggplot2 leaflet lubridate readr shiny shiny.semantic shinydashboard semantic.dashboard

# Creating module UI
selectUI <- function(id) {
  ns <- NS(id)
  tagList(
    segment(
      style = "border-bottom: 2px solid red; background-color: lightblue; color: #828282; text-align: center;",
      h3("Ship Type & Name Selection", style = "color:black; font-weight: bold;"),
      br(),
      width = 12,
      div(shiny::selectInput(ns("vessel_type"), "Select vessel type:", choices = sort(unique(ships$ship_type))), style = "color: white; background-color: #3198C4;"),
      br(),
      div(shiny::selectInput(ns("vessel_name"), "Select a vessel: ", choices = sort(unique(ships$SHIPNAME))), style = "color: white; background-color: #3198C4;")
    )
  )
}

# Creating module SERVER
selectSERVER <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 ships$DATETIME <- as.POSIXct(ships$DATETIME)
                 ships$date <- as.POSIXct(ships$date)

                 data <- reactive({
                   ships %>%
                     filter(ship_type == input$vessel_type) %>%
                     mutate(distance = distHaversine(cbind(LON, LAT),
                                                     cbind(lead(LON, 1), lead(LAT, 1))))
                 }
                 )

                 observeEvent(input$vessel_type,
                              shiny.semantic::updateSelectInput(session,
                                                                "vessel_name",
                                                                choices = sort(unique(data()$SHIPNAME)),
                                                                selected = sort(unique(data()$SHIPNAME))[1]
                              )
                 )

                 send_out <- list(
                   datasend = reactive({data()}),
                   namesend = reactive({input$vessel_name}),
                   typesend = reactive({input$vessel_type})
                 )

                 return(send_out)

               })
}

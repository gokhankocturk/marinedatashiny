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
      h3("Ship Type & Name Selection"),
      width = 12,
      shiny.semantic::selectInput(ns("vessel_type"), "Select vessel type:", choices = sort(unique(ships$ship_type))),
      shiny.semantic::selectInput(ns("vessel_name"), "Select a vessel: ", choices = sort(unique(ships$SHIPNAME)))
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
                                                     cbind(lag(LON), lag(LAT))))
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

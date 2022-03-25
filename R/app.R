#' Main UI and SERVER functions
#'
#' @param ...
#'
#' @return
#' @export
#'
#' @import data.table dplyr forcats geosphere ggplot2 leaflet lubridate readr shiny shiny.semantic shinydashboard semantic.dashboard


marineshinyapp <- function(...) {

  #############################################################################
  # Defining CSS for ship_text and shipname_text outputs.
  #############################################################################
  CSS <- "
  #ship_text {color:#96CDCD; font-weight: 900; font-size:24px; font-family:papyrus; text-align:center; border-bottom: 2px solid teal;}
  #shipname_text {color:#FF7F50; font-weight: bold; font-size:24px; font-family:papyrus; text-align:center; border-bottom: 2px solid #8B3E2F;}
  "

  ############################################################################
  # Defining layout for app
  ############################################################################
  sidebar <- shiny.semantic::sidebar_layout(
    shiny.semantic::sidebar_panel(
      width = 3,
      div(
        style = "position: relative; height: 500px",
        selectUI("select_vessel"),
        div(
          style = "position: absolute; bottom: 0px; left: 0px; right: 0px",
          cards(
            class = "one",
            card(
              div(class = "content",
                  style = "background-color:lightblue; border-bottom: 2px solid red;",
                  div(class = "header", "Gokhan KOCTURK"),
                  div(class = "meta", "R / Shiny Developer"),
                  div(class = "description", "South America Team")
              )
            )
          )
        )
      )
    ),

    main_panel(
      width = 9,
      tabset(
        tabs = list(
          list(
            menu = "1. Map",
            content = list(
              h2("Longest Distance Between Two Consecutive Moves", style = "color: #2F4F4F; text-shadow: 2px 2px 4px black; border-bottom: 2px solid red; font-family:Avant Garde; text-align: center;"),
              leafletOutput("map")
            ),
            id = "first_tab"
          ),
          list(
            menu = "2. Statistics",
            content = list(
              split_layout(
                segment(
                  textOutput("ship_text"),
                  br(),
                  br(),
                  semantic.dashboard::infoBoxOutput("ship1"),
                  br(),
                  br(),
                  semantic.dashboard::infoBoxOutput("ship2")
                ),
                segment(
                  textOutput("shipname_text"),
                  br(),
                  br(),
                  semantic.dashboard::infoBoxOutput("shipname1"),
                  br(),
                  br(),
                  semantic.dashboard::infoBoxOutput("shipname2")
                )
              )
            ),
            id = "second_tab"
          ),
          list(
            menu = "3. Graphs",
            content = list(
              plotOutput("top_speed")
            )
          )
        ),
        active = "third_tab"
      )
    )
  )

  ############################################################################
  # Defining UI
  ############################################################################
  ui <- semanticPage(tags$style(CSS),
                     theme = "readable",
                     h2("APPSILON", br(), "(Assignment - Marine Data)", style = "color: white; text-shadow: 1px 1px 2px black; font-family: Avant Garde; background-color: #4169E1;  border-bottom: 2px solid red; position: relative; width: 1500px; text-align: center;"),
                     sidebar)

  ############################################################################
  # Defining main SERVER
  ############################################################################
  server <- function(input, output, session) {
    getdata <- selectSERVER("select_vessel")

    # Creating reactive "data_final" dataset to use for map. It will have two rows.
    # One for starting point, one for ending point.
    data_final <- eventReactive(getdata$namesend(), {
      data_draft <- getdata$datasend() %>%
        arrange(DATETIME) %>%
        filter(ship_type == getdata$typesend() & SHIPNAME == getdata$namesend()) %>%
        mutate(id = row_number(), distance = distHaversine(cbind(LON, LAT),
                                                           cbind(lead(LON, 1), lead(LAT, 1))))

      data_draft <- data_draft %>% relocate(id)

      data_top <- data_draft %>% filter(distance == max(distance, na.rm = TRUE))

      if(nrow(data_top) > 1) {
        data_top <- data_top %>% slice(which.max(DATETIME))
      }

      actual_row <- data_top$id
      data_final <- data_draft[(actual_row - 1):actual_row, ]
      data_final
    })

    # Creating map, using "data_final()" reactive dataset.
    output$map <- renderLeaflet({
      data_final() %>%
        leaflet() %>%
        addTiles() %>%
        addCircleMarkers(
          popup = ~ DATETIME,
          fillColor = "yellow",
          color = "red",
          weight = 1
        ) %>%
        addPolylines(lng = ~ LON, lat = ~ LAT) %>%
        addProviderTiles(
          "OpenStreetMap",
          group = "OpenStreetMap"
        ) %>%
        addProviderTiles(
          "CartoDB.Positron",
          group = "CartoDB.Positron"
        ) %>%
        addProviderTiles(
          "Esri.WorldImagery",
          group = "Esri.WorldImagery"
        ) %>%
        addLayersControl(
          baseGroups = c(
            "OpenStreetMap", "CartoDB.Positron", "Esri.WorldImagery"
          ),
          position = "topleft"
        ) %>%
        addAwesomeMarkers(
          lat = data_final()$LAT[1],
          lng = data_final()$LON[1],
          label = "Start point",
          icon = makeAwesomeIcon(
            icon = "flag",
            markerColor = "green",
            iconColor = "black"
          )
        ) %>%
        addAwesomeMarkers(
          lat = data_final()$LAT[2],
          lng = data_final()$LON[2],
          label = "End point",
          icon = makeAwesomeIcon(
            icon = "flag",
            markerColor = "red",
            iconColor = "black"
          )
        ) %>%
        addLegend(
          colors = "blue",
          labels = "Longest Distance",
          title = "Vessel Movement",
          opacity = 1,
          position = "bottomleft"
        ) %>%
        addPopups(lng = ~ mean(LON),
                  lat = ~ mean(LAT),
                  popup =  ~ paste0("Ship: ", getdata$namesend(), br(),
                                    "The distance is: ",
                                    as.character(format(round(max(distance), 0), big.mark = ".", decimal.mark = " ")),
                                    " meters", br(),
                                    "The speed is: ", as.character(SPEED) , " knots"))
    })

    # Creating reactive "data_graph" dataset to use for graph. It will have 5 rows,
    # representing the top 5 fastest ships in selected ship type.
    data_graph <- reactive({
      data_draft <- getdata$datasend()

      data_draft <- data_draft %>%
        filter(is_parked == 0) %>%
        group_by(SHIPNAME) %>%
        summarize(avg_speed = mean(SPEED)) %>%
        arrange(desc(avg_speed)) %>%
        top_n(5)
    }
    )

    # Creating graph, using reactive "data_graph" dataset.
    output$top_speed <- renderPlot({
      data_graph <- data_graph()
      ggplot(data_graph, aes(x = avg_speed, y = fct_reorder(factor(SHIPNAME), avg_speed), fill = SHIPNAME, label = round(avg_speed, 1))) +
        geom_col() +
        geom_text(position = position_dodge(width = 0.8), vjust = -0.25, hjust = 1, colour = "black", size = 6) +
        scale_fill_brewer(palette = "Set1", guide = FALSE) +
        theme(
          plot.title = element_text(face = "bold", size = 20, colour = "#708090", hjust = 0.5 ),
          legend.position = "right",
          axis.text.x = element_blank(),
          axis.text.y = element_text(colour = "brown", size = 12),
          panel.background = element_rect(fill = "#FAF0E6"),
          panel.grid.major = element_blank(),
          axis.line = element_line(colour = "green"),
          axis.title.x = element_text(colour = "brown", size = 12),
          axis.ticks = element_blank()
        ) +
        labs(title = "Fastest Ships (top 5)", x = "Average Speed (in knots)", y = NULL, caption = "Appsilon Marine Data") +
        NULL
    })

    # Sending the selected ship type to "ship_text" output
    output$ship_text <- renderText({
      paste0("Ship Type: ", getdata$typesend())
    })

    # Sending the selected ship name to "shipname_text" output
    output$shipname_text <- renderText({
      paste0("Ship Name: ", getdata$namesend())
    })

    # Creating infoBox, giving information about the average distance for selected ship type.
    output$ship1 <- renderInfoBox({
      data_ship_type <- getdata$datasend()
      data_ship_type <- data_ship_type %>%
        filter(is_parked == 0)

      avg_distance <- if_else(nrow(data_ship_type) == 0, "All Ships are parked.", as.character(round(mean(data_ship_type$distance, na.rm = TRUE), 0)))

      semantic.dashboard::box(
        title = "Average distance per move (in meters)",
        color = "teal",
        title_side = "top left",
        ribbon = TRUE,
        collapsible = FALSE,
        semantic.dashboard::infoBox(
          subtitle = "",
          value = avg_distance,
          icon = icon("ship"),
          color = "teal",
          size = "tiny"
        )
      )
    })

    # Creating infoBox, giving information about the average speed for selected ship type.
    output$ship2 <- renderInfoBox({
      data_ship_type <- getdata$datasend()
      data_ship_type <- data_ship_type %>%
        filter(is_parked == 0)

      avg_speed <- if_else(nrow(data_ship_type) == 0, "All Ships are parked.", as.character(round(mean(data_ship_type$SPEED, na.rm = TRUE), 0)))

      semantic.dashboard::box(
        title = "Average speed per move (in knots)",
        color = "teal",
        title_side = "top left",
        ribbon = TRUE,
        collapsible = FALSE,
        semantic.dashboard::infoBox(
          subtitle = "",
          value = tolower(avg_speed),
          icon = icon("ship"),
          color = "teal",
          size = "tiny"
        )
      )
    })

    # Creating infoBox, giving information about the average distance for selected ship name
    output$shipname1 <- renderInfoBox({
      data_ship_type <- getdata$datasend()
      data_ship_type <- data_ship_type %>%
        filter(is_parked == 0 & SHIPNAME == getdata$namesend())

      avg_distance <- if_else(nrow(data_ship_type) == 0, "Ship is parked.", as.character(round(mean(data_ship_type$distance, na.rm = TRUE), 0)))

      semantic.dashboard::box(
        title = "Average distance per move (in meters)",
        color = "orange",
        title_side = "top left",
        ribbon = TRUE,
        collapsible = FALSE,
        semantic.dashboard::infoBox(
          subtitle = "",
          value = avg_distance,
          icon = icon("ship"),
          color = "orange",
          size = "tiny"
        )
      )
    })

    # Creating infoBox, giving information about the average speed for selected ship name
    output$shipname2 <- renderInfoBox({
      data_ship_type <- getdata$datasend()
      data_ship_type <- data_ship_type %>%
        filter(is_parked == 0 & SHIPNAME == getdata$namesend())

      avg_speed <- if_else(nrow(data_ship_type) == 0, "Ship is parked.", as.character(round(mean(data_ship_type$SPEED, na.rm = TRUE), 0)))

      semantic.dashboard::box(
        title = "Average speed per move (in knots)",
        color = "orange",
        title_side = "top left",
        ribbon = TRUE,
        collapsible = FALSE,
        semantic.dashboard::infoBox(
          subtitle = "",
          value = avg_speed,
          icon = icon("ship"),
          color = "orange",
          size = "tiny"
        )
      )
    })
  }

  shinyApp(ui, server, ...)
}

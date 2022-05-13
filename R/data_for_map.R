data_for_map <- function(data, type, name) {
  data_draft <- data
  if({{type}} %in% unique(data_draft$ship_type) && {{name}} %in% unique(data_draft$SHIPNAME)) {
    data_draft <- data_draft %>%
      filter(ship_type == {{type}}, SHIPNAME == {{name}}) %>%
      mutate(distance = distHaversine(cbind(LON, LAT),
                                      cbind(lead(LON, 1), lag(LAT, 1))),
             id = row_number())

    data_top <- data_draft %>% filter(distance == max(distance, na.rm = TRUE))

    if(nrow(data_top) > 1) {
      data_top <- data_top %>% slice(which.max(DATETIME))
    }

    actual_row <- data_top$id
    data_final <- data_draft[(actual_row - 1):actual_row, ]
    nrow(data_final)
  } else
    stop("Ship type or name does not exist in the data.")
}

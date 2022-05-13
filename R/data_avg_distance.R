data_avg_distance <- function(data, type, name, is_parked) {
  df1 <- data %>%
    arrange(DATETIME) %>%
    filter(ship_type == {{type}} & SHIPNAME == {{name}} & is_parked == is_parked) %>%
    mutate(distance = distHaversine(cbind(LON, LAT),
                                    cbind(lead(LON, 1), lead(LAT, 1))))

  avg_distance <- round(max(df1$distance, na.rm = TRUE))
  avg_distance
}

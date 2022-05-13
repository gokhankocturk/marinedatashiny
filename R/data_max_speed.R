data_max_speed <- function(data, type, name, is_parked) {
  df1 <- data %>%
    filter(ship_type == {{type}} & SHIPNAME == {{name}} & is_parked == is_parked)
  avg_speed <- round(max(df1$SPEED, na.rm = TRUE))
  avg_speed
}

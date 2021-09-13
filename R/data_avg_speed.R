data_avg_speed <- function(data) {
  avg_speed <- if_else(nrow(data) == 0, "All Ships are parked.", as.character(round(mean(data$SPEED, na.rm = TRUE), 0)))
  avg_speed
}

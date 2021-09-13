data_avg_distance <- function(data) {
  avg_distance <- if_else(nrow(data) == 0, "All Ships are parked.", as.character(round(mean(data$distance, na.rm = TRUE), 0)))
  avg_distance
}

data_for_graph <- function(data, type) {
  data_draft <- data
  if({{type}} %in% unique(data_draft$ship_type)) {
    data_draft <- data_draft %>%
      filter(ship_type == {{type}}, is_parked == 0) %>%
      group_by(SHIPNAME) %>%
      summarize(avg_speed = mean(SPEED)) %>%
      arrange(desc(avg_speed)) %>%
      top_n(5)

    return(nrow(data_draft))
  } else
    stop("Ship type does not exist in the data.")
}

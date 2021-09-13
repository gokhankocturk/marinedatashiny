test_that("Check output average distance for infobox", {
  df1 <- ships %>%
    filter(ship_type == "Cargo" & is_parked == 0) %>%
    mutate(distance = distHaversine(cbind(LON, LAT),
                                    cbind(lag(LON), lag(LAT))))

  df2 <- ships %>% filter(ship_type == "Navigation" & is_parked == 0)

  expect_equal(data_avg_distance(df1), as.character(round(mean(df1$distance, na.rm = TRUE), 0)))
  expect_equal(data_avg_distance(df2), "All Ships are parked.")
})

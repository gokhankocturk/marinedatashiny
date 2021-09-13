test_that("Check output average speed for infobox", {
  df1 <- ships %>% filter(ship_type == "Cargo" & is_parked == 0)

  df2 <- ships %>% filter(ship_type == "Navigation" & is_parked == 0)

  expect_equal(data_avg_speed(df1), as.character(round(mean(df1$SPEED, na.rm = TRUE), 0)))
  expect_equal(data_avg_speed(df2), "All Ships are parked.")
})

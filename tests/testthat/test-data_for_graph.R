test_that("Check data created for graph", {
  df <- data.table(SPEED = sample(20:350, size = 10000, replace = TRUE),
                   is_parked = sample(0:1, size = 10000, replace = TRUE, prob = c(0.1, 0.9)),
                   ship_type = sample(unique(ships$ship_type), size = 10000, replace = TRUE),
                   SHIPNAME = sample(unique(ships$SHIPNAME), size = 10000, replace = TRUE)
  )

  expect_equal(data_for_graph(df, "Cargo"), 5)
  expect_equal(data_for_graph(df, "Tug"), 5)
  expect_equal(data_for_graph(df, "Tanker"), 5)
  expect_error(data_for_graph(df, "Invalid Type"), "Ship type does not exist in the data.")
})

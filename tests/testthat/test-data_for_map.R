test_that("Check data created for map", {
  df <- data.table(LON = sample(54.001:4.999, size = 1000, replace = TRUE),
                   LAT = sample(18.001:18.999, size = 1000, replace = TRUE),
                   ship_type = sample(c("Cargo", "Tanker", "Tug"), size = 1000, replace = TRUE),
                   SHIPNAME = sample(c("KAROLI", "IDUNA", "MERI", "BALTICO", "SUULA"),
                                     size = 1000, replace = TRUE),
                   DATETIME = sample(seq(as.Date('2016/01/01'), as.Date('2016/01/31'), by = "day"),
                                     size = 1000, replace = TRUE))

  expect_equal(data_for_map(df, "Cargo", "KAROLI"), 2)
  expect_equal(data_for_map(df, "Cargo", "IDUNA"), 2)
  expect_equal(data_for_map(df, "Tanker", "BALTICO"), 2)
  expect_error(data_for_map(df, "Invalid Type", "BALTICO"), "Ship type or name does not exist in the data.")
  expect_error(data_for_map(df, "Tug", "Invalid Name"), "Ship type or name does not exist in the data.")
})

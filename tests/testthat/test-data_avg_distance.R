test_that("Check output average distance for infobox", {

  expect_equal(data_avg_distance(ships, "Passenger", "GOTA"), 2324)
  expect_equal(data_avg_distance(ships, "Cargo", "ADELE"), 1640)
  expect_equal(data_avg_distance(ships, "Fishing", "LIZ"), 15)
  expect_equal(data_avg_distance(ships, "Tug", "BISON"), 2715)

})

test_that("Check output maximum speed for infobox", {

  expect_equal(data_avg_speed(ships, "Cargo", "ANGORA"), 115)
  expect_equal(data_avg_speed(ships, "Fishing", "GOTTSKAR"), 93)
  expect_equal(data_avg_speed(ships, "Passenger", "VIPAN"), 180)
  expect_equal(data_avg_speed(ships, "Tug", "VAKARIS"), 157)
  expect_equal(data_avg_speed(ships, "Tanker", "MOZART"), 132)

})

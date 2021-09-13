test_that("Check data sent from server module", {
  testServer(selectSERVER, {
    session$setInputs(vessel_type = "Cargo")
    dataset <- session$getReturned()

    data_check <- ships %>%
      filter(ship_type == "Cargo") %>%
      mutate(distance = distHaversine(cbind(LON, LAT),
                                      cbind(lag(LON), lag(LAT))))

    expect_equal(dataset$datasend(), data_check)
  })
})

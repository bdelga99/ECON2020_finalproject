test_that("This tests to make sure that the shape file is the proper format", {
  expect_s3_class(shp, "data.frame")
})
library(bdscale)

data(nyse)

context("forward")

test_that('holidays show up as NA', {
  holidays <- bd2t(as.Date(c('2015-07-04', '2015-01-19')), nyse)
  expect_equal(holidays, as.numeric(c(NA,NA)))
})

test_that('weekends show up as NA', {
  weekends <- bd2t(as.Date(c('2015-06-06', '2015-04-05')), nyse)
  expect_equal(weekends, as.numeric(c(NA,NA)))  
})
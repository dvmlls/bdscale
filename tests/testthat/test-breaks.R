library(bdscale)

data(nyse)

context("breaks")

test_that('week breaks', {
  range <- as.Date(c('2015-01-02', '2015-01-30'))
  
  f <- bd_breaks(nyse)()
  
  mondays <- f(range)
  
  expect_equal(mondays, as.Date(c('2015-01-05', '2015-01-12', '2015-01-20', '2015-01-26')))
})
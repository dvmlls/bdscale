yahoo <- function(args) {
  base <- 'http://real-chart.finance.yahoo.com/table.csv'
  csv <- read.csv(url(paste(base, args, sep='?')))
  
  sort(as.Date(csv$Date))
}

#' Get past trading days for NYSE using close prices of SPX
#' 
#' @return a vector of Date 
#' @export
#' 
get_nyse <- function() yahoo('s=%5EGSPC&d=9&e=8&f=2014&g=d&a=0&b=3&c=1950&ignore=.csv')
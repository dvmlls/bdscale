library(dplyr)
library(magrittr)
library(ggplot2)
library(scale_bd)
library(scales)

spx <- 'http://real-chart.finance.yahoo.com/table.csv?s=%5EGSPC&d=9&e=8&f=2014&g=d&a=0&b=3&c=1950&ignore=.csv'
nyse <- spx %>% url %>% read.csv %>% extract2('Date') %>% as.Date

set.seed(12345)
df <- data.frame(date=nyse, price=cumsum(rnorm(length(nyse))) + 100)

df %>% ggplot(aes(x=date, y=price)) + geom_step()
df %>% filter(date > as.Date('2014-08-01')) %>% ggplot(aes(x=date, y=price)) + geom_step()
df %>% filter(date > as.Date('2014-08-01')) %>% ggplot(aes(x=date, y=price)) + geom_step() + scale_x_bd(business.dates=nyse)
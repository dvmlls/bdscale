require(dplyr, quietly=T, warn.conflicts=F)
require(ggplot2, quietly=T)
require(scales)

nyse <- get_nyse()

set.seed(12345)
df <- data.frame(date=nyse, price=cumsum(rnorm(length(nyse))) + 100)

getwd()

df %>% filter(as.Date('2014-08-01') < date & date < as.Date('2014-10-08')) %>% 
  ggplot(aes(x=date, y=price)) + geom_step() + 
  ggtitle('calendar dates')

# ggsave(file='man/figures/calendar.PNG')

df %>% filter(as.Date('2014-08-01') < date & date < as.Date('2014-10-08')) %>% 
  ggplot(aes(x=date, y=price)) + geom_step() + scale_x_bd(business.dates=nyse) +
  ggtitle('business dates')

# ggsave(file='man/figures/business.PNG')

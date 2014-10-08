require(dplyr, quietly=TRUE, warn.conflicts=FALSE)
require(ggplot2, quietly=TRUE)
require(scales)

nyse <- get_nyse()

set.seed(12345)
df <- data.frame(date=nyse, price=cumsum(rnorm(length(nyse))) + 100)

df %>% filter(as.Date('2014-08-01') < date & date < as.Date('2014-10-08')) %>% 
  ggplot(aes(x=date, y=price)) + geom_step() + 
  theme(axis.title.x=element_blank(), axis.title.y=element_blank()) +
  ggtitle('calendar dates')

# ggsave(file='man/figures/calendar.PNG', width=5, height=2)

df %>% filter(as.Date('2014-08-01') < date & date < as.Date('2014-10-08')) %>% 
  ggplot(aes(x=date, y=price)) + geom_step() + scale_x_bd(business.dates=nyse) +
  theme(axis.title.x=element_blank(), axis.title.y=element_blank()) +
  ggtitle('business dates')

# ggsave(file='man/figures/business.PNG', width=5, height=2)

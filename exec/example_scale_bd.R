require(dplyr, quietly=TRUE, warn.conflicts=FALSE)
require(ggplot2, quietly=TRUE)
require(scales)

nyse <- get_nyse()

set.seed(12345)
df <- data.frame(date=nyse, price=cumsum(rnorm(length(nyse))) + 100)

plot <- df %>% filter(as.Date('2014-08-01') <= date & date <= as.Date('2014-10-08')) %>% 
  ggplot(aes(x=date, y=price)) + geom_step() + 
  theme(axis.title.x=element_blank(), axis.title.y=element_blank())

plot + ggtitle('calendar dates')

# ggsave(file='man/figures/calendar.PNG', width=6, height=2)

plot + scale_x_bd(business.dates=nyse, labels=date_format("%b '%y")) + ggtitle('business dates, month breaks')

# ggsave(file='man/figures/business.month.PNG', width=6, height=2)

plot + scale_x_bd(business.dates=nyse, max.major.breaks=10, labels=date_format('%b %d')) + 
  ggtitle('business dates, week breaks')

# ggsave(file='man/figures/business.week.PNG', width=6, height=2)

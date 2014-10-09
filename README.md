bdscale
========

Remove Weekends and Holidays From `ggplot2` Axes

### Find valid dates

Ask Yahoo Finance for S&P prices, use those as past NYSE trading dates:

```
nyse <- bdscale::get_nyse()
```

### Plot on standard calendar-day axis:

Create some fake prices, put them into a `data.frame` alongside the dates, and plot:

```
set.seed(12345)
df <- data.frame(date=nyse, price=cumsum(rnorm(length(nyse))) + 100)

library(dplyr)
library(ggplot2)

df %>% filter(as.Date('2014-08-01') < date & date < as.Date('2014-10-08')) %>% 
  ggplot(aes(x=date, y=price)) + geom_step() + 
  ggtitle('calendar dates')

```

Yields a graph with a large gap at the beginning of September, because Labor Day was on the 1st:

<img src='man/figures/calendar.PNG'>

### Plot on a business-day axis:

Plot against `scale_x_bd` instead:

```
df %>% filter(as.Date('2014-08-01') < date & date < as.Date('2014-10-08')) %>% 
  ggplot(aes(x=date, y=price)) + geom_step() + bdscale::scale_x_bd(business.dates=nyse) +
  ggtitle('business dates')
```

Removes weekends and holidays from the graph:

<img src='man/figures/business.PNG'>

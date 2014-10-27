bdscale
========

Remove Weekends and Holidays From `ggplot2` Axes

[![Build Status](https://travis-ci.org/dvmlls/bdscale.svg?branch=master)](https://travis-ci.org/dvmlls/bdscale)

### Find valid dates

Ask Yahoo Finance for S&P prices, use those as past NYSE trading dates. Then create some fake prices, put them into a `data.frame` alongside the dates:

```
nyse <- yahoo()
set.seed(12345)
df <- data.frame(date=nyse, price=cumsum(rnorm(length(nyse))) + 100)
```

### Plot on standard calendar-day axis:

Create a plot:

```
library(dplyr)
library(ggplot2)

plot <- df %>% filter(as.Date('2014-08-01') <= date & date <= as.Date('2014-10-08')) %>% 
  ggplot(aes(x=date, y=price)) + geom_step() + 
  theme(axis.title.x=element_blank(), axis.title.y=element_blank())
  
plot + ggtitle('calendar dates')

```

Note the large gap at the beginning of September, because Labor Day was on the 1st:

<img src='man/figures/calendar.PNG'>

### Plot on a business-day axis:

Plot against `scale_x_bd` instead:

```
plot + scale_x_bd(business.dates=nyse, labels=date_format("%b '%y")) + 
  ggtitle('business dates, month breaks')
```

Removes weekends and holidays from the graph:

<img src='man/figures/business.month.PNG'>

The major breaks are pretty far apart, on the first trading day of each month. 

It's a wide chart, tell it to use more breaks:

```
plot + scale_x_bd(business.dates=nyse, max.major.breaks=10, labels=date_format('%b %d')) + 
  ggtitle('business dates, week breaks')
```

Given that max, it determines it can put major breaks on the first trading day of the week, and minor breaks every day:

<img src='man/figures/business.week.PNG'>

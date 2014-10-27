#' Transform \code{Date}s into your business-date scale. 
#' 
#' @param dates a \code{Date} vector for which you want to transform each date into an
#'  integer \code{t} which is the number of business days after the first date in
#'  your \code{business.dates} vector
#' @param business.dates a vector of \code{Date} objects, sorted ascending
#' @return An integer vector where each element is the number of business days \code{t} 
#'  after the first date in your \code{business.dates} vector
#'  
#' @export
#' 
bd2t <- function(dates, business.dates) {
  result=match(dates, business.dates) - 1
  structure(as.numeric(result), names=names(dates))
}

t2bd <- function(ts, business.dates) {
  result=business.dates[pmin(pmax(round(ts, 0), 0) + 1, length(business.dates))]
  structure(result, class='Date')  
}

bd_trans <- function(business.dates, breaks=bd_breaks(business.dates)) {
  transform <- function(dates) bd2t(dates, business.dates)
  inverse <- function(ts) t2bd(ts, business.dates)
  
  trans_new('date', transform=transform, inverse=inverse, breaks=breaks, domain=range(business.dates))
}

scale_bd <- function(aesthetics, expand=waiver(), breaks, minor_breaks=waiver(), business.dates, ...) {  
  continuous_scale(aesthetics, 'date', identity, breaks=breaks, minor_breaks=minor_breaks, guide="none", 
                   expand=expand, trans=bd_trans(business.dates, breaks), ...)
}

#' Weekend and holiday ignoring position scale for a ggplot.
#' 
#' @param business.dates a vector of \code{Date} objects, sorted ascending
#' @param max.major.breaks maximum major breaks \code{\link{bd_breaks}} will return, default=5
#' @param max.minor.breaks maximum minor breaks \code{\link{bd_breaks}} will return, default=major*5
#' @param breaks a function \code{max => [date range] => breaks}
#' @param ... other arguments passed to \code{\link[ggplot2]{continuous_scale}}
#' 
#' @export
#' @import ggplot2 scales
#' @example exec/example_scale_bd.R
#' 
scale_x_bd <- function(..., business.dates, max.major.breaks=5, max.minor.breaks=max.major.breaks*5, breaks=bd_breaks(business.dates)) {
  
  scale_bd(c("x", "xmin", "xmax", "xend"), expand=waiver(), 
           breaks=breaks(max.major.breaks), minor_breaks=breaks(max.minor.breaks), 
           business.dates=business.dates, ...)
}

epoch <- as.Date('1970-01-01')
quarter <- function(date) ceiling(as.integer(format(date, '%m')) / 3)
quarter_format <- function(date) sprintf("Q%s '%s", quarter(date), format(date, '%y'))
last_monday <- function(date) as.Date(as.integer(date) - as.integer(format(date, '%u')) + 1, origin=epoch)

firstInGroup <- function(dates, f.group) {
  group <- f.group(dates)
  grouped <- split(dates, factor(group))
  result <- sapply(grouped, function(l) l[[1]])
  as.Date(result, origin=epoch)
}

#' Date breaks corresponding to the first trading day of standard periods
#' 
#' The periods are:
#' \itemize{
#'  \item years
#'  \item quarters
#'  \item months
#'  \item weeks
#'  \item days
#' }
#' 
#' @return returns a function function: \code{max => [date range] => breaks} that generates the breaks 
#'         for the interval with the largest number of breaks less than \code{n.max}
#' @param business.dates a vector of \code{Date} objects, sorted ascending
#' @param n.max the maximum number of breaks to return
#' 
#' @export
#' 
bd_breaks <- function(business.dates, n.max=5) {
  
  breaks.weeks <-firstInGroup(business.dates, last_monday)
  breaks.months <- firstInGroup(business.dates, function(ds) format(ds, "%b '%y"))
  breaks.quarters <- firstInGroup(business.dates, quarter_format)
  breaks.years <- firstInGroup(business.dates, function(ds) format(ds, '%Y'))
  breaks.years.5 <- firstInGroup(business.dates, function(ds) floor(as.integer(format(ds, '%Y'))/5))
  breaks.decades <- firstInGroup(business.dates, function(ds) floor(as.integer(format(ds, '%Y'))/10))
  
  function(n.max=5) {
    function(range.date) {      
      range.t <- bd2t(range.date, business.dates)
      all.ts <- range.t[1]:range.t[2]
      all.dates <- t2bd(all.ts, business.dates)
      
      if(length(all.dates) <= n.max) return(all.dates)
      
      intersection <- function(breaks) as.Date(intersect(all.dates, breaks), origin=epoch)
      
      weeks <- intersection(breaks.weeks)
      
      if (length(weeks) <= n.max) return (weeks)
      
      months <- intersection(breaks.months)
      
      if (length(months) <= n.max) return(months)
      
      quarters <- intersection(breaks.quarters)
      
      if (length(quarters) <= n.max) return(quarters)
      
      years <- intersection(breaks.years)
      
      if (length(years) <= n.max) return(years)
      
      years.5 <- intersection(breaks.years.5)
    
      if (length(years.5) <= n.max) return(years.5)
      
      decades <- intersection(breaks.decades)
      
      decades
    }  
  }  
}

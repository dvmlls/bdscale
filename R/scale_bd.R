bd2t <- function(dates, business.dates) {
#  cat (sprintf("[D->N] In: %s \n", do.call(paste, as.list(dates))), file=stderr())
  result=match(dates, business.dates) - 1
#  cat (sprintf("[D->N] Out: %s \n", do.call(paste, as.list(result))), file=stderr())
  structure(as.numeric(result), names=names(dates))
}

t2bd <- function(ts, business.dates) {
#  cat (sprintf("[N->D] In: %s \n", do.call(paste, as.list(ts))), file=stderr())
  result=business.dates[pmin(pmax(round(ts, 0), 0) + 1, length(business.dates))]
#  cat (sprintf("[N->D] Out: %s \n", do.call(paste, as.list(result))), file=stderr())
  structure(result, class='Date')  
}

bd_trans <- function(business.dates, breaks=bd_breaks(business.dates)) {
  transform <- function(dates) bd2t(dates, business.dates)
  inverse <- function(ts) t2bd(ts, business.dates)
  
  trans_new('date', transform=transform, inverse=inverse, breaks=breaks, domain=range(business.dates))
}

scale_bd <- function(aesthetics, expand=waiver(), breaks=bd_breaks(business.dates), minor_breaks=waiver(), business.dates, ...) {
  
  if (is.character(breaks)) {
    breaks_str <- breaks
    breaks <- date_breaks(breaks_str)
  }
  
  if (is.character(minor_breaks)) {
    mbreaks_str <- minor_breaks
    minor_breaks <- date_breaks(mbreaks_str)
  }
  
  continuous_scale(aesthetics, 'date', identity, breaks=breaks, minor_breaks=minor_breaks, guide="none", expand=expand, trans=bd_trans(business.dates, breaks), ...)
}

#' Position scale for a ggplot
#' 
#' @param business.dates a vector of Date objects
#' @param expand see \code{\link{scale_x_date}}
#' @param breaks see \code{\link{scale_x_date}}
#' @param minor_breaks see \code{\link{scale_x_date}}
#' @param ... see \code{\link{scale_x_date}}
#' 
#' @export
#' @import ggplot2 scales
#' @example exec/example.R
#' 
scale_x_bd <- function(..., expand=waiver(), breaks=bd_breaks(business.dates), minor_breaks=waiver(), business.dates) {
  scale_bd(c("x", "xmin", "xmax", "xend"), expand=expand, breaks=breaks, minor_breaks=minor_breaks, business.dates=business.dates, ...)
}

#bd_closest <- function(dates, business.dates) {
#  m.dates <- do.call(rbind, rep(list(dates), length(business.dates)))
#  m.bds <- do.call(cbind, rep(list(business.dates), length(dates)))
#  closest <- abs(m.dates - m.bds) %>% apply(2, function(v) v == min(v))
#  (closest * m.bds) %>% apply(2, sum) %>% as.Date(origin=as.Date('1970-01-01'))
#}

bd_breaks <- function(business.dates, n = 5, ...) {
  
  function(dates) {
#    cat (sprintf("[BREAKS] In: %s \n", do.call(paste, as.list(dates))), file=stderr())
    ts <- bd2t(dates, business.dates)
    breaks <- t2bd(pretty(ts, n, ...), business.dates)
    names(breaks) <- attr(breaks, "labels")
#    cat (sprintf("[BREAKS] Out: %s \n", do.call(paste, as.list(breaks))), file=stderr())
    breaks
  }
}
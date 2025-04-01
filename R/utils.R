#' @keywords internal
isEmpty <- function(x) {
  is.null(x) || length(x) == 0L
}

#' Compact a list
#' @keywords internal
## compact <- function(x) {
##   x <- base::Filter(base::Negate(isEmpty), x)
##   if (length(x)) x else NULL
## }
compact <- function(x) {
  x <- lapply(x, function(el) {
    if (is.list(el)) compact(el) else el
  })
  x <- Filter(Negate(isEmpty), x)
  if (length(x)) x else NULL
}

#' @keywords internal
as_time <- function(x) {
  as.POSIXct(x, tz = "UTC")
}

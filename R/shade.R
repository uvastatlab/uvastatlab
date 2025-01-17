#' Shade area under standard normal curve
#'
#' Specify proportion of area to shade under a standard normal curve. This can
#' be useful to visualize how probabilities are calculated with a normal
#' distribution.
#'
#' The plot title shows the z value corresponding to the area to be shaded. To
#' find the z-value manually, use the `qnorm()` function with p. For example, to
#' see the z value for p = 0.05, where shading is in the lower tail, run
#' `qnorm(0.05)`. To see the z value for p = 0.05, where shading is in the upper
#' tail, run `qnorm(0.05, lower.tail = FALSE)`.
#'
#' @param p proportion to shade `(0,1)`
#' @param lower.tail logical; if TRUE (default), shading is in the left (or lower)
#'   tail. Otherwise shading is in the right (or upper) tail.
#'
#' @returns plot
#' @export
#'
#' @examples
#' shade(p = 0.05)
#' shade(p = 0.05, lower.tail = FALSE)
shade <- function(p, lower.tail = TRUE){
  if(p <= 0 || p >= 1) stop("p must be between 0 and 1")
  graphics::curve(stats::dnorm(x), from = -3, to = 3, ylab = "", xlab = "")
  if(lower.tail) xr <- seq(-3, stats::qnorm(p), 0.01)
  else xr <- seq(stats::qnorm(p, lower.tail = lower.tail), 3, 0.01)
  x <- c(min(xr), xr, max(xr))
  y <- c(0, stats::dnorm(xr), 0)
  graphics::polygon(x, y, col = "blue", border = NA)
  if(lower.tail) direction <- "<" else direction <- ">"
  title <- paste0("P(z ", direction, " ",
                  round(stats::qnorm(p, lower.tail = lower.tail), 2),
                  ") = ", p)

  title(main = title)
}

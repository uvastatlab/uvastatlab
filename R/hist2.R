#' Histogram with Rug
#'
#' This creates a histogram with a rug.
#'
#' The code for rug is `rug()`
#'
#' - one thing
#' - another
#'
#' @param x a numeric vector
#'
#' @returns Histogram with rug added
#' @export
#'
#' @seealso [hist()]
#'
#' @references Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988) The New S Language. Wadsworth & Brooks/Cole.
#'
#' @examples
#' hist2(rnorm(100))
hist2 <- function(x){
  graphics::hist(x, xlab = paste0("n = ", length(x)))
  graphics::rug(x)
}

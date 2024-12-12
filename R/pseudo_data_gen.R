#' Generate pseudo-data using summary statistics
#'
#' @description This function generates data from summary statistics that in turn have the same summary statistics. This can be useful to replicate analyses for which we only have summary statistics. See reference and example.
#'
#' @param n number of observations to generate
#' @param mu mean
#' @param Sigma covariance matrix
#' @param tol used to confirm Sigma is positive definite
#' @param empirical logical (default is TRUE). Which procedure to use.
#'
#' @return Returns a matrix for multiple variables, a vector for single variables
#' @export
#'
#' @importFrom stats runif
#'
#' @references Limpoco, M.A.A., Faes, C. and Hens, N. (2024), Linear Mixed Modeling of Federated Data When Only the Mean, Covariance, and Sample Size Are Available. Statistics in Medicine. https://doi.org/10.1002/sim.10300
#'
#' @examples
#' # using the Swiss data that come with R
#' xbar <- apply(swiss, 2, mean) # mean
#' s <- cov(swiss)               # covariance
#'
#' # Now generate psuedo data using these summary stats
#' pseudo_swiss <- pseudo_data_gen(n = nrow(swiss), mu = xbar, Sigma = s)
#'
#' # verify summary stats of pseudo data match original summary stats
#' all.equal(xbar, apply(pseudo_swiss, 2, mean))
#' # [1] TRUE
#' all.equal(s, cov(pseudo_swiss))
#' # [1] TRUE
#'
#' # Same analysis results
#' pseudo_swiss <- as.data.frame(pseudo_swiss)
#' m1 <- lm(Fertility ~ ., data = swiss)
#' m2 <- lm(Fertility ~ ., data = pseudo_swiss)
#' all.equal(coef(m1), coef(m2))
#' # [1] TRUE
pseudo_data_gen <- function (n = 1, mu, Sigma, tol = 1e-06, empirical = TRUE)
{
  p <- length(mu)
  if (!all(dim(Sigma) == c(p, p)))
    stop("incompatible arguments")
  eS <- eigen(Sigma, symmetric = TRUE)
  ev <- eS$values
  if (!all(ev >= -tol * abs(ev[1L])))
    stop("'Sigma' is not positive definite")
  X <- matrix(runif(p * n), n) #changed from rnorm to runif
  if (empirical) {
    X <- scale(X, TRUE, FALSE)
    X <- apply(X, 2, function(column) ifelse(is.na(column), 0, column))
    X <- X %*% svd(X, nu = 0, nv = p)$v
    X <- scale(X, FALSE, TRUE)
    X <- apply(X, 2, function(column) ifelse(is.na(column), 0, column))
  }
  X <- drop(mu) + eS$vectors %*% diag(sqrt(pmax(ev, 0)), p) %*% t(X)
  nm <- names(mu)
  if (is.null(nm) && !is.null(dn <- dimnames(Sigma))) nm <- dn[[1L]]
  dimnames(X) <- list(nm, NULL)
  if (n == 1) drop(X) else t(X)
}

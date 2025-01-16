#' NFL placekicking data
#'
#' Data on the results of placekicks in the NFL. This is a good data set for demonstrating logistic regression.
#'
#'
#' @format
#' A data frame with 1425 observations and 9 variables:
#' \describe{
#'   \item{week}{week of the season}
#'   \item{distance}{distance of the placekick in yards}
#'   \item{change}{does result of kick change who's leading? 0 = no, 1 = yes}
#'   \item{elap30}{number of minutes remaining before end of half; overtime placekicks receive a 0}
#'   \item{PAT}{point after attempt? 0 = no, 1 = yes}
#'   \item{type}{dome = 0, outdoor = 1}
#'   \item{field}{turf = 0, grass = 1}
#'   \item{wind}{no wind = 0, windy = 1; windy is a wind stronger than 15 MPH}
#'   \item{good}{was kick successful? 0 = no, 1 = yes}
#'
#' }
#' @source <http://www.chrisbilder.com/categorical/1stEdition/programs_and_data.html>
#' @references Bilder CR and Loughin TM. (2015) _Analysis of Categorical Data with R_. CRC Press.
#' @examples
#' m <- glm(good ~ distance, data = placekick, family = binomial)
#' exp(confint(m))
"placekick"


#' Wheat kernels
#'
#' Data on harvested wheat kernels. This is a good data set for demonstrating multinomial logistic regression.
#'
#'
#' @format
#' A data frame with 175 observations and 7 variables:
#' \describe{
#'   \item{class}{class of wheat: hard red winter (hrw) or soft red winter (srw)}
#'   \item{density}{density of the kernel (numeric)}
#'   \item{hardness}{hardness of the kernel (numeric)}
#'   \item{size}{size of the kernel (numeric)}
#'   \item{weight}{weight of the kernel (numeric)}
#'   \item{moisture}{moisture of the kernel (numeric)}
#'   \item{type}{condition of kernel: healthy, sprout or scab}
#'
#' }
#' @source <http://www.chrisbilder.com/categorical/1stEdition/programs_and_data.html>
#' @references Bilder CR and Loughin TM. (2015) _Analysis of Categorical Data with R_. CRC Press.
#' @examples
#' head(wheat)
"wheat"

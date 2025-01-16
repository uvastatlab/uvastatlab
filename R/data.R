#' NFL placekicking data
#'
#' Data on the results of placekicks in the NFL. This is a good data set for demonstrating logisitic regression.
#'
#'
#' @format
#' A data frame with 1425 rows and 9 columns:
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
"placekick"

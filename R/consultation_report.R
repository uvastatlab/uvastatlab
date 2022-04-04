#' Generate quick report of StatLab consultation statistics
#' @description
#' \code{report()} takes a CSV file exported from LibInsight dataset "5 - RDS+SNE Consultations & Collaborations" and creates a quick HTML report of various consultation statistics in the current working directory. The Rmd file requires the lubridate package, therefore the \code{report()} function checks if lubridate is installed. If not, lubridate is installed before the report is run.
#'
#'
#' @param file a CSV file exported from the LibInsight dataset "5 - RDS+SNE Consultations & Collaborations"
#'
#' @return an HTML report in the current working directory. The Rmd file is in the package inst folder under the rmd subdirectory.
#' @export
#'
#' @examples
#' \dontrun{
#' report("dataset-17737-20211214162235.csv")
#' # statlab_consultations_report.html output to working directory.
#' }
report <- function(file){
  if(!require(lubridate, quietly = TRUE)){
    install.packages("lubridate")
  }
  wd <- getwd()
  # get Rmd file
  rmd <- system.file("rmd",
                    "statlab_consultations_report.Rmd",
                    package = "uvastatlab")
  file.copy(from = rmd, to = wd)
  # render Rmd file using exported csv file from LibInsight
  rmarkdown::render(input = file.path(wd,basename(rmd)),
                    output_dir = getwd(),
                    params = list(csv = file))
  file.remove(file.path(wd,basename(rmd)))
  # TO DO: strip date from csv file and add to report and file name. Also
  # somehow add range of exported data?
}


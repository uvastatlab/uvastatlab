## code to prepare `DATASET` dataset goes here

# http://www.chrisbilder.com/categorical/1stEdition/programs_and_data.html
placekick <- read.csv("http://www.chrisbilder.com/categorical/1stEdition/Chapter2/Placekick.csv")

usethis::use_data(placekick, overwrite = TRUE)

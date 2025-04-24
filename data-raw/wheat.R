## code to prepare `wheat` dataset goes here

# http://www.chrisbilder.com/categorical/1stEdition/programs_and_data.html
wheat <- read.csv("http://www.chrisbilder.com/categorical/1stEdition/Chapter3/wheat.csv")
wheat$class <- factor(wheat$class)
wheat$type <- factor(wheat$type)

usethis::use_data(wheat, overwrite = TRUE)

library(lmerTest)
m <- glmer(passed ~ any_race + rep_control + factor(names2merge) + factor(year) + (1|state), data = state_house, family = "binomial")

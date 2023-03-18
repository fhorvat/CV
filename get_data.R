### INFO: 
### DATE: Fri Mar 17 21:28:37 2023
### AUTHOR: Filip Horvat
rm(list = ls()); gc()

######################################################## WORKING DIRECTORY
setwd("C:/Users/fihor/Dropbox/Ostalo/CV/vitae_package_cv.template_2")

######################################################## LIBRARIES
library(dplyr)
library(readr)
library(magrittr)
library(stringr)
library(tibble)
# library(tidyr)
library(ggplot2)
library(data.table)
library(purrr)

library(rorcid)
library(vitae)

######################################################## SOURCE FILES

######################################################## FUNCTIONS
# table to tribble (https://gist.github.com/hrbrmstr/8c7862092681d06e6535ab38d03074bf)
as_tribble <- function(x) {
  
  out <- capture.output(write.csv(x, quote=TRUE, row.names=FALSE))
  out[1] <- gsub('"', '`', out[1])
  out[1] <- sub('^`', "  ~`", out[1])
  out[1] <- gsub(',`', " , ~`", out[1])
  out <- paste0(out, collapse=",\n  ")
  cat(sprintf("tribble(\n%s\n)", out, ")\n"))
  
}

######################################################## PATH VARIABLES
# set inpath 
inpath <- getwd()

# set outpath
outpath <- getwd()

######################################################## READ DATA

######################################################## MAIN CODE
### employment data
employ <- 
  rorcid::orcid_employments("0000-0002-1896-7645")$`0000-0002-1896-7645`$`affiliation-group`$summaries %>% 
  dplyr::bind_rows(.)

# clear
employ %>%
  dplyr::mutate(what = `employment-summary.role-title`,
                when = glue::glue("{`employment-summary.start-date.year.value`} - {`employment-summary.end-date.year.value`}") %>% 
                  str_replace(., format(Sys.Date(), "%Y"), "current"),
                with = glue::glue("{`employment-summary.organization.name`}, {`employment-summary.department-name`}"),
                where = `employment-summary.organization.address.city`) %>% 
  dplyr::select(what, when, with, where) %>% 
  as_tribble(.)


### Education data
edu <- 
  rorcid::orcid_educations("0000-0002-1896-7645")$`0000-0002-1896-7645`$`affiliation-group`$summaries %>% 
  dplyr::bind_rows(.)

# clear
edu %>%
  dplyr::mutate(what = `education-summary.role-title`,
                when = glue::glue("{`education-summary.start-date.year.value`} - {`education-summary.end-date.year.value`}") %>% 
                  str_replace(., format(Sys.Date(), "%Y"), "current"),
                with = `education-summary.organization.name` %>% 
                  str_replace_all(c("Sveučilište u Zagrebu" = "University of Zagreb, ", 
                                    "Biološki odsjek" = "Faculty of Science", 
                                    "Charles University" = "Charles University, Faculty of Science")),
                where = `education-summary.organization.address.city`) %>% 
  dplyr::select(what, when, with, where) %>% 
  as_tribble(.)


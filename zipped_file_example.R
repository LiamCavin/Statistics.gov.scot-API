#=============================================================================
#
# Script for accessing a zipped file collection from 
# statistics.gov.scot and importing it into R
#
# Data, Statistics and Digital Outcomes
# Scottish Government
# September 2019 Liam Cavin x44092
#
#=============================================================================
#*****************************************************************************
#=============================================================================

# load the required libraries

library(SPARQL)
library(tidyverse)
library(readxl)

# Step 1 - Define the statistics.gov.scot endpoint, and create the SPARQL query statement

endpoint <- "http://statistics.gov.scot/sparql"

query <-  "
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?Name ?DownloadURL

WHERE {
?obs rdfs:label 'Supply, Use and Input-Output Tables'.
?obs rdfs:label ?Name.
?obs <http://publishmydata.com/def/dataset#downloadURL> ?DownloadURL.
}"

# Step 2 - Use SPARQL package to submit query and extract the up-to-date download URL

metadata <- SPARQL(endpoint,query)
metadata$results$DownloadURL
URL <- str_replace_all(metadata$results$DownloadURL, "[<>]", "")

# Step 3 - Use the download URL to fetch the zipped file, and unzip it

temp <- tempfile()
temp2 <- tempfile()
download.file(URL, temp)
unzip(zipfile = temp, exdir = temp2)

# Step 4 - Examine the unzipped files, and read one into R

list.files(temp2)
data <- read_xlsx(file.path(temp2, "PxP_wide.xlsx"))
unlink(c(temp, temp2))

# Yaldi

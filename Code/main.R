library(tidyverse)
library(readxl)
library(doBy)
library(sf)
library(geosphere)
library(viridis)
library(modelsummary)
library(webshot2)
library(testthat)

## Import and process data files
source("Code/processing.r")

## Clean datasets
source("Code/cleaning.r")

## Run unit test
source("Code/unit_test.r")

## Run regression
source("Code/tables.r")

## Generate maps
source("Code/maps.r")
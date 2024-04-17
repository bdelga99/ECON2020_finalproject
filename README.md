# ECON 2020 Final Project ReadMe
### Ben Delgado
##### 4/17/2024
#### Data Sources:
- Cleaned ACS county-to-county migration flows downloaded from [Census](https://www.census.gov/data/tables/2020/demo/geographic-mobility/county-to-county-migration-2016-2020.html) using Excel link for in, out, net, and gross migration
- 2 bedroom fair market rent data series from 1983-present downloaded as CSV from [HUD](https://www.huduser.gov/portal/datasets/fmr.html#history)
- 2016 county level unemployment rate data downloaded in Excel format from [BLS](https://www.bls.gov/lau/tables.htm#cntyaa)
- Natural amenities database downloaded using Excel link from [USDA](https://www.ers.usda.gov/data-products/natural-amenities-scale/)
- Downloaded annual personal income by county series from [BEA](https://apps.bea.gov/regional/downloadzip.cfm?_gl=1*1c6shsa*_ga*MTI3ODU2MTMwMy4xNzEzMTM5MDYw*_ga_J4698JNNFT*MTcxMzIzNzQ0NC40LjAuMTcxMzIzNzQ0NC42MC4wLjA); click dropdown under personal income (state and local) and select CAINC1 series
- US county shapefile downloaded from [Census](https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html); click file called
cb_2018_us_county_500k.zip under County section
#### Main file
- As long as file paths are correct, will run complete analysis and generate desired figures in output folder (note: I experienced some trouble running chunks of code together in VSCode, but it works line by line and worked in RStudio so it can't be an issue with the raw code - everything worked the last time I ran it so hopefully there's no issue, but if the main.r file is generating errors then you may need to run each line of the file individually?)
- processing.r reads in data files and completes preliminary cleaning
- cleaning.r cleans and generates primary dataset
- unit_test.r runs unit test to verify that shapefile is of the correct format
- tables.r runs primary regression and generates table in output folder
- maps.r generates choropleth maps for analysis
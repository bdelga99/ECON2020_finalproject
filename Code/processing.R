## Read in migration flows data
flows <- data.frame()
for (i in `state.name`) {
  temp <- read_excel("Data/county-to-county-2016-2020-ins-outs-nets-gross.xlsx", sheet=i, range = anchored("A2", dim = c(NA, 9)))
  temp <- temp[-1, ]
  flows <- rbind(flows, temp)
}
## Clean and organize migration flows data
clean_flows <- flows
colnames(clean_flows) <- c("state_fips_in", "county_fips_in", "state_fips_out", "county_fips_out",   "state_in", "county_in", "state_out", "county_out", "flow")
clean_flows <- clean_flows[c(!is.na(clean_flows$flow)),]
clean_flows$fips_in <- (as.numeric(clean_flows$state_fips_in)*1000) + as.numeric(clean_flows$county_fips_in)
clean_flows$fips_in[clean_flows$fips_in<10000] <- paste0("0", as.character(clean_flows$fips_in[clean_flows$fips_in<10000]))
clean_flows$fips_out <- (as.numeric(clean_flows$state_fips_out)*1000) + as.numeric(clean_flows$county_fips_out)
clean_flows <- clean_flows[!is.na(clean_flows$fips_out),]
clean_flows$fips_out[clean_flows$fips_out<10000] <- paste0("0", as.character(clean_flows$fips_out[clean_flows$fips_out<10000]))
clean_flows <- clean_flows[,c(10,11,5:9)]
clean_flows$flow <- as.numeric(clean_flows$flow)

## Read in HUD fair market rent data
fmr <- read.csv("Data/FMR_2Bed_1983_2024_revised.csv")
## Clean and organize HUD fair market rent data
clean_fmr <- fmr[, c(31,131,133)]
clean_fmr$fips <- (clean_fmr$state*1000) + clean_fmr$county
clean_fmr <- clean_fmr[!is.na(clean_fmr$fips),]
clean_fmr$fips[clean_fmr$fips<10000] <- paste0("0", as.character(clean_fmr$fips[clean_fmr$fips<10000]))
clean_fmr <- summaryBy(fmr16_2 ~ fips, FUN = c(mean), data=clean_fmr)
colnames(clean_fmr) <- c("fips", "fmr")

## Read in BLS unemployment data
unemp <- read_excel("Data/laucnty16.xlsx", range = "A5:J3225")
## Clean and organize BLS unemployment data
clean_unemp <- unemp[-1,c(2:3,10)]
colnames(clean_unemp) <- c("state_fips", "county_fips", "unemp_rate")
clean_unemp$fips <- (as.numeric(clean_unemp$state_fips)*1000) + as.numeric(clean_unemp$county_fips)
clean_unemp$fips[clean_unemp$fips<10000] <- paste0("0", as.character(clean_unemp$fips[clean_unemp$fips<10000]))
clean_unemp <- clean_unemp[,c(4,3)]

## Read in USDA natural amenities data
amenities <- read_excel("Data/natamenf_1_.xls", range = anchored("A105", dim = c(NA, 22)))
## Clean and organize USDA natural amenities data
clean_amenities <- amenities[,c(1,7,21)]
colnames(clean_amenities) <- c("fips", "metro_adj", "scale")
clean_amenities$metro_adj <- 1*(clean_amenities$metro_adj < 7)
clean_amenities$metro_adj <- as.factor(clean_amenities$metro_adj)

## Read in BEA data
bea <- read.csv("Data/CAINC1__ALL_AREAS_1969_2022.csv")
## Clean BEA population data
clean_pop <- bea[bea$Description == "Population (persons) 1/", c(1,56)]
clean_pop <- clean_pop[substr(clean_pop$GeoFIPS,nchar(clean_pop$GeoFIPS)-1,nchar(clean_pop$GeoFIPS))!="00",]
clean_pop$fips <- as.numeric(clean_pop$GeoFIPS)
clean_pop$fips[clean_pop$fips<10000] <- paste0("0", as.character(clean_pop$fips[clean_pop$fips<10000]))
clean_pop <- clean_pop[, c(3,2)]
colnames(clean_pop) <- c("fips", "pop")
clean_pop$pop <- as.numeric(clean_pop$pop)
## Clean BEA income data
clean_inc <- bea[bea$Description == "Per capita personal income (dollars) 2/", c(1,56)]
clean_inc <- clean_inc[substr(clean_inc$GeoFIPS,nchar(clean_inc$GeoFIPS)-1,nchar(clean_inc$GeoFIPS))!="00",]
clean_inc$fips <- as.numeric(clean_inc$GeoFIPS)
clean_inc$fips[clean_inc$fips<10000] <- paste0("0", as.character(clean_inc$fips[clean_inc$fips<10000]))
clean_inc <- clean_inc[, c(3,2)]
colnames(clean_inc) <- c("fips", "inc")
clean_inc$inc <- as.numeric(clean_inc$inc)

## Read in county coordinates data
shp <- st_read("Data/cb_2018_us_county_500k/cb_2018_us_county_500k.shp")
colnames(shp)[colnames(shp) == "GEOID"] <- "fips"
get_coords <- st_read("Data/cb_2018_us_county_500k/cb_2018_us_county_500k.shp") |> st_centroid() |> as.data.frame()
coords <- st_coordinates(get_coords$geometry) |> as.data.frame()
coords_data <- st_read("Data/cb_2018_us_county_500k/cb_2018_us_county_500k.shp") |> as.data.frame()
coords_data$long <- coords$X
coords_data$lat <- coords$Y
clean_coords <- coords_data[, c(5,11,12)]
colnames(clean_coords) <- c("fips", "long", "lat")
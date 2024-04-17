## Assemble primary dataset by merging individual datasets one by one
data <- clean_flows
data$flow <- as.numeric(data$flow)

## Merge FMR data
data <- merge(data, clean_fmr, by.x = "fips_in", by.y = "fips", all.x=TRUE, sort=FALSE)
colnames(data)[colnames(data) == "fmr"] <- "fmr_in"
data <- merge(data, clean_fmr, by.x = "fips_out", by.y = "fips", all.x=TRUE, sort=FALSE)
colnames(data)[colnames(data) == "fmr"] <- "fmr_out"
data$fmr_diff <- (data$fmr_in-data$fmr_out)/data$fmr_out

## Merge BLS data
data <- merge(data, clean_unemp, by.x = "fips_in", by.y = "fips", all.x=TRUE, sort=FALSE)
colnames(data)[colnames(data) == "unemp_rate"] <- "unemp_rate_in"
data <- merge(data, clean_unemp, by.x = "fips_out", by.y = "fips", all.x=TRUE, sort=FALSE)
colnames(data)[colnames(data) == "unemp_rate"] <- "unemp_rate_out"
data$unemp_rate_diff <- (data$unemp_rate_in-data$unemp_rate_out)/data$unemp_rate_out

## Merge USDA data
data <- merge(data, clean_amenities, by.x = "fips_in", by.y = "fips", all.x=TRUE, sort=FALSE)
colnames(data)[colnames(data) == "metro_adj"] <- "metro_adj_in"
colnames(data)[colnames(data) == "scale"] <- "scale_in"
data <- merge(data, clean_amenities, by.x = "fips_out", by.y = "fips", all.x=TRUE, sort=FALSE)
colnames(data)[colnames(data) == "metro_adj"] <- "metro_adj_out"
colnames(data)[colnames(data) == "scale"] <- "scale_out"
data$metro_diff <- factor(as.numeric(data$metro_adj_in)-as.numeric(data$metro_adj_out))
data$metro_diff <- relevel(data$metro_diff, ref = 2)
data$scale_diff <- data$scale_in-data$scale_out

## Merge BEA data
data <- merge(data, clean_pop, by.x = "fips_in", by.y = "fips", all.x=TRUE, sort=FALSE)
colnames(data)[colnames(data) == "pop"] <- "pop_in"
data <- merge(data, clean_pop, by.x = "fips_out", by.y = "fips", all.x=TRUE, sort=FALSE)
colnames(data)[colnames(data) == "pop"] <- "pop_out"
data$pop_diff <- (data$pop_in-data$pop_out)/data$pop_out
data <- merge(data, clean_inc, by.x = "fips_in", by.y = "fips", all.x=TRUE, sort=FALSE)
colnames(data)[colnames(data) == "inc"] <- "inc_in"
data <- merge(data, clean_inc, by.x = "fips_out", by.y = "fips", all.x=TRUE, sort=FALSE)
colnames(data)[colnames(data) == "inc"] <- "inc_out"
data$inc_diff <- (data$inc_in-data$inc_out)/data$inc_out

## Construct flows as share of population
data$flow_share_in <- data$flow/data$pop_in
data$flow_share_out <- data$flow/data$pop_out

## Merge long and lat data
data <- merge(data, clean_coords, by.x = "fips_out", by.y = "fips", all.x=TRUE, sort=FALSE)
colnames(data)[colnames(data) == "long"] <- "long_out"
colnames(data)[colnames(data) == "lat"] <- "lat_out"
data <- merge(data, clean_coords, by.x = "fips_in", by.y = "fips", all.x=TRUE, sort=FALSE)
colnames(data)[colnames(data) == "long"] <- "long_in"
colnames(data)[colnames(data) == "lat"] <- "lat_in"

## Compute distance between coordinates
data$dist <- distHaversine(cbind(data$long_in, data$lat_in), cbind(data$long_out, data$lat_out), r=6378137)

## Exclude non-contiguous US
data <- data[!as.numeric(substr(data$fips_in,1,2)) > 60,]
data <- data[substr(data$fips_in,1,2) != "02",]
data <- data[substr(data$fips_in,1,2) != "15",]
data <- data[!as.numeric(substr(data$fips_out,1,2)) > 60,]
data <- data[substr(data$fips_out,1,2) != "02",]
data <- data[substr(data$fips_out,1,2) != "15",]
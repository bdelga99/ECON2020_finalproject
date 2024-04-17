## Construct map datasets of US flows
inflow_us <- data[, c(1,7,20)]
inflow_us <- summaryBy(flow + pop_in ~ fips_in, data = inflow_us, FUN = c(sum,mean))
inflow_us$flow_share <- inflow_us$flow.sum/inflow_us$pop_in.mean
inflow_us <- inflow_us[, c(1,6)]
colnames(inflow_us) <- c("fips","flow_share")
outflow_us <- data[, c(2,7,21)]
outflow_us <- summaryBy(flow + pop_out ~ fips_out, data = outflow_us, FUN = c(sum,mean))
outflow_us$flow_share <- outflow_us$flow.sum/outflow_us$pop_out.mean
outflow_us <- outflow_us[, c(1,6)]
colnames(outflow_us) <- c("fips","flow_share")
inflow_map <- merge(inflow_us, shp, by.x = "fips", by.y = "fips", all.x = TRUE, sort=FALSE) |> st_as_sf()
outflow_map <- merge(outflow_us, shp, by.x = "fips", by.y = "fips", all.x = TRUE, sort=FALSE) %>% st_as_sf()

## Construct map datasets of RI flows
inflow_ri <- data[data$fips_in == "44007" & substr(data$fips_out,1,2) == "44", c(2,27)]
colnames(inflow_ri) <- c("fips","flow_share")
inflow_ri[5,] <- list("44007", NA)
outflow_ri <- data[data$fips_out == "44007" & substr(data$fips_in,1,2) == "44", c(1,26)]
outflow_ri[5,] <- list("44007", NA)
colnames(outflow_ri) <- c("fips","flow_share")
inflow_ri_map <- merge(inflow_ri, shp, by.x = "fips", by.y = "fips", all.x = TRUE, sort=FALSE) %>% st_as_sf()
outflow_ri_map <- merge(outflow_ri, shp, by.x = "fips", by.y = "fips", all.x = TRUE, sort=FALSE) %>% st_as_sf()
X <- -71.4128
Y <- 41.8240
City <- "Providence"
prov <- data.frame(X, Y, City)

## Construct map datasets of RI controls
controls_ri <- data[substr(data$fips_in,1,2) == "44", c(1,8,11,15,20,23)]
controls_ri <- summaryBy(fmr_in + unemp_rate_in + scale_in + pop_in + inc_in ~ fips_in, data = controls_ri, FUN = mean)
colnames(controls_ri) <- c("fips","fmr","unemp_rate","scale","pop","inc")
controls_ri_map <- merge(controls_ri, shp, by.x = "fips", by.y = "fips", all.x = TRUE, sort=FALSE) %>% st_as_sf()

## Construct maps
inflow_map_us <- inflow_map |> ggplot(aes(fill = flow_share)) + 
  geom_sf(colour = NA) +
  scale_fill_viridis("Flow in", begin = 0.9, end = 0, option = "plasma") +
  theme_void()
ggsave("Output/inflow_map_us.png")
outflow_map_us <- outflow_map |> ggplot(aes(fill = flow_share)) + 
  geom_sf(colour = NA) +
  scale_fill_viridis("Flow out", begin = 0.9, end = 0, option = "plasma", trans = "log", 
                     breaks = c(0, 0.001, 0.01, 0.1, 1)) +
  theme_void()
ggsave("Output/outflow_map_us.png")
inflow_ri_map |> ggplot() + 
  geom_sf(aes(fill = flow_share), colour = "white") +
  scale_fill_viridis("Flow to Prov County", begin = 0.9, end = 0, option = "plasma") +
  geom_text(data = prov, aes(X, Y, label = City), colour = "black") +
  theme_void()
ggsave("Output/inflow_ri_map.png")
outflow_ri_map |> ggplot() + 
  geom_sf(aes(fill = flow_share), colour = "white") +
  scale_fill_viridis("Flow from Prov County", begin = 0.9, end = 0, option = "plasma") +
  geom_text(data = prov, aes(X, Y, label = City), colour = "black") +
  theme_void()
ggsave("Output/outflow_ri_map.png")
controls_ri_map |> ggplot() + 
  geom_sf(aes(fill = fmr), colour = "white") + 
  scale_fill_viridis("Fair market rent", begin = 0.9, end = 0, option = "plasma") +
  geom_text(data = prov, aes(X, Y, label = City), colour = "black") +
  theme_void()
ggsave("Output/fmr.png")
controls_ri_map |> ggplot() + 
  geom_sf(aes(fill = unemp_rate), colour = "white") + 
  scale_fill_viridis("Unemp rate", begin = 0, end = 0.9, option = "plasma") +
  geom_text(data = prov, aes(X, Y, label = City), colour = "black") +
  theme_void()
ggsave("Output/unemp.png")
controls_ri_map |> ggplot() + 
  geom_sf(aes(fill = scale), colour = "white") + 
  scale_fill_viridis("Natural amenities", begin = 0.9, end = 0, option = "plasma") +
  geom_text(data = prov, aes(X, Y, label = City), colour = "black") +
  theme_void()
ggsave("Output/amenities.png")
controls_ri_map |> ggplot() + 
  geom_sf(aes(fill = pop), colour = "white") + 
  scale_fill_viridis("Population", begin = 0, end = 0.9, option = "plasma") +
  geom_text(data = prov, aes(X, Y, label = City), colour = "black") +
  theme_void()
ggsave("Output/pop.png")
controls_ri_map |> ggplot() + 
  geom_sf(aes(fill = inc), colour = "white") + 
  scale_fill_viridis("Income", begin = 0.9, end = 0, option = "plasma") +
  geom_text(data = prov, aes(X, Y, label = City), colour = "black") +
  theme_void()
ggsave("Output/income.png")

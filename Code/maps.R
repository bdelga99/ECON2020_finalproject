choropleth_data <- merge(data, shp, all.x = TRUE, sort=FALSE) %>% st_as_sf()

us_map <- shp |> ggplot(aes(fill = median_age)) + 
  geom_sf(color = NA) +
  scale_fill_viridis("Flow in") +
  theme_void()
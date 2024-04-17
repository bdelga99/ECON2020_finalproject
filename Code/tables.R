model <- lm(flow_share_out*100000 ~ fmr_diff + unemp_rate_diff + metro_diff + scale_diff + pop_diff + inc_diff + I(dist/1000), data=data)
summary(model)
modelsummary(list("Flow (per 100,000 people)" = model), estimate  = "{estimate} {stars} ({std.error})", statistic = NULL,
  coef_omit = "Intercept", gof_map = c("nobs", "r.squared"),
  coef_rename = c("Chg FMR", "Chg unemp rate", "From metro", "To metro", "Chg amenities", "Chg pop", "Chg income", "Distance (km)"),
  output = "Output/regression.png")
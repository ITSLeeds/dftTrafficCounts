# First stage: get data from Leeds

library(dplyr)
library(tmap)
library(sf)
data_leeds = readr::read_csv("http://api.dft.gov.uk/v3/trafficcounts/export/data/traffic/la/Leeds.csv")
plot(data_leeds$Year, data_leeds$PedalCycles)

# summarise data per point
length(unique(data_leeds$CP)) # 230
pts_leeds = data_leeds %>% 
  group_by(CP) %>% 
  summarise(
    n_cycle = sum(PedalCycles),
    n_motor = sum(AllMotorVehicles),
    n_cars = sum(CarsTaxis),
    p_cycle = sum(PedalCycles) / (sum(AllMotorVehicles) + sum(PedalCycles)) * 100,
    change_cycle_yr = lm(formula = PedalCycles ~ Year)$coefficients[2],
    change_pcycle_yr = lm(formula = (PedalCycles) / ((AllMotorVehicles) + (PedalCycles)) ~ Year)$coefficients[2] * 100,
    years_of_data = diff(range(Year)),
    start_year = min(Year),
    estimation_method = first(Estimation_method),
    x = mean(Easting),
    y = mean(Northing)
    )
pts_sf = st_as_sf(pts_leeds, coords = c("x", "y"), crs = 27700) 
sf::write_sf(pts_sf, "pts_leeds.gpkg")
# mapview::mapview(pts_sf, zcol = "n_cycle")
ttm()
tm_shape(pts_sf) +
  tm_dots(col = "change_pcycle_yr", size = "n_cycle")

data_woodhouse = readr::read_csv("http://api.dft.gov.uk/v3/trafficcounts/countpoint/id/17374.csv")

# explore change in cycling
data_woodhouse = data_leeds %>% 
  filter(CP == 17374)
mean(data_woodhouse$PedalCycles)
plot(data_woodhouse$Year, data_woodhouse$PedalCycles)
m_woodhouse = lm(formula = PedalCycles ~ Year, data = data_woodhouse)
m_woodhouse$coefficients[2]
lines(data_woodhouse$Year, m_woodhouse$fitted.values)

# testing bristol data (messy!) -------------------------------------------
# http://maps.bristol.gov.uk/pinpoint/?service=localinfo&maptype=js&layer=Traffic+survey+locations
# unzip("/tmp/Cordons.zip")
# d = readxl::read_excel("1010 A4 Portway west of Sylvan Way - Bristol.xls", skip = 7)
# plot(d$PEDAL..2)


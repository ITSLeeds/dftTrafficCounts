#' Bulk import traffic data
#'
#' This function downloads and reads bulk traffic data from the DfT
#' @param base_url The base url of the data to access
#' @param ua The URL appendix
#' @param u The full URL (if applicable)
#' @param dir Where should the data be stored? `tempdir()` by default.
#' @export
#' @examples
#' res = dtc_import()
#' class(res)
#' names(res)
#' head(res[1:3, ])
#' u = "http://data.dft.gov.uk/road-traffic/dft_traffic_counts_raw_counts.zip"
#' # dtc_import(u = u)
#' # dtc_import(u = "http://data.dft.gov.uk/road-traffic/local_authority_traffic.csv")
dtc_import = function(
  base_url = "https://dft-statistics.s3.amazonaws.com/road-traffic/downloads/",
  ua = "aadf/count_point_id/dft_aadf_count_point_id_74816.csv",
  u = NULL,
  dir = tempdir()) {
  if(!is.null(u) && grepl(pattern = "zip", x = u)) {
    f = file.path(dir, "dft_traffic_counts_raw_counts.zip")
    utils::download.file(u, f)
  } else if(!is.null(u) && !grepl(pattern = "zip", x = u)) {
    f = u
  } else {
    u = paste0(base_url, ua)
    f = u
  }
  # a 755 MB file
  # system.time({
  #   traffic_data_original = readr::read_csv("~/hd/data/uk/dft_traffic_counts_raw_counts-2000-2018.zip")
  # })
  # user  system elapsed
  # 28.496   1.510  29.657
  # system.time({
    traffic_data_original = vroom::vroom(f)
  # })
    # user  system elapsed
    # 6.609   2.186   5.842
    traffic_data_original
}
#' @export
#' @rdname dtc_import
dtc_import_la = function() {
  dtc_import(u = "http://data.dft.gov.uk/road-traffic/local_authority_traffic.csv")
}
#' @export
#' @rdname dtc_import
dtc_import_roads = function() {
  dtc_import(u = "http://data.dft.gov.uk/road-traffic/dft_traffic_counts_aadf.zip")
}


local_authority_names_to_ids = function(la_names = c("Leeds")) {
  la_lookup = dtc_import_la()
  la_lookup[match(x = )]
}

# library(tidyverse)
#
# u = "http://data.dft.gov.uk/road-traffic/dft_traffic_counts_raw_counts.zip"
# download.file(u, "~/hd/data/uk/dft_traffic_counts_raw_counts-2000-2018.zip")
# traffic_data_original = readr::read_csv("~/hd/data/uk/dft_traffic_counts_raw_counts-2000-2018.zip")
# nrow(traffic_data_original) / 1e6 # 4 million
# traffic_data_original
# names(traffic_data_original)
#
# # what have we got for cycling?
# summary(traffic_data_original$pedal_cycles) # about 3 per hour
# # Min.  1st Qu.   Median     Mean  3rd Qu.     Max.
# # 0.000    0.000    0.000    2.894    2.000 2207.000
# # check the guidance
# browseURL("http://data.dft.gov.uk.s3.amazonaws.com/road-traffic/all-traffic-data-metadata.pdf")
#
# # preliminary sense check of data: find counters with most cycling, London/Cambridge?
# counter_mean_cyclists = traffic_data_original %>%
#   group_by(count_point_id) %>%
#   summarise(
#     mean_cyclists = mean(pedal_cycles),
#     easting = mean(easting),
#     northing = mean(northing)
#     )
# # 31k counter points
#
# counters_sf = counter_mean_cyclists %>%
#   sf::st_as_sf(coords = c("easting", "northing"), crs = 27700)
#
# counters_high_cycling = counters_sf %>%
#   filter(mean_cyclists > 20)
#
# mapview::mapview(counters_high_cycling["mean_cyclists"]) # it works!
#
# # is there a column showing if estimated? not immediately obvious.
# # Compare with known count on Kirkstall road: https://roadtraffic.dft.gov.uk/manualcountpoints/16598
# counter_16598 = traffic_data_original %>%
#   filter(count_point_id == "16598")
#
# View(counter_16598) # matches perfectly
# counter_16598 %>%
#   filter(year == 2016) %>%
#   select(pedal_cycles, direction_of_travel, hour)
# sum(.Last.value$pedal_cycles)
#
# counter_16598_dl = readr::read_csv("https://dft-statistics.s3.amazonaws.com/road-traffic/downloads/rawcount/count_point_id/dft_rawcount_count_point_id_16598.csv")
# counter_16598_dl %>%
#   filter(year == 2016) %>%
#   select(pedal_cycles, direction_of_travel, hour)
# sum(.Last.value$pedal_cycles)
# sum(counter_16598_dl$pedal_cycles) # differ from counts
#
# counter_16598_daily = readr::read_csv("https://dft-statistics.s3.amazonaws.com/road-traffic/downloads/aadf/count_point_id/dft_aadf_count_point_id_16598.csv")
# counter_16598_daily
# # Get data from Leeds: not reproducible
#
# counters_la = readr::read_csv("http://data.dft.gov.uk/road-traffic/local_authority_traffic.csv")
# lads = ukboundaries::lad2018
# summary(lads$lau118nm %in% counters_la$name)
# summary(lads$lau118cd %in% counters_la$ons_code)
# length(unique(counters_la$name))
# length(unique(lads$lau118nm))
#
# # combine with unitary authority data - from Rapid work?
# # uas = ...
#
# # Challenge: create animated map
#
# library(dplyr)
# library(tmap)
# library(sf)
# data_leeds = readr::read_csv("http://api.dft.gov.uk/v3/trafficcounts/export/data/traffic/la/Leeds.csv")
# plot(data_leeds$Year, data_leeds$PedalCycles)
#
# # summarise data per point
# length(unique(data_leeds$CP)) # 230
# pts_leeds = data_leeds %>%
#   group_by(CP) %>%
#   summarise(
#     n_cycle = sum(PedalCycles),
#     n_motor = sum(AllMotorVehicles),
#     n_cars = sum(CarsTaxis),
#     p_cycle = sum(PedalCycles) / (sum(AllMotorVehicles) + sum(PedalCycles)) * 100,
#     change_cycle_yr = lm(formula = PedalCycles ~ Year)$coefficients[2],
#     change_pcycle_yr = lm(formula = (PedalCycles) / ((AllMotorVehicles) + (PedalCycles)) ~ Year)$coefficients[2] * 100,
#     years_of_data = diff(range(Year)),
#     start_year = min(Year),
#     estimation_method = first(Estimation_method),
#     x = mean(Easting),
#     y = mean(Northing)
#     )
# pts_sf = st_as_sf(pts_leeds, coords = c("x", "y"), crs = 27700)
# sf::write_sf(pts_sf, "pts_leeds.gpkg")
# # mapview::mapview(pts_sf, zcol = "n_cycle")
# ttm()
# tm_shape(pts_sf) +
#   tm_dots(col = "change_pcycle_yr", size = "n_cycle")
#
# data_woodhouse = readr::read_csv("http://api.dft.gov.uk/v3/trafficcounts/countpoint/id/17374.csv")
#
# # explore change in cycling
# data_woodhouse = data_leeds %>%
#   filter(CP == 17374)
# mean(data_woodhouse$PedalCycles)
# plot(data_woodhouse$Year, data_woodhouse$PedalCycles)
# m_woodhouse = lm(formula = PedalCycles ~ Year, data = data_woodhouse)
# m_woodhouse$coefficients[2]
# lines(data_woodhouse$Year, m_woodhouse$fitted.values)

# testing bristol data (messy!) -------------------------------------------
# http://maps.bristol.gov.uk/pinpoint/?service=localinfo&maptype=js&layer=Traffic+survey+locations
# unzip("/tmp/Cordons.zip")
# d = readxl::read_excel("1010 A4 Portway west of Sylvan Way - Bristol.xls", skip = 7)
# plot(d$PEDAL..2)


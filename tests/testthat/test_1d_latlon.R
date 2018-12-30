context("1d lat/lon")

test_that("1d lat/lon", {
  variable_name <- "precipitation_amount"
  nc_file <- system.file("extdata/metdata.nc", package = "intersectr")
  nc <- RNetCDF::open.nc(nc_file)
  x_var <- "lon"
  y_var <- "lat"
  t_var <- "day"

  x <- RNetCDF::var.get.nc(nc, x_var)
  y <- RNetCDF::var.get.nc(nc, y_var)

  geom <- sf::read_sf(system.file("shape/nc.shp", package = "sf")) %>%
    st_transform(5070)

  geom <- geom[5, ]

  in_prj <- "+init=epsg:4326"

  cell_geometry <- suppressWarnings(
    create_cell_geometry(x, y, in_prj, geom, 1000))

  expect(nrow(cell_geometry) == 286)
  expect(all(c("grid_ids", "col_ind", "row_ind") %in% names(cell_geometry)))

  data_source_cells <- st_sf(select(cell_geometry, grid_ids))
  target_polygons <- st_sf(select(geom, CNTY_ID))

  sf::st_agr(data_source_cells) <- "constant"
  sf::st_agr(target_polygons) <- "constant"

  area_weights <- calculate_area_intersection_weights(
    data_source_cells,
    target_polygons)

  intersected <- execute_intersection(nc_file, variable_name, area_weights,
                                      cell_geometry, x_var, y_var, t_var)

  expect(all(names(intersected) %in% c("time_stamp", "1832")))
  expect(nrow(intersected) == 5)

  intersected <- execute_intersection(nc_file, variable_name, area_weights,
                                      cell_geometry, x_var, y_var, t_var,
                                      start_datetime = "2018-09-13 00:00:00",
                                      end_datetime = "2018-09-14 00:00:00")

  expect(nrow(intersected) == 1)

  expect_equal(intersected$`1832`, 0.0172, tolerance = 0.01)
})
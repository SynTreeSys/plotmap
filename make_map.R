## NICOLAS' previous code (thanks nico!!)
# plot_sf <- readRDS(here::here("data", "plot_coords.rds"))
# 
# m <- mapview::mapview(plot_sf, zcol = "projectTitle")
# mapview::mapshot(m, url = here::here("index.html"))

## RENATO'S adapted code
# getting the most up-to-date plot data
path.from <- gsub("Plot_map", "WP1_Data_harmonization/data/derived-data/database", 
                  here::here())
list.files(path.from) # chose the most up-to-date version and change below
version.name <- "syntreesys_dataset_version_0.0.2.rds"
path.from1 <- file.path(path.from, version.name)
path.to <- here::here(list("data", version.name))
file.copy(from = path.from1, to = path.to, overwrite = TRUE, recursive = FALSE)

# loading the data and getting the sf object
plots <- readRDS(here::here("data", version.name))$Plots
plots <- plots[!is.na(plots$plotLatitude), ]
projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
plots_sf <- sf::st_as_sf(x = plots[, c("plotLongitude", "plotLatitude", "network")],                         
         coords = c("plotLongitude", "plotLatitude"),
         crs = projcrs)
# preparing and rendering the map
col.f <- function (n) { grDevices::rainbow(n) }
m <- mapview::mapview(plots_sf, zcol = "network",
                      col.regions = col.f,
                      #native.crs = TRUE,
                      map.types = c(
                        #"CartoDB.Positron",
                        #"CartoDB.DarkMatter"
                        "OpenStreetMap",
                        "Esri.WorldImagery",
                        "OpenTopoMap"),
                      layer.name = "SynTreeSys networks"
                      )
mapview::mapshot(m, url = here::here("index.html"))


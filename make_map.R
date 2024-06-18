## NICOLAS' previous code (thanks nico!!)
# plot_sf <- readRDS(here::here("data", "plot_coords.rds"))
# 
# m <- mapview::mapview(plot_sf, zcol = "projectTitle")
# mapview::mapshot(m, url = here::here("index.html"))


# Load other required libraries
install.packages("webshot")
library(webshot)
webshot::install_phantomjs()
library(mapview)
library(here)


## RENATO'S adapted code
# getting the most up-to-date plot data
path.from <- gsub("plotmap", "WP1_Data_harmonization/data/derived-data/database", 
                  here::here())
list.files(path.from) # chose the most up-to-date version and change below
version.name <- "syntreesys_dataset_version_0.0.5g.rds"

path.from1 <- file.path(path.from, version.name)
path.to <- here::here(list("data", version.name))
file.copy(from = path.from1, to = path.to, overwrite = TRUE, recursive = FALSE)

# loading the data and getting the sf object
plots <- readRDS(here::here("data", version.name))$Plots
plots <- plots[!is.na(plots$plotLatitude), ]
plots$network <- ifelse(
  plots$country == "Colombia" & grepl("Red BST-Col", plots$citationString),
  "RedBST-Col",
  plots$network
)

projcrs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

plots_sf <- sf::st_as_sf(x = plots[, c("plotLongitude", "plotLatitude", "network")],                         
         coords = c("plotLongitude", "plotLatitude"),
         crs = projcrs)

library(RColorBrewer)

# Define color palette function using RColorBrewer (Set3 for high contrast)

# preparing and rendering the map
col.f <- function (n) { brewer.pal((n), "Set3") }
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


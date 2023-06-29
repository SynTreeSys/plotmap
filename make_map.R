plot_sf <- readRDS(here::here("data", "plot_coords.rds"))


m <- mapview::mapview(plot_sf, zcol = "projectTitle")
mapview::mapshot(m, url = here::here("index.html"))

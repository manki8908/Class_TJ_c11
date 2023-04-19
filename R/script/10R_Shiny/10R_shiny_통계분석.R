library(sf)
rm(list = ls())

# data load
load("R/DAOU/06_geodataframe/06_apt_price.rdata")  # 실거래
load("R/DAOU/07_map/07_kde_high.rdata")            # 최고가
grid <- st_read("R/data/seoul/seoul.shp")          # 서울시 그리드

install.packages("tmap")
library(tmap)
tmap_mode("view")
tm_shape(grid) + tm_borders() + tm_text("ID", col = "red") +
    tm_shape(raster_high) + 
    tm_raster(palette = c("blue", "green", "yellow", "red"), alpha=.4) + 
    tm_basemap(server = c('OpenStreetMap'))
    

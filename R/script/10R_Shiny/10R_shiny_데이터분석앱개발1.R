# 데이터 분석 앱개발

library(sf)  # 지도관련
library(sp)
library(raster)


# .. load
load("R/DAOU/06_geodataframe/06_apt_price.rdata")  # 아파트 실거래
bnd <- st_read("R/data/sigun_bnd/seoul.shp")       # 경계선
load("R/DAOU/07_map/07_kde_high.rdata")            # 최고가 래스터 이미지
load("R/DAOU/07_map/07_kde_hot.rdata")             # 급등 래스터 이미지


# .. 마커클러스트링
pcnt_10 <- as.numeric(quantile(apt_price$py, probs=seq(.1,.9,by=.1))[1])
pcnt_90 <- as.numeric(quantile(apt_price$py, probs=seq(.1,.9,by=.1))[9])
load("R/data/circle_marker.rdata")
circle.colors <- sample(x=c("red", "green", "blue"), size=1000, replace=T)

# .. 반응형 지도만들기
library(leaflet)
library(purrr)
library(raster)
leaflet() %>% 
    # 기본맵 설정
    addTiles(options = providerTileOptions(minZoom=9, maxZoom=18)) %>% 
    # 최고가 지역 KDE
    addRasterImage(raster_high,
                   colors = colorNumeric(c("blue","green","yellow","red"),
                                         values(raster_high),
                                         na.color="transparent"),
                   opacity = 0.4,
                   group = "2021 최고가") %>% 
    # 급등지역 KDE
    addRasterImage(raster_hot,
                   colors = colorNumeric(c("blue","green","yellow","red"),
                                         values(raster_hot),
                                         na.color="transparent"),
                   opacity = 0.4,
                   group = "2021 급등지") %>% 
    # 레이어 스위치 메뉴
    addLayersControl(baseGroups = c("2021 최고가", "2021 급등지"),
                     options = layersControlOptions(collapsed=F)) %>% 
    # 서울시 외곽 경계선
    addPolygons(data = bnd, weight = 3, stroke = T, color = "red",
                fillOpacity = 0) %>% 
    # 마커 클러스터링
    addCircleMarkers(data = apt_price, lng = unlist(map(apt_price$geometry,1)),
                     lat = unlist(map(apt_price$geometry,2)),radius = 10, 
                     stroke = F, fillOpacity = 0.6, fillColor = circle.colors,
                     weight = apt_price$py,
                     clusterOptions = markerClusterOptions(iconCreateFuntion=JS(avg.formula)))

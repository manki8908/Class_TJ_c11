# 7-3 우리동네가 옆동네보다 비쌀까?

# .. 로드
# 데이터
load("R/DAOU/06_geodataframe/06_apt_price.rdata") # 실거래자료
load("R/DAOU/07_map/07_kde_high.rdata")           # 최고가
load("R/DAOU/07_map/07_kde_hot.rdata")            # 급등지

# 격자, 경계선
library(sf)
bnd <- st_read("R/data/sigun_bnd/seoul.shp")  # 서울 경계선
grid <- st_read("R/data/seoul/seoul.shp")     # 서울 격자

# 이상치 설정(평당가격의 하위10%, 상위90%), 10%씩 분할
# 하위 10%
pcnt_10 <- as.numeric(quantile(apt_price$py, probs = seq(.1,.9,by=.1)))[1]
# 상위 90%
pcnt_90 <- as.numeric(quantile(apt_price$py, probs = seq(.1,.9,by=.1)))[9]
pcnt_10; pcnt_90

# 마커, 상중하, circle_marker.rdata에서 pcnt_10, pcnt_90 사용
# javascript로 짜여있음
load("R/data/circle_marker.rdata")
circle.colors <- sample(x=c("red","green","blue"),size=1000, replace=T)


# .. 시각화
library(purrr)
leaflet() %>% 
    # 오픈스트리트맵 불러오기
    addTiles() %>% 
    
    # 서울시 경계선 불러오기
    addPolygons(data = bnd, weight = 3, color = "red", fill = NA) %>% 
    
    # 최고가 래스터 이미지 불러오기
    addRasterImage(raster_high, 
                   colors = colorNumeric( c("blue", "green", "yellow", "red"),
                                          values(raster_high), 
                                          na.color = "transparent"), 
                   opacity = 0.4, group = "2021 최고가")  %>%

    # 급등지 래스터 이미지 불러오기
    addRasterImage(raster_hot, 
                   colors = colorNumeric( c("blue", "green", "yellow", "red"),
                                          values(raster_hot), 
                                          na.color = "transparent"), 
                    opacity = 0.4, group = "2021 급등지")  %>%
    
    # 최고가/급등지 선택 옵션 추가
    addLayersControl(baseGroups = c("2021 최고가", "2021 급등지"),
                     options = layersControlOptions(collapsed = F))  %>%
    
    # 마커 클러스터링 불러오기
    addCircleMarkers(data = apt_price, lng = unlist(map(apt_price$geometry,1)),
                     lat = unlist(map(apt_price$geometry,2)), radius = 10,
                     stroke = F, fillOpacity = 0.6, fillColor = circle.colors,
                     weight = apt_price$py, 
                     clusterOptions = markerClusterOptions(iconCreateFunction=JS(avg.formula)))

    
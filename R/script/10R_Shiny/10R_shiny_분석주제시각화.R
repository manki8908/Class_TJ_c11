#install.packages('spatstat')
#install.packages('sp')
#library(dplyr)
#library(sp)
#library(ggplot2)
#install.packages('sf')

library(sf)

# .. data load
load("R/DAOU/06_geodataframe/06_apt_price.rdata")

grid <- st_read("R/data/seoul/seoul.shp")  # 서울시 1km 그리드 데이타

apt_price <- st_join(apt_price, grid, join=st_intersects)  # 실거래 + 그리드 결합

head(apt_price,2)


# 지역별 평균가격 구하긱
kde_high <- aggregate(apt_price$py, by=list(apt_price$ID), mean)
colnames(kde_high) <- c("ID", "avg_price")  # 컬럼명 변경
head(kde_high,2)


# 평균가격 시각화
kde_high <- merge(grid, kde_high, by="ID")

library(ggplot2)
library(dplyr)
kde_high %>% ggplot(aes(fill=avg_price)) + 
    geom_sf() + scale_fill_gradient(low="white", high = "red")


# .. 핫한지역, 거래건수를 통한 밀도함수 시각화
# sf to sp형, 지도작업을 수월하게 진행하기 위함
library(sp)
kde_high_sp <- as(st_geometry(kde_high), "Spatial")  

# 그리드 중심, x/y 좌표 추출
x <- coordinates(kde_high_sp)[,1]   
y <- coordinates(kde_high_sp)[,2]

# 기준경계 설정
l1 <- bbox(kde_high_sp)[1,1] - (bbox(kde_high_sp)[1,1]*0.0001)
l2 <- bbox(kde_high_sp)[1,2] + (bbox(kde_high_sp)[1,2]*0.0001)
l3 <- bbox(kde_high_sp)[2,1] - (bbox(kde_high_sp)[2,1]*0.0001)
l4 <- bbox(kde_high_sp)[2,2] + (bbox(kde_high_sp)[1,1]*0.0001)
l1;l2;l3;l4
library(spatstat)
win <- owin(xrange=c(l1,l2), yrange=c(l3,l4)) # 지도 영역설정
plot(win) # 지도 경계선 확인
rm(list=c("kde_high_sp", "apt_price", "l1", "l2", "l3", "l4"))


# 밀도 그래프 표시
p <- ppp(x, y, window = win)  # 경계선 위에 좌표값 포인트 생성
# 층을 쌓음(density)
d <- density.ppp(p, weights = kde_high$avg_price, 
                 sigma = bw.diggle(p),     # p의 범위 지정
                 kernel = 'gaussian')
plot(d)
rm(list = c("x", "y", "win", "p"))


# 래스터 이미지로 변환하기
# quatile 정보를 활용해서 상위 25% 정보만 활용하겠다
# 하위 75% 노이즈(NA) 처리
d[d < quantile(d)[4] + (quantile(d)[4]*0.1)] <- NA  # 노이즈 제거
#install.packages('raster')
library(raster)
raster_high <- raster(d)
plot(raster_high)


# 클리핑
bnd <- st_read("R/data/sigun_bnd/seoul.shp") # 서울시 경계선 데이타
raster_high <- crop(raster_high, extend(bnd))  # 외곽선 자르기
crs(raster_high) <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")  # 좌표계 정의

plot(raster_high)  # 지도 확인
plot(bnd, col=NA, border="red", add=TRUE)


# 지도그리기
#install.packages('rgdal')
library(rgdal)
library(leaflet)

leaflet() %>% 
    # 기본 지도 불러오기
    addProviderTiles(providers$CartoDB.Positron) %>% 
    # 서울시 경계선 불러오기
    addPolygons(data = bnd, weight = 3, color = "red", fill = NA) %>% 
    # 래스터 이미지 불러오기
    addRasterImage(raster_high, 
                   colors = colorNumeric( c("blue", "green", "yellow", "red"),values(raster_high), na.color = "transparent"), opacity = 0.4)
    
# 저장하기
dir.create("R/DAOU/07_map")
save(raster_high, file="R/DAOU/07_map/07_kde_high.rdata")
rm(list=ls())
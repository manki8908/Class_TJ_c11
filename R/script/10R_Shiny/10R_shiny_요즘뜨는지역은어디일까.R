# 요즘 뜨는 지역은 어디일까?
library(sf)

load("R/DAOU/06_geodataframe/06_apt_price.rdata")
grid <- st_read("R/data/seoul/seoul.shp")
apt_price <- st_join(apt_price, grid, join= st_intersects)
head(apt_price, 2)

## before
kde_before <- subset(apt_price, ymd < "2021-07-01") # 이전 데이터 필터링
kde_before <- aggregate(kde_before$py, by=list(kde_before$ID), mean) # 평균
colnames(kde_before) <- c("ID", "before") # 칼럼명 변경

# after
kde_after <- subset(apt_price, ymd > "2021-07-01") # 이전 데이터 필터링
kde_after <- aggregate(kde_after$py, by=list(kde_after$ID), mean) # 평균
colnames(kde_after) <- c("ID", "after") # 칼럼명 변경
head(kde_after)

# diff
kde_diff <- merge(kde_before, kde_after, by="ID") # 이전 + 이후 데이터 결합
kde_diff$diff <- round((((kde_diff$after-kde_diff$before)/ kde_diff$before)*100), 0)

head(kde_diff,2)


# 시각화
#kde_diff <- kde_diff[kde_diff$diff > 0,] # 상승지역만 추출
#kde_hot <- merge(grid,kde_diff, by="ID") # 그리드와 결합
#library(ggplot2)
#library(dplyr)
#kde_hot %>% 
#    ggplot(aes(fill=diff)) + geom_sf() + 
#    scale_fill_gradient(low="white", high="red")
library(sp)
kde_hot_sp <- as(st_geometry(kde_hot), "Spatial")  

# 그리드 중심, x/y 좌표 추출
x <- coordinates(kde_hot_sp)[,1]   
y <- coordinates(kde_hot_sp)[,2]

# 기준경계 설정
l1 <- bbox(kde_hot_sp)[1,1] - (bbox(kde_hot_sp)[1,1]*0.0001)
l2 <- bbox(kde_hot_sp)[1,2] + (bbox(kde_hot_sp)[1,2]*0.0001)
l3 <- bbox(kde_hot_sp)[2,1] - (bbox(kde_hot_sp)[2,1]*0.0001)
l4 <- bbox(kde_hot_sp)[2,2] + (bbox(kde_hot_sp)[1,1]*0.0001)
l1;l2;l3;l4
library(spatstat)
win <- owin(xrange=c(l1,l2), yrange=c(l3,l4)) # 지도 영역설정
plot(win) # 지도 경계선 확인
rm(list=c("kde_hot_sp", "apt_price", "l1", "l2", "l3", "l4"))


# 밀도 그래프 표시
p <- ppp(x, y, window = win)  # 경계선 위에 좌표값 포인트 생성
# 층을 쌓음(density)
d <- density.ppp(p, weights = kde_hot$diff, 
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
raster_hot <- raster(d)
plot(raster_hot)


# 클리핑
bnd <- st_read("R/data/sigun_bnd/seoul.shp") # 서울시 경계선 데이타
raster_hot <- crop(raster_hot, extend(bnd))  # 외곽선 자르기
crs(raster_hot) <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")  # 좌표계 정의

plot(raster_hot)  # 지도 확인
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
    addRasterImage(raster_hot, 
                   colors = colorNumeric( c("blue", "green", "yellow", "red"),values(raster_hot), na.color = "transparent"), opacity = 0.4)

dir.create("R/DAOU/07_map")
save(raster_hot, file="R/DAOU/07_amp/07_kde_hot.rdata")

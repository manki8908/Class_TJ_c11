install.packages('sp')  # 맵핑 옛날버전
install.packages('sf')  # 최근버전
install.packages('leaflet')
#library(stringr)    # 문자열 처리하는 패키지
#library(plyr)
#library(httr)
#library(RJSONIO)
#library(data.table)
library(dplyr)
library(sp)
library(sf)
library(leaflet)

# .. data load
load("R/DAOU/04_preprocess/04_preprocess.rdata")
load("R/DAOU/05_geocoding/05_juso_geocoding.rdata")

# .. 주소와 좌표 결합
apt_price <- left_join(apt_price1,juso_geocoding, by=c('juso_jibun'='apt_juso'))
#head(apt_price)
dim(apt_price)

# .. 결측제거
apt_price <- na.omit(apt_price)
dim(apt_price)

# .. 지오데이터 프레임생성하기
coordinates(apt_price) <- ~coord_x + coord_y   #좌표값 할당
proj4string(apt_price) <- "+proj=longlat +datum=WGS84 +no_defs" # 좌표계(CRS) 정의
apt_price <- st_as_sf(apt_price)  # sp to sf 형 변환

# 시각화
plot(apt_price$geometry, axes=T, pch=1)
leaflet() %>% 
    addTiles() %>% 
    addCircleMarkers(data = apt_price[1:1000,], label=~apt_nm)


# 저장
dir.create("R/DAOU/06_geodataframe")
save(apt_price, file="R/DAOU/06_geodataframe/06_apt_price.rdata")
write.csv(apt_price, "R/DAOU/06_geodataframe/06_apt_price.csv")

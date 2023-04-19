# 8-1 데이터 만들기

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
    

# 전체지역 / 관심지역 저장
library(dplyr)
apt_price <-  st_join(apt_price, grid, join = st_intersects) # 실거래 + 그리드
apt_price <- apt_price %>% st_drop_geometry() # 실거래 공간 속성 지우기
all <- apt_price
sel <- apt_price %>% filter(ID==81016)   # 제일 최고가, 개봉동?
dir.create("R/DAOU/08_chart")
save(all, file="R/DAOU/08_chart/08_all.rdata")
save(sel, file="R/DAOU/08_chart/08_sel.rdata")


# 8-2 
rm(list = ls())

# .. load
load("R/DAOU/08_chart/08_all.rdata")  #
load("R/DAOU/08_chart/08_sel.rdata")  #

# 확률밀도함수 적용
max_all <- density(all$py)
max_sel <- density(sel$py)
head(max_all,2)

# 최대값 산출, plot 할때 범위 지정하기 위해
max_all <- max(max_all$y)
max_sel <- max(max_sel$y)
max_all; max_sel

# 최대값, 평균
plot_high <- max(max_all, max_sel) # y축의 최대값 찾기
rm(list = c("max_all", "max_sel"))
avg_all <- mean(all$py)  # 평당 평균가격
avg_sel <- mean(sel$py)  # 평당 평균가격
avg_all; avg_sel; plot_high

# .. 시각화
# 전체지역 확률밀도함수
plot(stats::density(all$py), ylim=c(0,plot_high),
     col="blue", lwd=3, main=NA) 
# 전체지역 평균 수직선
abline(v=avg_all, lwd=2, col="blue", lty=2)
# 전체지역 평균 텍스트 입력
text(avg_all + (avg_all)*0.15, plot_high*0.1,
     sprintf("%.0f",avg_all), str=0.2, col="blue")

# 관심지역 확률밀도함수
lines(stats::density(sel$py), col="red", lwd=3)  
# 관심지역 평균 수직선
abline(v=avg_sel, lwd=2, col="red", lty=2)
# 관심지역 평균 텍스트 입력
text(avg_sel + (avg_sel)*0.15, plot_high*0.1,
     sprintf("%.0f",avg_sel), str=0.2, col="red")

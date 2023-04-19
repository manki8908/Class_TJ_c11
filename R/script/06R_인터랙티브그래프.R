# 웹에서도 동작

library(dplyr) # 전처리
library(ggplot2) # 시각화
library(readxl) # 엑셀 파일 불러오기
library(multilinguer)
library(KoNLP)
library(stringr)
library(wordcloud)
library(RColorBrewer)  # 색깔 
useNIADic()

library(ggiraphExtra)
library(mapproj)
library(tibble)   # dplyr과 함께 설치됨, 컬럼과 행 바꾸기

install.packages("plotly")
library(plotly)

p <- ggplot(data = mpg, aes(x = displ, y = hwy, col = drv)) + geom_point()
p
ggplotly(p)

p <- ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
    geom_bar(position = "dodge")
ggplotly(p)


# .. 인터랙티브 시계열 그래프 만들기
install.packages("dygraphs")
library(dygraphs)

# 데이터 로드
economics <- ggplot2::economics
str(economics)
head(economics)

# 날짜 순서대로 정렬
library(xts)
eco <- xts(economics$unemploy, order.by = economics$date)
head(eco)

# 시계열
dygraph(eco)

dygraph(eco) %>% dyRangeSelector()


# 저축률
eco_a <- xts(economics$psavert, order.by = economics$date)
head(eco_a)

# 실업자 수
eco_b <- xts(economics$unemploy/1000, order.by = economics$date)
head(eco_b)

# 합치기
eco2 <- cbind(eco_a, eco_b) # 데이터 결합
colnames(eco2) <- c("psavert", "unemploy") # 변수명 바꾸기
head(eco2)


dygraph(eco2) %>% dyRangeSelector()

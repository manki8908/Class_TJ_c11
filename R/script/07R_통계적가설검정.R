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
library(plotly)

# data load
mpg <- as.data.frame(ggplot2::mpg)
head(mpg)
table(mpg$class)


# compact와 suv 도시연비(cty) 추출
mpg_diff <- mpg %>%
    select(class, cty) %>%
    filter(class %in% c("compact", "suv"))
head(mpg_diff)
table(mpg_diff$class)

#?t.test
# cty ~ class: 연비를 볼껀데 class를 기준으로 볼것이다
# var.equal=T 두집단간의 분산이 같다 -> 왜해주는지?, 책찾아보기
t.test(data = mpg_diff, cty ~ class, var.equal = T)

# 일반휘발유 고급휘발유 도시연비 t검정
mpg_diff2 <- mpg %>%
    select(fl, cty) %>%
    filter(fl %in% c("r", "p")) # r:regular, p:premium
table(mpg_diff2$fl)

t.test(data = mpg_diff2, cty ~ fl, var.equal = T)


# 상관관계 - 실업자 수 vs 개인 소비 지출
# data load
economics <- as.data.frame(ggplot2::economics)

cor.test(economics$unemploy, economics$pce)

# 상관행렬(Correlation Matrix), 히트맵 만들기
# 자료 확인
head(mtcars)

# 상관행렬 생성
car_cor <- cor(mtcars)
car_cor
round(car_cor, 1) # 소수점 셋째 자리에서 반올림해서 출력

# 히트맵 그리기
install.packages("corrplot")
library(corrplot)
corrplot(car_cor)

# 숫자로 표기
corrplot(car_cor, method = "number")

# 다양한 옵션
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(car_cor,
         method = "color", # 색깔로 표현
         col = col(200), # 색상 200 개 선정
         type = "lower", # 왼쪽 아래 행렬만 표시
         order = "hclust", # 유사한 상관계수끼리 군집화
         addCoef.col = "black", # 상관계수 색깔
         tl.col = "black", # 변수명 색깔
         tl.srt = 45, # 변수명 45 도 기울임
         diag = F) # 대각 행렬 제외

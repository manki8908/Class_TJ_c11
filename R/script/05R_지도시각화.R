# 지도 시각화
#install.packages("ggiraphExtra")
#install.packages("mapproj")


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




# .. 범죄 data load
str(USArrests)

head(USArrests)

# 행 이름을 state 변수로 바꿔 데이터 프레임 생성
crime <- rownames_to_column(USArrests, var = "state")
head(crime)

# 지도 데이터와 동일하게 맞추기 위해 state 의 값을 소문자로 수정
crime$state <- tolower(crime$state)

str(crime)

# .. 미국 주 지도 데이터 준비
install.packages("maps")  # 미국의 위도경도 정보가 있는 패키지
states_map <- map_data("state")
str(states_map)

ggChoropleth(data = crime, # 지도에 표현할 데이터
             aes(fill = Murder, # 색깔로 표현할 변수
                 map_id = state), # 지역 기준 변수
             map = states_map) # 지도 데이터

ggChoropleth(data = crime, # 지도에 표현할 데이터
             aes(fill = Murder, # 색깔로 표현할 변수
                 map_id = state), # 지역 기준 변수
             map = states_map, # 지도 데이터
             interactive = T) # 인터랙티브


# 대한민국 시도별 인구, 결핵 환자 수 단계 구분도 만들기
install.packages("stringi")
install.packages("devtools")
devtools::install_github("cardiomoon/kormaps2014")
library(kormaps2014)

# 데한민국 시도별 인구데이터 
# 데이터 확인
str(changeCode(korpop1)) # 인코딩 바꿔줌(changeCode)

korpop1 <- rename(korpop1,
                  pop = 총인구_명,
                  name = 행정구역별_읍면동)

korpop1$name <- iconv(korpop1$name, "UTF-8", "CP949")

# 데이터 확인
str(kormap1)



# 단계구분도 시각화
ggChoropleth(data = korpop1, # 지도에 표현할 데이터
             aes(fill = pop, # 색깔로 표현할 변수
                 map_id = code, # 지역 기준 변수
                 tooltip = name), # 지도 위에 표시할 지역명
             map = kormap1, # 지도 데이터
             interactive = T) # 인터랙티브


# .. 대한민국 시도별 결핵 환자 수 단계 구분도 만들기
rm(tbc)
str(changeCode(tbc))
head(changeCode(tbc))

tbc$name <- iconv(tbc$name, "UTF-8", "CP949")
head(tbc)
ggChoropleth(data = tbc, # 지도에 표현할 데이터
             aes(fill = NewPts, # 색깔로 표현할 변수
                 map_id = code, # 지역 기준 변수
                 tooltip = name), # 지도 위에 표시할 지역명
             map = kormap1, # 지도 데이터
             interactive = T) # 인터랙티


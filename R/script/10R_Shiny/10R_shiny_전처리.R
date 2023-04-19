# 10R_shiny_01.R 출력 데이터 전처리

#library(XML)
#library(data.table)
library(stringr)    # 문자열 처리하는 패키지
#library(plyr)

load("R/DAOU/03_integrated/03_apt_price.rdata")
head(apt_price)

# .. 전처리 1단계: 결측 처리
table(is.na(apt_price))
apt_price <- na.omit(apt_price)  # 결측제거
table(is.na(apt_price))
dim(apt_price)
class(apt_price)

# .. 전처리 2단계: 공백제거
# apply 1:행, 2:열
apt_price <- as.data.frame(apply(apt_price, 2, str_trim))
head(apt_price$price, 2)

# .. 전처리 3단계: 항목별 데이터 다듬기
# 3-1 매매 연월일, 데이터 만들기
apt_price <- apt_price %>% 
                mutate(ymd = make_date(year,month,day))  # YYYY-MM-DD
head(apt_price,2)
apt_price$ym <- floor_date(apt_price$ymd, "month")  # 월단위 날짜정보 산출
head(apt_price,2)

# 3-2 매매가 처리, 현재 문자열 -> 숫자로 변경
head(apt_price$price,4)  
apt_price$price <- apt_price$price %>% 
                    sub(",", "", .) %>% as.numeric()  # .은 전체에서 컴마를 찾아서
?sub
head(apt_price$price,3)

# 3-3 주소 조합
head(apt_price$apt_nm,30)
apt_price$apt_nm <- gsub("\\(.*","",apt_price$apt_nm)
head(apt_price$apt_nm,30)

# 아파트 이름, 지역코드, 주소를 조합
head(apt_price,4)
loc <- read.csv("R/data/sigun_code.csv", fileEncoding = "UTF-8")
apt_price <- merge(apt_price, loc, by= 'code')
head(apt_price,4)
apt_price$juso_jibun <- paste0(apt_price$addr_2, " ",
                               apt_price$dong_nm, " ",
                               apt_price$jibun, " " ,
                               apt_price$apt_nm)
head(apt_price,4) # 카카오에서 쓰기위해 주소 조합


# .. 전처리 4단계: 건축연도 숫자 변환
class(apt_price$year)
apt_price$year <- apt_price$year %>% as.numeric()
class(apt_price$year)

# .. 전처리 5단계: 평당 매매가 
# 5-1 면적 숫자화 및 소수점, round=0
class(apt_price$area)
apt_price$area <- apt_price$area %>% as.numeric() %>% round(0)
class(apt_price$area)
head(apt_price)

# 5-2 평으로 변환(m2*3.3=평) 및 평당 매매가
apt_price$py <- round(apt_price$price/apt_price$area*3.3, 0)
head(apt_price$py)

# 5-3 "-1" 지하1층 -> 1층으로?
table(apt_price$floor)
apt_price$floor <- apt_price$floor %>% as.numeric() %>% abs()
table(apt_price$floor)


# .. 전처리 6단계: 빈도 세기위해 cnt=1 초기화
apt_price$cnt <- 1
head(apt_price,3)

# .. 필요 칼럼만 추출
apt_price1 <- apt_price %>% select(ymd,ym,year,code,addr_1,
                                  apt_nm,juso_jibun,price,con_year,area,floor,
                                  py,cnt)
head(apt_price1,2)


# .. 중간저장
dir.create("R/DAOU/04_preprocess")
save(apt_price1, file="R/DAOU/04_preprocess/04_preprocess.rdata")
write.csv(apt_price1, "R/DAOU/04_preprocess/04_preprocess.csv")

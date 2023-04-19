# 카카오 API로 보내서 위경도값 가져오기
#install.packages('httr')
#install.packages('RJSONIO')
#install.packages('rjson')

library(stringr)    # 문자열 처리하는 패키지
library(plyr)
library(httr)
#library(RJSONIO)
library(rjson)
library(data.table)
library(dplyr)

# .. data load
load("R/DAOU/04_preprocess/04_preprocess.rdata")
apt_price <- apt_price1


# .. 주소 편집
apt_juso <- data.frame(apt_price$juso_jibun)             # 주소 칼럼 추출
apt_juso <- data.frame(apt_juso[!duplicated(apt_juso),]) # 중복 제거
dim(apt_juso)
head(apt_juso,2)

# .. 주소를 좌표로 변환하는 지오코딩
add_list <- list()
cnt <- 0
key_file <- "C:/Users/tjoeun/Desktop/수업자료/수업_실습/API/카카오API.txt"
kakao_key <- readLines(key_file)

for(i in 1:nrow(apt_juso)){ 
    #---# 에러 예외처리 구문 시작
    tryCatch(
        {
            #---# 주소로 좌표값 요청
            lon_lat <- GET(url = 'https://dapi.kakao.com/v2/local/search/address.json',
                           query = list(query = apt_juso[i,]),
                           add_headers(Authorization = paste0("KakaoAK ", kakao_key)))
            #---# 위경도만 추출하여 저장 
            coordxy <- lon_lat %>% content(as = 'text') %>% RJSONIO::fromJSON()
            #---# 반복횟수 카운팅
            cnt = cnt + 1
            #---# 주소, 경도, 위도 정보를 리스트로 저장
            add_list[[cnt]] <- data.table(apt_juso = apt_juso[i,], 
                                          coord_x = coordxy$documents[[1]]$x, 
                                          coord_y = coordxy$documents[[1]]$y)
            #---# 진행상황 알림 메시지
            message <- paste0("[", i,"/",nrow(apt_juso),"] 번째 (", 
                              round(i/nrow(apt_juso)*100,2)," %) [", apt_juso[i,] ,"] 지오코딩 중입니다: 
       X= ", add_list[[cnt]]$coord_x, " / Y= ", add_list[[cnt]]$coord_y)
            cat(message, "\n\n")
            #---# 예외처리 구문 종료
        }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")}
    )
}


juso_geocoding <- rbindlist(add_list)  # 리스트 -> 데이터 프레임
juso_geocoding$coord_x <- as.numeric(juso_geocoding$coord_x)
juso_geocoding$coord_y <- as.numeric(juso_geocoding$coord_y)
juso_geocoding <- na.omit(juso_geocoding)
dir.create("R/DAOU/05_geocoding")
save(juso_geocoding, file="R/DAOU/05_geocoding/05_juso_geocoding.rdata")
write.csv(juso_geocoding, "R/DAOU/05_geocoding/05_juso_geocoding.csv")

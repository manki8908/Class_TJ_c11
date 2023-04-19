#install.packages("rstudioapi") # studioapi 설치
#install.packages("XML")
#install.packages("data.table")
#install.packages("stringr")
library(XML)
library(data.table)
library(stringr)
library(plyr)    # install.packages("plyr")
getwd()  # 루트 디렉토리 확인


# .. load
loc <- read.csv("R/data/sigun_code.csv", fileEncoding = "UTF-8")
View(loc)

# .. 처리
loc$code <- as.character(loc$code)
head(loc)


# .. 수집기간 설정하기
datelist <- seq(from = as.Date('2021-01-01'),
                to   = as.Date('2021-12-31'),
                by   = '1 month')
datelist <- format(datelist, format = '%Y%m') # 형식변환(YYYY-MM-DD->YYYYMM)
datelist[1:3]
length(datelist)

# .. 인증키
key_file <- "C:/Users/tjoeun/Desktop/수업자료/수업_실습/API/공공데이터_API_key_encoding.txt"
service_key <- readLines(key_file)
url_base <- "http://openapi.molit.go.kr:8081/OpenAPI_ToolInstallPackage/service/rest/RTMSOBJSvc/getRTMSDataSvcAptTrade?"

# .. 요청 목록 만들기 api url에 지역코드,날짜 삽입하기
url_list <- list()
cnt <- 0
for (i in 1:nrow(loc)) {
    for (j in 1:length(datelist)) {
        cnt <- cnt + 1
        # 요청 목록 채우기  ( 25X12=300 )
        url_list[cnt] <- paste0(url_base,
                                "LAWD_CD=", loc[i,1],
                                "&DEAL_YMD=", datelist[j],
                                "&num0fRows=", 100,
                                "&serviceKey=", service_key)
    }
    
    Sys.sleep(0.1)
    msg <- paste0("[",i,"/",nrow(loc),"] ", loc[i,3], "의 크롤링 목록이 생성됨 => [", cnt,"] 건")
    cat(msg, "\n\n")
}

# 가져올 url 목록 확인
head(url_list)
length(url_list)
url_list[1]
browseURL(paste0(url_list[1])) # 정상 동작 확인


# 크롤러 제작
raw_data <- list()   # XML 임시저장소
root_Node <- list()  # 거래 내역 추출 임시
total <- list()      # 거래 내역 정리 임시
dir.create("R/DAOU/02_raw_data_test")


# URL 자료 요청 및 응답받기
for(i in 1:length(url_list)){
    raw_data[[i]] <- xmlTreeParse(url_list[i], useInternalNodes = TRUE,
                                encoding = 'utf-8')  # 결과 저장
    root_Node[[i]] <- xmlRoot(raw_data[[i]]) # xmlRoot로 루트 노드이하 추출
    items <- root_Node[[i]][[2]][['items']]   # 전체 거래 내역(items) 추출
    size <- xmlSize(items)                   # 전체 거래 건수 확인
    item <- list()  # 전체 거래 내역 저장 임시 리스트
    item_temp_dt <- data.table()  # 세부 거래 내역 저장 임시, data frame 뼈대
    Sys.sleep(.1)
    for(m in 1:size) {
        item_temp <- xmlSApply(items[[m]], xmlValue)
        item_temp_dt <- data.table(year = item_temp[4],     # 거래 연도
                                   month = item_temp[7],    # 거래 월
                                   day = item_temp[8],      # 거래 일
                                   price = item_temp[1],    # 거래 금액
                                   code = item_temp[12],    # 지역 코드
                                   dong_nm = item_temp[5],  # 법정동
                                   jibun = item_temp[11],   # 지번
                                   con_year = item_temp[3], # 건축 연도
                                   apt_nm = item_temp[6],   # 아파트 이름
                                   area = item_temp[9],     # 전용면적
                                   floor = item_temp[13])   # 층수
        item[[m]] <- item_temp_dt # 분리된 거래 내역 순서대로 저장
    }
    apt_bind <- rbindlist(item)   # 통합 저장
    # 응답내역 저장
    region_nm <- subset(loc, code = str_sub(url_list[i], 155, 199))$addr_1 # 지역명
    month <- str_sub(url_list[i], 130, 135)  # 연월(YYYYMM)
    path <- as.character(paste0("./02_raw_data_test/", region_nm, "_", month, ".csv"))
    write.csv(apt_bind, path) # csv 저장
    msg <- paste0("[", i, "/", length(url_list), "] 수집한 데이터를 [", path,
                  "]에 저장합니다")  # 알림메세지
    cat(msg, "\n\n")
}


# .. 추출 파일 결합 및 재저장
files <- dir('R/DAOU/02_raw_data_test')
files
apt_price <- ldply(as.list(paste0("R/DAOU/02_raw_data/",files)), read.csv)  # 결합
tail(apt_price, 2)  # 확인

dir.create("R/DAOU/03_integrated")
save(apt_price, file = "R/DAOU/03_integrated/03_apt_price.rdata")
write.csv(apt_price, "R/DAOU/03_integrated/03_apt_price.csv")

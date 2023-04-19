# 4장
# 4-1 DataFrame
eng <- c(90,80,60,70)
math <- c(50,60,100,20)
class <- c(1,1,2,2)
df <- data.frame(eng,math,class)
df

df2 <- data.frame(eng=c(90,80,70),
                  mat=c(20,30,40),
                  cls=c(1,2,3))
df2


# 4-3 외부데이터 로드
install.packages('readxl')
library(readxl)

df_ex1 <- read_excel("./R/data/excel_exam.xlsx")
df_ex1

# 컬럼명이 없는 데이터
df_ex2 <- read_excel("./R/data/excel_exam_novar.xlsx", col_names = F)
df_ex2

# 시트가 있는 엑셀
df_ex3 <- read_excel("./R/data/excel_exam_sheet.xlsx", sheet=3)
df_ex3

# 저장
write.csv(df_ex2, file='df_ex2.csv')

# saveRDS()  R 전용 확장자(처리속도 향상)
saveRDS(df_ex2, file='df_ex2_RDSformat')

# 제거
rm(df_ex1)
rm(df_ex2)
rm(df_ex3)

#
df_ex3 <- readRDS('df_ex2_RDSformat')
df_ex3

#
df_ex1 <- read.csv("./R/data/csv_exam.csv")
head(df_ex1,10)
tail(df_ex1,3)
View(df_ex1)     # 뷰창
dim(df_ex1)      # 차원확인
str(df_ex1)      # 데이터 속성 확인
summary(df_ex1)  # 기본 통계

# ggplot mpg 데이터 데이터프레임 형태로 불러오기
library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)
head(mpg,5)
dim(mpg)
summary(mpg)


# 5-2 변수명 바꾸기
install.packages("dplyr")
library(dplyr)
df_raw <- data.frame(var1=c(1,2,3),
                     var2=c(2,3,4))
df_raw

# 깊은복사 
df_new <- df_raw
df_new <- rename(df_new,v2=var2)
df_raw
df_new

mpg_new <- mpg
mpg_new <- rename(mpg,city=cty,highway=hwy)
mpg_new
mpg

# 5-3 파생변수
df <- data.frame(var1=c(4,3,8),
                 var2=c(2,6,1))
df
df$var_sum <- df$var1 + df$var2
df
df$var_mean <- (df$var1 + df$var2)/2
df

# total 컬럼, 통합연비(city, highway 평균)
mpg_new$total <- (mpg_new$city + mpg$hwy)/2
summary(mpg_new)

# histogram
hist(mpg_new$total)

# total 기준으로 A,B,C 등급 분류
mpg_new$grade <- ifelse (mpg_new$total >= 30, 'A', ifelse(mpg_new$total >=20, 'B', 'C'))
table(mpg_new$grade)   # 항목 카운트

qplot(mpg_new$grade)

# add grade2
mpg_new$grade2 <- ifelse (mpg_new$total >= 30, 'A', 
                          ifelse(mpg_new$total >=25, 'B',
                                 ifelse(mpg_new$total >=20, 'C', 'D')))
table(mpg_new$grade2)
qplot(mpg_new$grade2)

mpg_new$test <- ifelse (mpg_new$total >= 20, 'Pass', 'Fail')
table(mpg_new$test)
qplot(mpg_new$test)

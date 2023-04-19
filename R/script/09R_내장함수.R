library(dplyr) # 전처리
library(ggplot2) # 시각화

exam <- read.csv("R/data/csv_exam.csv")

exam[] # 내장인덱싱 기능 전데이터
exam[1,] # 1 행 추출
exam[2,] # 2 행 추출
exam[exam$class == 1,] # class 가 1 인 행 추출
exam[exam$math >= 80,] # 수학점수가 80 점 이상인 행 추출
exam[exam$class == 1 & exam$math >= 50,] # 1 반 이면서 수학점수가 50 점 이상
exam[exam$english < 90 | exam$science < 50,] # 영어점수가 90 점 미만이거나 과학점수가 50 점 미만

exam[,1] # 첫 번째 열 추출
exam[,2] # 두 번째 열 추출
exam[,3] # 세 번째 열 추출
exam[, "class"] # class 변수 추출
exam[, "math"] # math 변수 추출
exam[,c("class", "math", "english")] # class, math, english 변수 추출

# 행, 변수 모두 인덱스
exam[1,3]

# 행 인덱스, 열 변수명
exam[5, "english"]

# 행 부등호 조건, 열 변수명
exam[exam$math >= 50, "english"]

# 행 부등호 조건, 열 변수명
exam[exam$math >= 50, c("english", "science")]



# 문제) 수학 점수 50 이상, 영어 점수 80 이상인 학생들을 대상으로 각 반의 전 과목 총평균을 구하라
# 내장함수
exam$tot <- (exam$math + exam$english + exam$science)/3
exam
aggregate(data=exam[exam$math >= 50 & exam$english >= 80,], tot~class, mean)

# dplyr 코드
exam %>%
    filter(math >= 50 & english >= 80) %>%
    mutate(tot = (math + english + science)/3) %>%
    group_by(class) %>%
    summarise(mean = mean(tot))



# 혼자서 해보기 
# 아래는 dplyr 패키지 함수들을 이용해 "compact"와 "suv" 차종의 '도시 및 고속도로 통합 연비' 평균을 구하는 코드입니다
mpg <- as.data.frame(ggplot2::mpg) # mpg 데이터 불러오기
mpg %>%
    mutate(tot = (cty + hwy)/2) %>% # 통합 연비 변수 생성
    filter(class == "compact" | class == "suv") %>% # compact, suv 추출
    group_by(class) %>% # class 별 분리
    summarise(mean_tot = mean(tot))

# dplyr 대신 R 내장 함수를 이용해 "suv"와 "compact"의 '도시 및 고속도로 통합 연비' 평균을 구해보세요.
#aggregate(data=exam$cty + exam$hwy)/2)


# 15-2. 변수 타입

var1 <- c(1,2,3,1,2) # numeric 변수 생성
var2 <- factor(c(1,2,3,1,2)) # factor 변수 생성
class(var1)
class(var2)
levels(var1)
levels(var2)
mean(var1)
mean(var2)

var1+2
var2+2

var3 <- c("a", "b", "b", "c") # 문자 변수 생성
var4 <- factor(c("a", "b", "b", "c")) # 문자로 된 factor 변수 생성
class(var3)
class(var4)
levels(var3)
levels(var4)
mean(var3)
mean(var4)


# 타입변경
var2 <- as.numeric(var2)
class(var2)
levels(var2)


# mpg 데이터의 drv 변수는 자동차의 구동 방식을 나타냅니다. mpg 데이터를 이용해 아래 문제를 해결해 보세요.

# Q1. drv 변수의 타입을 확인해 보세요
class(mpg$drv)

# Q2. drv 변수를 as.factor()를 이용해 factor 타입으로 변환한 후 다시 타입을 확인해 보세요.
mpg$drv <- as.factor(mpg$drv)
class(mpg$drv)

# Q3. drv가 어떤 범주로 구성되는지 확인해 보세요
levels(mpg$drv)


# .. 데이터 구조
# 벡터 만들기, 1차원
a <- 1

# 데이터 프레임 만들기, 2차원
x1 <- data.frame(var1 = c(1,2,3),
                 var2 = c("a","b","c"))
x1
x2 <- matrix(c(1:12), ncol = 2)
x2

# array 만들기, 3차원
# 1~20 으로 2 행 x 5 열 x 2 차원
x3 <- array(1:20, dim = c(2, 5, 2))
x3

# 리스트 생성, 모든차원의 데이터를 포함
# 앞에서 생성한 데이터 구조 활용
x4 <- list(f1 = a, # 벡터
           f2 = x1, # 데이터 프레임
           f3 = x2, # 매트릭스
           f4 = x3) # 어레이

x4

# 리스트 예, box plot 통계 반환
mpg <- ggplot2::mpg
x <- boxplot(mpg$cty)
x

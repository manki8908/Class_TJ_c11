library(dplyr)

# 함수적용 %>%, 단축키 ctrl + shift + M
exam <- read.csv('./R/data/csv_exam.csv')

# 1반인경우
exam %>% filter(class == 1)

# 2반인경우
exam %>% filter(class == 2)

# 1반 아닌 경우
exam %>% filter(class != 1)

# 2반 아닌 경우
exam %>% filter(class != 2)

# 3반 아닌 경우
exam %>% filter(class != 3)

# 수학점수가 50점 초과 한 경우
exam %>% filter(math > 50)

# 수학점수가 50점 미만인 경우
exam %>% filter(math < 50)

# 영어점수가 80점 초과 한 경우
exam %>% filter( english >= 80)

# 영어점수가 80점 미만 경우
exam %>% filter(english <= 80)

# 1반이면서 수학점수가 50점 이상
exam %>% filter(class == 1 & math >= 50)

# 2반이면서 영어점수가 80점 이상
exam %>% filter(class == 2 & english >= 80)

# 수학점수가 90점 이상 이거나 영어 점수가 90점 이상
exam %>% filter(english >= 90 | math >= 50)

# 영어점수가 90점 미만 이거나 과학 점수가 50점 미만
exam %>% filter(english < 90 | science < 50)

# 1, 3, 5 반에 해당되면 추출

# or
exam %>% filter(class == 1 | class == 3 | class == 5)

# %in%
exam %>% filter(class %in% c(1,3,5))

# class가 1인 행을 추출해서 1반의 수학평균 구하기
class1 <- exam %>% filter(class == 1) # class 가 1 인 행 추출, class1 에 할당

# class가 2인 행을 추출해서 2반의 수학평균 구하기
class2 <- exam %>% filter(class == 2) # class 가 2 인 행 추출, class2 에 할당

mean(class1$math)
mean(class2$math)

# 혼자서 해보기
library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)
head(mpg)

# Q1
displ_4 <- mpg %>% filter(displ == 4)
displ_5 <- mpg %>% filter(displ == 5)
#head(displ_4)
mean(displ_4$hwy); mean(displ_5$hwy)

# Q2
audi <- mpg %>% filter(manufacturer == 'audi')
toyota <- mpg %>% filter(manufacturer == 'toyota')

mean(audi$cty); mean(toyota$cty)

# Q3
# Q3
car3 <- mpg %>% filter(manufacturer %in% c('chevrolet','ford','honda'))
mean(car3$hwy)

# 6-3 필요한 컬럼만 추출하기
# select()
exam %>% select(math)
exam %>% select(english)
exam %>% select(math, english, class)
exam %>% select(-math)
exam %>% select(-math, -english)

# class가 1반이면서 english만 추출
exam %>% 
    filter(class==1) %>%
    select(english)

# id, math 추출 앞에 6개만 추출
exam %>% 
    select(id, math) %>%
    head()

# id, math 추출 앞에 10개만 추출
exam %>% 
    select(id, math) %>%
    head(10)

# 혼자서 해보기2
mpg <- as.data.frame(ggplot2::mpg)
head(mpg)

# Q1
mpg_new <- mpg %>% select(class, cty)
head(mpg_new)

# Q2
suv <- mpg %>% filter(class == 'suv')
com <- mpg %>% filter(class == 'compact')

mean(suv$cty); mean(com$cty)


# 6-4 정렬하기
exam %>% arrange(desc(math))
exam %>% arrange(class, math)

# Q1
mpg %>% filter(manufacturer == 'audi') %>%
    arrange(mpg_audi$hwy) %>%
    head(5)

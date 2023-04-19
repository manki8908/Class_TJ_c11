install.packages("foreign") # foreign 패키지 설치, Spss툴
library(foreign) # SPSS 파일 로드
library(dplyr) # 전처리
library(ggplot2) # 시각화
library(readxl) # 엑셀 파일 불러오기

# 데이터 불러오기
raw_welfare <- read.spss(file = "./R/data/Koweps_hpc10_2015_beta1.sav",
                         to.data.frame = T)

# 복사본 만들기
welfare <- raw_welfare

head(welfare)
#tail(welfare)
#View(welfare)
dim(welfare)
str(welfare)
#summary(welfare)

# 변수명 바꾸기
# 바꿀 이름, 원래 이름
welfare <- rename(welfare,
                  sex = h10_g3, # 성별
                  birth = h10_g4, # 태어난 연도
                  marriage = h10_g10, # 혼인 상태
                  religion = h10_g11, # 종교
                  income = p1002_8aq1, # 월급
                  code_job = h10_eco9, # 직종 코드
                  code_region = h10_reg7) # 지역 코드
head(welfare)


# .. 전처리
class(welfare$sex)
table(welfare$sex)

# 결측 및 이상치 처리
# 성별
welfare$sex <- ifelse(welfare$sex == 9, NA, welfare$sex)
table(is.na(welfare$sex))

# 성별에 항목 이름부여
welfare$sex <- ifelse(welfare$sex == 1, "male", "female")
table(welfare$sex)

qplot(welfare$sex)

# 월급정보
class(welfare$income)
summary(welfare$income)
qplot(welfare$income,bins = 30) + xlim(0,1000) + ylim(0,2000) # 확대
?qplot

# 월급 이상치 결측 처리
welfare$income <- ifelse(welfare$income %in% c(0,9999), NA, welfare$income)


# 결측치 확인
table(is.na(welfare$income))


# 성별 월급 평균표 만들기
sex_income <- welfare %>%
    filter(!is.na(income)) %>%
    group_by(sex) %>%
    summarise(mean_income = mean(income))
sex_income
ggplot(data=sex_income, aes(x=sex, y=mean_income)) + geom_col()

# .. 나이값 정제
class(welfare$birth)
summary(welfare$birth)
qplot(welfare$birth)

# .. 결측 및 이상치 처리
welfare$birth <- ifelse(welfare$birth == 9999, NA, welfare$birth)
table(is.na(welfare$birth))

# 나이추출: 생년 - 조사년도 + 1
welfare$age <- 2015 - welfare$birth + 1
summary(welfare$age)
qplot(welfare$age, binwidth=30)

# 1. 나이에 따른 월급 평균표 만들기
age_income <- welfare %>%
    filter(!is.na(income)) %>%
    group_by(age) %>% 
    summarise(mean_income=mean(income,rm.na=T))
age_income
ggplot(data=age_income, aes(x=age, y=mean_income)) + geom_col()


# 연령대 분류 30, 60
welfare <- welfare %>% 
    mutate(ageg = ifelse( welfare$age < 30, 'young',
                          ifelse( welfare$age <=59, 'middel', 'old')))
qplot(welfare$ageg)

# 연령대에 따른 월급 차이분석
ageg_income <- welfare %>%
    filter(!is.na(income)) %>%
    group_by(ageg) %>% 
    summarise(mean_income=mean(income,rm.na=T))
ageg_income
ggplot(data=ageg_income, aes(x=ageg, y=mean_income)) + geom_col() + 
    scale_x_discrete(limits = c("young", "middle", "old"))



# 연령대 및 성별에 따른 월급 차이분석
ageg_sex_income <- welfare %>%
    filter(!is.na(income)) %>%
    group_by(ageg,sex) %>% 
    summarise(mean_income=mean(income,rm.na=T))
ageg_sex_income
ggplot(data=ageg_sex_income, aes(x=ageg, y=mean_income, fill=sex)) + 
    geom_col(position='dodge') +
    scale_x_discrete(limits = c("young", "middle", "old"))

# 성별 연령별 월급 평균표 만들기
age_sex_income <- welfare %>%
    filter(!is.na(income)) %>%
    group_by(age, sex) %>% 
    summarise(mean_income=mean(income,rm.na=T))
age_sex_income
ggplot(data=age_sex_income, aes(x=age, y=mean_income, col=sex)) + geom_line()

# 직업별 월급차이
list_job <- read_excel('./R/data/Koweps_Codebook.xlsx', col_names = T, sheet = 2)
list_job

# 코드번호 합치기
welfare <- left_join(welfare, list_job, by="code_job")

welfare %>%
    filter(!is.na(code_job)) %>%
    select(code_job, job) %>%
    head(10)

job_income <- welfare %>%
    filter(!is.na(income) & !is.na(job)) %>%
    group_by(job) %>% 
    summarise(mean_income=mean(income,rm.na=T))

head(job_income)

top10_job_income <- job_income %>% 
    arrange(desc(mean_income)) %>% 
    head(10)
top10_job_income

ggplot(data=top10_job_income, aes(x=reorder(job, mean_income), y=mean_income)) + 
    geom_col() + coord_flip()

bottom10_job_income <- job_income %>% 
    arrange(mean_income) %>% 
    head(10)
bottom10_job_income

ggplot(data=bottom10_job_income, aes(x=reorder(job, -mean_income), y=mean_income)) + 
    geom_col() + coord_flip() + ylim(0,850)


# 성별 직업빈도 상위 10개
# male
top10_male_job <- welfare %>% 
    filter(!is.na(job) & sex=='male') %>% 
    group_by(job) %>% 
    summarise(count=n()) %>% 
    arrange(desc(count)) %>% 
    head(10)
top10_male_job
ggplot(data=top10_male_job, aes(x=reorder(job, count), y=count)) + geom_col() +
    coord_flip()

# female
top10_female_job <- welfare %>% 
    filter(!is.na(job) & sex=='female') %>% 
    group_by(job) %>% 
    summarise(count=n()) %>% 
    arrange(desc(count)) %>% 
    head(10)
top10_female_job
ggplot(data=top10_female_job, aes(x=reorder(job, count), y=count)) + geom_col() +
    coord_flip()



# .. 종교에 따른 이혼율
class(welfare$religion)
table(welfare$religion)

# 종교 유무 이름 부여
welfare$religion <- ifelse(welfare$religion == 1, "yes", "no")
table(welfare$religion)

qplot(welfare$religion)

# 혼인상태, 이혼변수 만들기
class(welfare$marriage)
table(welfare$marriage)

welfare$group_marriage <- ifelse(welfare$marriage == 1, "marriage",
                                 ifelse(welfare$marriage == 3, "divorce", NA))

table(welfare$group_marriage)
table(is.na(welfare$group_marriage))
qplot(welfare$group_marriage)

#### 여기서 부터

#  종교 유무에 따른 이혼율 표 만들기
religion_marriage <- welfare %>%
    filter(!is.na(group_marriage)) %>%
    count(religion, group_marriage) %>%
    group_by(religion, group_marriage) %>%
    mutate(pct = round(n/sum(n)*100, 1))

# 이혼 추출
divorce <- religion_marriage %>%
    filter(group_marriage == "divorce") %>%
    select(religion, pct)
divorce
ggplot(data = divorce, aes(x = religion, y = pct)) + geom_col()


# 지역별 연령대 비율
table(welfare$code_region)

# 지역 코드 목록 만들기
list_region <- data.frame(code_region = c(1:7),
                          region = c("서울",
                                     "수도권(인천/경기)",
                                     "부산/경남/울산",
                                     "대구/경북",
                                     "대전/충남",
                                     "강원/충북",
                                     "광주/전남/전북/제주도"))

# 지역 코드 목록 삽입
welfare <- left_join(welfare, list_region, by = "code_region")

# 삽입 확인
welfare %>%
    select(code_region, region) %>%
    head

# 1. 지역별 연령대 비율표 만들기
#region_ageg <- welfare %>%
#    group_by(region, ageg) %>%
#    summarise(n = n()) %>%
#    mutate(tot_group = sum(n),
#           pct = round(n/tot_group*100, 2))

region_ageg <- welfare %>%
    count(region, ageg) %>%
    group_by(region) %>%
    mutate(pct = round(n/sum(n)*100, 2))
head(region_ageg)

ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) +
    geom_col() +
    coord_flip()

# 노년층 비율 내림차순 정렬
list_order_old <- region_ageg %>%
    filter(ageg == "old") %>%
    arrange(pct)
list_order_old

# 지역명 순서 변수 만들기
order <- list_order_old$region
order

ggplot(data = region_ageg, aes(x = region, y = pct, fill = ageg)) +
    geom_col() +
    coord_flip() +
    scale_x_discrete(limits = order)

library(ggplot2)      # ggplot 및 mpg 데이터 
library(dplyr)        # 데이터 가공

# mpg 
mpg <- as.data.frame(ggplot2::mpg)

# x 축 displ, y 축 hwy 로 지정해 배경 생성
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point() +
    xlim(3,6) + 
    ylim(10, 30)

ggplot(data = mpg, aes(x = cty, y = hwy)) +
    geom_point()

# midwest 
options(scipen = 99)
midwest <- as.data.frame(ggplot2::midwest)
head(midwest)
ggplot(data = midwest, aes(x = poptotal, y = popasian)) +
    geom_point() +
    xlim(0,500000) +
    ylim(0,10000)


# .. 막대그래프
# 구동방식별 평균 연비
df_mpg <- mpg %>%
    group_by(drv) %>%
    summarise(mean_hwy = mean(hwy))
df_mpg

# col, 데이터 요약, 평균차트
# 내림차순 정렬 reoder( '-' )
ggplot(data=df_mpg, aes(x=reorder(drv, -mean_hwy), y=mean_hwy)) + geom_col()

# bar, 단순원데이타
ggplot(data=mpg, aes(x=drv)) + geom_bar()
ggplot(data=mpg, aes(x=hwy)) + geom_bar()


# 혼자서 해보기
# q1
# 구동방식별 평균 연비
mpg <- as.data.frame(ggplot2::mpg)
tail(mpg)
df_mpg <- mpg %>%
    filter(class=='suv') %>%
    group_by(manufacturer) %>%
    summarise(mean_cty = mean(cty)) %>%
    arrange(desc(mean_cty)) %>%
    head(5)
df_mpg
ggplot(data=df_mpg, aes(x=reorder(manufacturer,-mean_cty), y=mean_cty)) + geom_col()

# q2
ggplot(data=mpg, aes(x=class)) + geom_bar()

# 선그래프
eco <- as.data.frame(ggplot2::economics)
summary(eco)
eco

ggplot(data = economics, aes(x = date, y = psavert)) + geom_line()

# box plot
ggplot(data = mpg, aes(x = drv, y = hwy)) + geom_boxplot()


# 혼자해보기
cty_mpg <- mpg %>% filter(class %in% c("compact","subcompact","suv")) %>%
    select(cty,class)
ggplot(data = cty_mpg, aes(x = class, y = cty)) + geom_boxplot()

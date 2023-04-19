# .. load
load("R/DAOU/08_chart/08_all.rdata")
load("R/DAOU/08_chart/08_sel.rdata") 
head(all)

library(dplyr)
library(lubridate)

all <- all %>% 
    group_by(month=floor_date(ymd, "month")) %>% 
    summarize(all_py = mean(py))  # 카운팅, 전체지역
sel <- sel %>% 
    group_by(month=floor_date(ymd, "month")) %>% 
    summarize(sel_py = mean(py))  # 카운팅, 관심지역 

head(all)
max(all$all_py)

fit_all <- lm(all$all_py ~ all$month)
fit_sel <- lm(sel$sel_py ~ sel$month)

# 기울기값 소수점1자리로
coef_all <- round(summary(fit_all)$coefficients[2],1)*365  # 기대값?
coef_sel <- round(summary(fit_sel)$coefficients[2],1)*365


# .. 회귀분석 그리기
# 분기별 평당 가격 변화 주석 만들기
library(grid)
grob_1 <- grobTree(textGrob(paste0("전체 지역: ", coef_all, "만원(평당)"),
                            x=0.05, y=0.88, hjust=0, 
                            gp=gpar(col="blue", fontsize=13, fontface="italic")))
grob_2 <- grobTree(textGrob(paste0("관심 지역: ", coef_sel, "만원(평당)"),
                            x=0.05, y=0.95, hjust=0, 
                            gp=gpar(col="red", fontsize=13, fontface="italic")))

# 관심지역 회귀선 그리기
#install.packages("ggpmisc")
library(ggpmisc)
gg <- ggplot(sel, aes(x=month, y=sel_py)) +
    geom_line() + xlab("월") + ylab("가격") + 
    theme(axis.text.x = element_text(angle = 90)) +
    stat_smooth(method = 'lm', colour="dark grey", linetype = "dashed") +
    theme_bw()

# 전체지역 회귀선 그리기
gg + geom_line(color="red", size=1.5) + 
    geom_line(data = all, aes(x=month, y=all_py), color="blue", size=1.5) +
    annotation_custom(grob_1) + 
    annotation_custom(grob_2)

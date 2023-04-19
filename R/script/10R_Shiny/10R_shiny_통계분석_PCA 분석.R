# load
#load("R/DAOU/08_chart/08_sel.rdata")
load("R/DAOU/08_chart/sel.rdata")
class(sel$con_year)
#sel$con_year <- as.numeric(sel$con_year)
#class(sel$con_year)

# 분석열 처리
pca_01 <- aggregate(list(sel$con_year, sel$floor, sel$py, sel$area ),
                    by=list(sel$apt_nm), mean) # 아팥트별 평균값 구하기
colnames(pca_01) <- c("apt_nm", "신축", "층수", "가격", "면적")

summary(pca_01)

# 주성분 분석
m <- prcomp(~ 신축 + 층수 + 가격 + 면적, data=pca_01, scale=T)
summary(m)

install.packages("ggfortify")
library(ggfortify)

autoplot(m, loadings.label=T, loadings.label.size=6) + 
    geom_label(aes(label=pca_01$apt_nm), size=4)

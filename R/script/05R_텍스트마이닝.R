# 교제 200? 페이지
install.packages("multilinguer") # KONLP 사전설치
library(multilinguer)
install_jdk()   # R에서 java 개발도구 설치
# 한글분석용 여러 패키지들
install.packages(c("stringr","hash","tau","Sejong","RSQLite", "devtools"),type="binary")
install.packages("remotes")  # R과 github 연결
remotes::install_github("haven-jeon/KoNLP", upgrade='never', INSTALL_opts=c("--no-multiarch"))

library(KoNLP)
useNIADic()    # 형태소? 분석을 위한 사전설치 'ALL' 선택


# data load: hippop
txt <- readLines("R/data/hiphop.txt")
library(stringr)

# 특수문제 제거
txt <- str_replace_all(txt, "\\W", " ")

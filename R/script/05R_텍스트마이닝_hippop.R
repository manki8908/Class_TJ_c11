# 교제 200? 페이지
library(dplyr) # 전처리
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

# 특수문자 공백으로 제거
txt <- str_replace_all(txt, "\\W", " ")

# 명사 추출 테스트 ( "Sejong" 패키지 모듈)
extractNoun("대한민국의 영토는 한반도와 그 부속 도서로 한다")

# txt 에서 명사추출
nouns <- extractNoun(txt)

# 추출한 명사 list 를 문자열 벡터로 변환, 단어별 빈도표 생성
wordcount <- table(unlist(nouns))
wordcount

# 데이터 프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word   # 한글이 안나옴, 텍스트 유형 맞춰야 할듯, 옵션에서 'utf-8'로 변경

# 컬럼 변수명 수정
df_word <- rename(df_word, word = Var1, freq = Freq)

# top_20 확인, 두글자 이상만
df_word <- filter(df_word, nchar(word) >=2)
top_20 <- df_word %>%
    arrange(desc(freq)) %>%
    head(20)
top_20


# .. 워드 클라우드 만들기
# 패키지 설치
install.packages("wordcloud")

# 패키지 로드
library(wordcloud)
library(RColorBrewer)  # 색깔 

# 단어 생상 목록 만들기
pal <- brewer.pal(8,"Dark2") # Dark2 색상 목록에서 8 개 색상 추출
#pal <- brewer.pal(9,"Blues")[5:9] # 색상 목록 생성

# 워드 클라우드 생성
set.seed(2023) # 난수 고정
wordcloud(words = df_word$word, # 단어
          freq = df_word$freq, # 빈도
          min.freq = 2, # 최소 단어 빈도
          max.words = 200, # 표현 단어 수
          random.order = F, # 고빈도 단어 중앙 배치
          rot.per = .1, # 회전 단어 비율
          scale = c(4, 0.3), # 단어 크기 범위
          colors = pal) # 색깔 목록

pal <- brewer.pal(9,"Blues")[5:9] # 색상 목록 생성

# 워드 클라우드 생성
set.seed(2023) # 난수 고정
wordcloud(words = df_word$word, # 단어
          freq = df_word$freq, # 빈도
          min.freq = 2, # 최소 단어 빈도
          max.words = 200, # 표현 단어 수
          random.order = F, # 고빈도 단어 중앙 배치
          rot.per = .2, # 회전 단어 비율
          scale = c(4, 0.3), # 단어 크기 범위
          colors = pal) # 색깔 목록

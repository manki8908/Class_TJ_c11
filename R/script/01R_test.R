a <- 1
b <- 2.
c <- 3
d <- 3.5
a+b+c
4./b
5*b

var1 <- c(1,2,5,7,8)
var1
var2 <- c(1:5)
var2
var3 <- seq(1,5)
var3
var4 <- seq(1,10,by=2)
var4
var5 <- seq(1,10,3)
var5
var1 + 1
var1 + var2

str1 <- "a"
str2 <- "Hello world"
str3 <- c('a','b','c')
str4 <- c("hello","world")

# 함수적용
x <- c(1,2,3)
mean(x)
max(x)
min(x)

#
paste(str4,collapse = ',')
paste(str4,collapse = ' ')


# import
install.packages("ggplot2")

library(ggplot2)

x <- c("a", "a", "b", "c")

# 빈도그래프
qplot(x)

# 데이터에 mpg, x축 hwy 변수
qplot(data=mpg, x=hwy)

qplot(data=mpg, x=cty)

# x축 drv, y=hwy
qplot(data=mpg, x=drv, y=hwy)


qplot(data=mpg, x=drv, y=hwy, geom='line')
qplot(data=mpg, x=drv, y=hwy, geom='boxplot', colour=drv)
?qplot

Load("./06_geodataframe/06_apt_price_1.rdata")
library(sf)
#
apt_price <- st_drop_geometry (apt_price) #공간 정보 제거
apt_price$py_area <- round (apt_price$area / 3.3, 0) #크기 변환 (m2→평)
head (apt_price$py_area)


#  --------------------------------

library(shiny) #install.packages("shiny") library(ggpmisc) # install.packages("ggpmisc")
ui <- fluidPage(
    #---# 타이틀 입력
    titlePanel("여러 지역 상관관계 비교"),
    fluidRow(
        ##선택 메뉴 1: 지역 선택
        column (6,
                selectInput(
                    inputId = "region",
                    label = "지역을 선택하세요", #라벨
                    unique(apt_price$addr_1),
                    multiple = TRUE)),
        ## 선택 메뉴 2: 크기 선택
        column (6,
                sliderInput(
                    inputId = "range_py",
                    label = "평수를 선택하세요",
                    #입력 아이디
                    #선택 범위
                    #복수 선택 옵션
                    #입력 아이디
                    #라벨
                    min=0,
                    #선택 범위 최솟값
                    max = max(apt_price$py_area),
                    #선택 범위 최댓값
                    value = c(0, 30))),
        #기본 선택 범위
        ##출력
        column(12,
               plotOutput (outputId = "gu_Plot", height="600"))) #차트 출력
)





#  -----------------------------
#  ----------------------


server <- function (input, output, session){
    apt_sel=reactive({
        apt_sel = subset (apt_price,
                          addr_1== unlist (strsplit (paste(input$region, collapse =','),",")) &
                              py_area >= input$range_py[1] &
                              py_area <= input$range_py[2])
        return(apt_sel)
    })
    ##지역별 회귀선 그리기
    output$gu_Plot <- renderPlot({
        if (nrow(apt_sel()) == 0) #
            return(NULL)
        ggplot(apt_sel(), aes(x = py_area, y = py, col="red")) + # 48
            geom_point() +
            geom_smooth (method="lm", col="blue") +
            facet_wrap(~addr_1, scale='free_y', ncol=3) +
            theme(legend.position="none") +
            xlab('크기(평)') +
            ylab('평당 가격(만원)') +
            stat_poly_eq(aes (label=paste(..eq.label..)),
                         label.x= "right", label.y = "top",
                         formula=y~x, parse = TRUE, size = 5, col="black")
    })
}

shinyApp(ui=ui, server=server)

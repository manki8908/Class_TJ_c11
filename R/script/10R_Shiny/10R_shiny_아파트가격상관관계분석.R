load("./06_geodataframe/06_apt_price_1.rdata")
library(sf)

apt_price <- st_drop_geometry(apt_price)          # 공간 정보 제거
apt_price$py_area <- round(apt_price$area/3.3,0)  # 크기변환 (m2->평)
head(apt_price$py_area)

require(showtext)
font_add_google(name="Nanum Gothic", regular.wt=400, bold.wt = 700)
showtext_auto()
showtext_opts()


library(shiny)

ui <- fluidPage(
    #ᅳᅳᅳ#제목 설정
    titlePanel("아파트 가격 상관관계 분석"),
    #---#사이드 패널 
    sidebarPanel(
        #ᅳᅳᅳ#선택 메뉴 1: 지역
        selectInput(
            inputId="sel_gu",
            #입력 아이디
            label = "지역을 선택하세요",
            #라벨
            choices = unique (apt_price$addr_1),
            selected = unique (apt_price$addr_1) [1]), #7
        sliderInput(
            inputId="range_py", #입력 아이디
            label = "평수" ,#라벨
            min=0,  #선택 범위 최솟값
            max= max(apt_price$py_area), #선택 범위 최댓값
            value = c(0, 30)),    #기본 선택 범위
        #---#선택 메뉴 3: X축 변수
        selectInput( 
            inputId = "var_x", #입력 아이디
            label = "X축 변수를 선택하시오", #라벨
            choices = list(
                "매매가(평당)"="py",
                "크기(평)"="py_area",
                "건축 연도"="con_year",
                "층수"="floor"),
            selected="py_area"),
        #---#선택 메뉴 4: Y축 변수
        selectInput(
            inputId = "var_y",
            label = "Y축 변수를 선택하시오",
            choices = list(
                "매매가(평당)"="py",
                "크기(평)"="py_area",
                "건축 연도"="con_year",
                "층수"="floor"),
            selected = "py"), #기본 선택
        checkboxInput(
            inputId = "corr_checked",
            label = strong("상관 계수"),
            value = TRUE),
        ##체크박스 2: 회귀 계수
        checkboxInput(
            inputId = "reg_checked",
            label = strong ("회귀 계수"), #라벨
            value = TRUE)
    ),
    mainPanel(
        #---#
        h4("플로팅"),
        plotOutput("scatterPlot"), #플룻 출력
        #---#
        h4("상관 계수"), #라벨
        verbatimTextOutput("corr_coef"), #텍스트 출력
        #---#
        h4("회귀 계수"), #라벨
        verbatimTextOutput("reg_fit") #텍스트 출력
    )
)

server <- function (input, output, session) {
    #---# 반응식
    apt_sel = reactive({
        apt_sel = subset(apt_price,
                         addr_1 == input$sel_gu &
                             #지역 선택
                             py_area >= input$range_py[1] & #최소 크기(평) 선택
                             py_area <= input$range_py[2])  #최대 크기(평) 선택
        return(apt_sel)
    })
    #---# 플롯
    output$scatterPlot <- renderPlot({
        var_name_x <- as.character (input$var_x) #X축 이름
        var_name_y <- as.character (input$var_y) #Y축 이름
        #---#회귀선 그리기
        plot(
            apt_sel()[, input$var_x], #X
            apt_sel()[, input$var_y], #Y축 설정
            xlab= var_name_x, #X축 라벨
            ylab= var_name_y, #Y축 라벨
            main= "플로팅") #플롯 제목
        fit<-lm(apt_sel()[, input$var_y] ~apt_sel()[, input$var_x])
        abline (fit, col="red") #회귀선 그리기
    })
    
    #---#상관 계수
    output$corr_coef <- renderText({
        if(input$corr_checked){
            #체크박스 1 확인
            cor (apt_sel()[, input$var_x], #상관 분석 X축 설정
                 apt_sel()[, input$var_y]) #
        }
    })
    #---# 회귀 계수
    output$reg_fit <- renderPrint({
        if(input$reg_checked) {
            fit<-lm(apt_sel()[, input$var_y]~ apt_sel()[, input$var_x])
            names (fit$coefficients) <- c("Intercept", input$var_x) # 
            summary(fit)
        }
    })
}

# 서버 끝
shinyApp(ui=ui, server=server)

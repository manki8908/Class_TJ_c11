#install.packages("shiny")
library(shiny)

# 127.0.0.1 IP=집, 3546 port=문
ui <- fluidPage("사용자 인터페이스")
server <- function(input,output,session) {}
shinyApp(ui,server)


# .. 샤이니 샘플
runExample("01_hello")
runExample("02_text")
runExample("03_reactivity")


# .. faithful test
faithful <- faithful
head(faithful)

# --------- ui
ui <- fluidPage(
    titlePanel("샤이니 1번 샘플"),
    sidebarLayout(
        sidebarPanel( sliderInput(
                inputId = "bins",
                label = "막대(bin) 개수:",
                min = 1, max = 50,
                value = 30)),
        mainPanel(plotOutput(outputId = "distPlot"))
    ))

# --------- sever
server <- function(input, output, session) {
    output$distPlot <- renderPlot({
        x <- faithful$waiting
        bins <- seq(min(x),max(x),length.out = input$bins + 1)
        hist(x, breaks = bins, col = "#75AADB", border="white",
             xlab = "다음 분출때까지 대기시간(분)",
             main = "대기 시간 히스토그램")
    })
}
shinyApp(ui,server)


# .. 입출력 test
# --------- ui
ui <- fluidPage(
    sliderInput("range", "연비", min=0, max=35, value=c(0,10)),
    textOutput("value")
)
# --------- server
server <- function(input, output, sesstion){
    output$value <- renderText(input$range[1]+input$range[2])
}

# --------- 구동
shinyApp(ui, server)



# .. 반응형 웹 애플개발
install.packages("DT")
library(DT)             # irirs data 등 내장
library(ggplot2)

mpg <- mpg
head(mpg,2)

# ui
ui <- fluidPage(
    sliderInput("range", "연비", min=0, max=35, value=c(0,10)),
    DT::dataTableOutput("table")
)

# sever
server <- function(input, output, session){
    cty_sel = reactive({
        cty_sel = subset(mpg, cty >= input$range[1] & cty <= input$range[2])
        return(cty_sel)
    })
    output$table <- DT::renderDataTable(cty_sel())
}

# app
shinyApp(ui,server)



# .. 레이아웃 정의하기
# ui
ui <- fluidPage(
    fluidRow(
        # 첫번째 열: 빨강(red) 박스로 높이 450, 폭9
        # div 나눠주는 역할 , style css 명령어
        column(9,div(style = "height:450px;border: 4px solid red;", "폭 9")),
        # 두번째 열: 보라, 박스로 높이 450, 폭3
        column(3,div(style = "height:450px;border: 4px solid yellow;", "폭 3")),
        # 세번째 열: 파랑, 박스로 높이 400, 폭12
        column(12,div(style = "height:400px;border: 4px solid blue;", "폭 12")),
    )
)

# server
server <- function(input, output, session){}

# app
shinyApp(ui,server)


# .. 탭 페이지 추가하기
# ui
ui <- fluidPage(
    fluidRow(
        column(9,div(style = "height:450px;border: 4px solid red;", "폭 9")),
        column(3,div(style = "height:450px;border: 4px solid yellow;", "폭 3")),
        tabsetPanel(
            tabPanel("탭1",
                column(4,div(style = "height:300px;border: 4px solid red;", "폭 4")),
                column(4,div(style = "height:300px;border: 4px solid red;", "폭 4")),
                column(4,div(style = "height:300px;border: 4px solid red;", "폭 4")),
            ),
            tabPanel("탭2", div(style = "height:300px;border: 4px solid blue;", "폭 12"))
        )
    )
)
# server
server <- function(input, output, session){}

# app
shinyApp(ui,server)



# 그리드 필터링, SP->SF
grid <- st_read("R/data/seoul/seoul.shp")          # 서울 1km 격자
grid <- as(grid, "Spatial")
grid <- as(grid, "sfc")
# 필터링: 책에 뭘 필터링하는지, length가 포함된 그리드만 필터
grid <- grid[which(sapply(st_contains(st_sf(grid), apt_price), length) >0)]
plot(grid)

m <- leaflet() %>% 
    # 기본맵 설정
    addTiles(options = providerTileOptions(minZoom=9, maxZoom=18)) %>% 
    # 최고가 지역 KDE
    addRasterImage(raster_high,
                   colors = colorNumeric(c("blue","green","yellow","red"),
                                         values(raster_high),
                                         na.color="transparent"),
                   opacity = 0.4,
                   group = "2021 최고가") %>% 
    # 급등지역 KDE
    addRasterImage(raster_hot,
                   colors = colorNumeric(c("blue","green","yellow","red"),
                                         values(raster_hot),
                                         na.color="transparent"),
                   opacity = 0.4,
                   group = "2021 급등지") %>% 
    # 레이어 스위치 메뉴
    addLayersControl(baseGroups = c("2021 최고가", "2021 급등지"),
                     options = layersControlOptions(collapsed=F)) %>% 
    # 서울시 외곽 경계선
    addPolygons(data = bnd, weight = 3, stroke = T, color = "red",
                fillOpacity = 0) %>% 
    # 마커 클러스터링
    addCircleMarkers(data = apt_price, lng = unlist(map(apt_price$geometry,1)),
                     lat = unlist(map(apt_price$geometry,2)),radius = 10, 
                     stroke = F, fillOpacity = 0.6, fillColor = circle.colors,
                     weight = apt_price$py,
                     clusterOptions = markerClusterOptions(iconCreateFuntion=JS(avg.formula))) %>%
    leafem::addFeatures(st_sf(grid), layerId=~seq_len(length(grid)),color="grey")
m

# 샤이니에서 구현하기
library(shiny)
#install.packages("mapedit")
library(mapedit)
library(dplyr)


ui <- fluidPage(
  selectModUI("selectmap"), 
  textOutput("sel")
)

server <- function(input, output, session) {
  df <- callModule(selectMod, "selectmap", m)
  output$sel <- renderPrint({df()[1]})
}

shinyApp(ui, server)



# 반응형 지도 앱 완성하기
# 10-3 반응형 지도 애플리케이션 완성하기
# 1단계 사용자 인터페이스 설정하기
library(DT) # install.packages("DT")
ui <- fluidPage(
    #---# 상단 화면: 지도 + 입력 슬라이더
    fluidRow(  
        column( 9, selectModUI("selectmap"), div(style = "height:45px")),
        column( 3,
                sliderInput("range_area", "전용면적", sep = "", min = 0, max = 350, 
                            value = c(0, 200)),
                sliderInput("range_time", "건축 연도", sep = "", min = 1960,  max = 2020, 
                            value = c(1980, 2020)), ),
        #---# 하단 화면: 테이블 출력
        column(12, dataTableOutput(outputId = "table"), div(style = "height:200px")))) 

# 2단계 반응식 설정(슬라이더 입력 필터링)

server <- function(input, output, session) {
    #---# 반응식
    apt_sel = reactive({
        apt_sel = subset(apt_price, con_year >= input$range_time[1] & 
                             con_year <= input$range_time[2] & area >= input$range_area[1] & 
                             area <= input$range_area[2])
        return(apt_sel)})
    
    # 3단계 지도 입출력 모듈 설정(그리드 선택 저장)
    
    g_sel <- callModule(selectMod, "selectmap",
                        leaflet() %>% 
                            #---# 기본 맵 설정: 오픈스트리트맵
                            addTiles(options = providerTileOptions(minZoom = 9, maxZoom = 18)) %>% 
                            #---# 최고가 지역 KDE 
                            addRasterImage(raster_high, 
                                           colors = colorNumeric(c("blue", "green","yellow","red"), 
                                                                 values(raster_high), na.color = "transparent"), opacity = 0.4, 
                                           group = "2021 최고가") %>%
                            #---# 급등 지역 KDE 
                            addRasterImage(raster_hot, 
                                           colors = colorNumeric(c("blue", "green","yellow","red"), 
                                                                 values(raster_hot), na.color = "transparent"), opacity = 0.4, 
                                           group = "2021 급등지") %>%
                            #---# 레이어 스위치 메뉴
                            addLayersControl(baseGroups = c("2021 최고가", "2021 급등지"), 
                                             options = layersControlOptions(collapsed = FALSE)) %>%   
                            #---# 서울시 외곽 경계선
                            addPolygons(data=bnd, weight = 3, stroke = T, color = "red", 
                                        fillOpacity = 0) %>%
                            #---# 마커 클러스터링
                            addCircleMarkers(data = apt_price, lng =unlist(map(apt_price$geometry,1)), 
                                             lat = unlist(map(apt_price$geometry,2)), radius = 10, stroke = FALSE, 
                                             fillOpacity = 0.6, fillColor = circle.colors, weight=apt_price$py, 
                                             clusterOptions=markerClusterOptions(iconCreateFunction=JS(avg.formula))) %>%
                            #---# 그리드
                            leafem::addFeatures(st_sf(grid),layerId= ~seq_len(length(grid)),
                                                color='grey'))
    
    # 4단계 선택에 따른 반응 결과 저장
    
    #---# 반응 초깃값 설정(NULL)
    rv <- reactiveValues(intersect=NULL, selectgrid=NULL) 
    #---# 반응 결과(rv: reactive value) 저장
    observe({
        gs <- g_sel() 
        rv$selectgrid <- st_sf(grid[as.numeric(gs[which(gs$selected==TRUE),"id"])])
        if(length(rv$selectgrid) > 0){
            rv$intersect <- st_intersects(rv$selectgrid, apt_sel())
            rv$sel       <- st_drop_geometry(apt_price[apt_price[unlist(rv$intersect[1:10]),],])
        } else {
            rv$intersect <- NULL
        }
    })
    
    # 5단계 반응 결과 렌더링
    
    output$table <- DT::renderDataTable({
        dplyr::select(rv$sel, ymd, addr_1, apt_nm, price, area, floor, py) %>%
            arrange(desc(py))}, extensions = 'Buttons', options = list(dom = 'Bfrtip',
                                                                       scrollY = 300, scrollCollapse = T, paging = TRUE, buttons = c('excel')))
}

shinyApp(ui, server)

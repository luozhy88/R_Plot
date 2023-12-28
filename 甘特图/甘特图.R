library(vistime)
library(highcharter)
library(ggplot2)


Data <- read.csv(text="event,start,end, color
                       阶段1,2024-01-02,2024-01-19,green
                       阶段2,2024-01-19,2024-02-19,red
                       阶段3,2024-02-19,2024-03-19,blue"
)

hc_vistime(Data)




# 将字符型日期转换为日期型
Data$start <- as.Date(Data$start)

# 使用vistime绘图，并通过tooltip显示开始日期
hc_vistime(Data, optimize_y = F,
           tooltip = list(
             pointFormat = "<b>{point.start:%Y-%m-%d}</b> to {point.end:%Y-%m-%d}<br>{point.event}"
           )) %>% 
  hc_size(width = 600, height = 300) # 设置图片的尺寸

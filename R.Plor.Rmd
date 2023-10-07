
# add lables in PDF
library(magick)
library(ggplot2)            # 加载ggplot2包


p <- ggplot(mtcars, aes(x = mpg, y = disp)) +
  geom_point() +
  labs(title = "Scatter Plot of MPG vs. Displacement")


pdf("scatter_plot.pdf", width = 8, height = 6)  # 设置PDF文件的宽度和高度
print(p)  # 打印图层到PDF文件
dev.off()  # 关闭PDF绘制设备


file.name="scatter_plot.pdf" #"https://jeroen.github.io/images/frink.png"
IMAGE=image_read_pdf(file.name) %>% #image_read
image_annotate( "A", size = 30, gravity = "northwest", color = "black")

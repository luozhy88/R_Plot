library(circlize)
library(RColorBrewer)

# 生成示例数据
expr_data <- matrix(rnorm(500), nrow=20, ncol=25)
rownames(expr_data) <- paste0("Sample", 1:20)
colnames(expr_data) <- paste0("Gene", 1:25)


# 计算相关系数矩阵
cor_mat <- cor(t(expr_data))

# 为样本分配颜色
sample_colors <- rand_color(nrow(cor_mat))
names(sample_colors) <- rownames(cor_mat)

# 设置输出文件
out.dir <- getwd() # 当前工作目录
sub_group <- "example" # 子组名称

# 定义颜色映射函数
col_fun <- colorRamp2(c(-1, 0, 1), c("green", "white", "red"))
lgd = Legend(col_fun = col_fun, title = "Cor")

# 绘制弦图并保存为PDF文件
pdf(file.path(out.dir, paste0(sub_group, "_rCCA_ccc.pdf")), width = 12, height = 10)
chordDiagram(cor_mat, grid.col = sample_colors, transparency = 0.25,
             col = col_fun,
             symmetric = TRUE)
draw(lgd, x = unit(1, "cm"), y = unit(1, "cm"), just = c("left", "bottom"))
dev.off()


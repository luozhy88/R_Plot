
library(vegan)
library(ggplot2)
data(varespec, varechem)
ord <- cca(varespec , varechem)
# plot(ord)
# # DF 中含有两列，分别是CCA1和CCA2,行名是特征名
# DF=ord$CCA$biplot[,c(1:2)]
# # 基于此表帮我画个牵头图，横轴为CCA1，纵轴为CCA2,并且标注行名
# plot(DF, type="n")

# 假设ord$CCA$biplot已经存在，并且已经提取了前两列作为CCA1和CCA2
Df_omic1 <- ord$CCA$biplot[, 1:2] |> data.frame()
Df_omic1$Type <- "Metab"
Df_omic2 <- ord$CCA$v[, 1:2] |> data.frame()
Df_omic2$Type <- "RNA"
# 合并两个数据框
Df.all <- rbind(Df_omic1, Df_omic2)

# 将行名转换为数据框的一列，用于标注
Df.all$features <- rownames(Df.all)

# 绘制箭头图,箭头颜色按照数据框中的Type列进行区分，让label稍微偏移一点，避免重叠
library(ggplot2)

ggplot(Df.all, aes(x = 0, y = 0, xend = CCA1, yend = CCA2, color = Type, label = features)) +
  geom_segment(aes(xend = CCA1, yend = CCA2), arrow = arrow(length = unit(0.2, "inches"))) +
  geom_text(aes(x = CCA1, y = CCA2), hjust = 0, vjust = 0, nudge_x = 0.05, nudge_y = 0.05, check_overlap = TRUE, show.legend = FALSE) +
  theme_minimal() +
  labs(x = "CCA1", y = "CCA2", title = "Arrow Plot of CCA1 vs CCA2") +
  coord_fixed() +
  scale_color_manual(values = c("red", "blue", "green")) +  # 根据你的Type列的实际值调整颜色
  guides(color = guide_legend(override.aes = list(shape = 16)))  # 确保图



# HEATMAP
## Df.all对CCA1开平方与CCA2开平方,然后求和，作为距离
Df.all$dist <- sqrt(Df.all$CCA1^2 + Df.all$CCA2^2)
Df.all=Df.all[order(Df.all$dist,decreasing = T),]





#
# plot(ord, display=c("sp","bp"), arrowan=0.8)
# plot(ord, display=c("bp","cn"), arrowan=0.8)
# plot(ord, display = "all", type = "n")
# # plot(ord, choices = c(1, 2), display = c("all"))
# 
# ## biplot scores
# bip <- scores(ord, choices = 1:2, display = "bp")
# 
# ## scaling factor for arrows to fill 80% of plot
# (mul <- ordiArrowMul(bip, fill = 0.8))
# bip.scl <- bip * mul                    # Scale the biplot scores
# labs <- rownames(bip)                   # Arrow labels
# 
# ## calculate coordinate of labels for arrows
# (bip.lab <- ordiArrowTextXY(bip.scl, rescale = FALSE, labels = labs))
# 
# ## draw arrows and text labels
# arrows(0, 0, bip.scl[,1], bip.scl[,2], length = 0.1)
# text(bip.lab, labels = labs)
# 
# ## Handling of ordination objects directly
# mul2 <- ordiArrowMul(ord, display = "bp", fill = 0.8)
# stopifnot(all.equal(mul, mul2))

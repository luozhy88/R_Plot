library(networkD3)

# 数据准备
MisLinks <- data.frame(source = c("a", "b", "c", "d"),
                       target = c("b", "c", "d", "a"),
                       value = c(1, 2, 3, 4))

MisNodes <- data.frame(name = c("a", "b", "c", "d"),
                       group = c(1, 2, 3, 4),
                       size = c(10, 20, 30, 40),
                       color = c("#ff0000", "#00ff00", "#0000ff", "#ff00ff"))
rownames(MisNodes) <- MisNodes$name

# 转换 source 和 target 列
MisLinks$source <- match(MisLinks$source, rownames(MisNodes)) - 1
MisLinks$target <- match(MisLinks$target, rownames(MisNodes)) - 1

# 创建网络图
net <- forceNetwork(Links = MisLinks, Nodes = MisNodes, Source = "source", Group = "group",
                    Target = "target", Value = "value", NodeID = "name",
                    Nodesize = "size")
print(net)

#####################################################################################


# install.packages(c("igraph", "htmlwidgets", "networkD3"))
library(htmlwidgets)
library(networkD3)
library(magrittr)
# Load data
data(MisLinks)
data(MisNodes)

# 假设您已经有了 MisLinks 和 MisNodes 数据框
# 并且 MisNodes 数据框中的 name 列包含了每个节点的名称

# 将点的颜色映射转换为 JavaScript 代码
node.name=MisNodes$name
node.color=MisNodes$color

colourScale_JS <- sprintf(
  "d3.scaleOrdinal().domain(%s).range(%s)",
  jsonlite::toJSON(node.name, auto_unbox = TRUE),
  jsonlite::toJSON(node.color  , auto_unbox = TRUE)
)

ValjeanCols=rep("#bf3eff",254)#linkColour 改变边的颜色

# 创建网络图
forceNetwork(Links = MisLinks, Nodes = MisNodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             Nodesize = "size", fontSize = 10, radiusCalculation = "Math.sqrt(d.nodesize)+6",
             opacityNoHover = TRUE, 
             linkColour = ValjeanCols,
             colourScale = JS(colourScale_JS),
             Group = "group", opacity = 0.9, legend = F, bounded = TRUE)%>% saveNetwork(file = 'Net1.html')

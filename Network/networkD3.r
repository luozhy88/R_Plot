
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

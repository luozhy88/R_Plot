#####################################################################################Plot1
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

#####################################################################################Plot2
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
#####################################################################################Plot3


library(htmlwidgets)
library(networkD3)
library(magrittr)

nk.edge=igraph::get.data.frame(new_g,what = "edges")
# nk.edge=nk.edge[1:50,]
nk.node=igraph::get.data.frame(new_g,what = "vertices")
# nk.node=nk.node[1:50,]
colnames(nk.edge)[1:2]=c("source","target")
rownames(nk.node)=NULL
# 转换 source 和 target 列
nk.edge$source <- match(nk.edge$source, nk.node$name  ) - 1
nk.edge$target <- match(nk.edge$target, nk.node$name  ) - 1


# 将点的颜色映射转换为 JavaScript 代码
node.name=nk.node$name
nk.node$color=ifelse(nk.node$type=="Transcriptome", "green", "red")
node.color=nk.node$color
names(node.color)=node.name

group2project = paste(unique(nk.node$type),collapse = '","')
color2project = paste(unique(nk.node$color),collapse = '","')
my_color <- paste0('d3.scaleOrdinal().domain(["',group2project,'"]).range(["',color2project,'"])')

# ValjeanCols=rep("#bf3eff",1886)#linkColour 改变边的颜色


# 创建网络图
nk.node$name=make.names(nk.node$name)
forceNetwork(Links = nk.edge, Nodes = nk.node, Source = "source", Target = "target", 
             Group = "type",
             Value = "weight", NodeID = "name",  Nodesize = "size", 
             fontSize = 10, #radiusCalculation = "Math.sqrt(d.nodesize)+6",
             opacityNoHover = TRUE, 
             #linkColour = ValjeanCols,
             colourScale = JS(my_color),
             fontFamily="Times",charge = -250,
             opacity = 0.4, legend = T, bounded = TRUE) #%>% saveNetwork(file = 'Net1.html')



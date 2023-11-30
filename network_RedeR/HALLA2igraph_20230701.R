## this script only works for two omics association output from HALLA
## if you have more than 2 omics, you may just need to adjust accordingly.
## you could also calculate association by pooling all features from more than 2 omics
## just arrange the output format as "all_associations" from HALLA where only the first three columns needed.
## import "all_associations" from HALLA
# all_associations
rm(list=ls())
library(igraph)
library(ggraph)
library(graphlayouts)


all_associations <- read.csv("../04_cor_barplot/input/16s_LC_Cyc.cor.csv")
Class="Microbes" #LC  Cytokines Microbes
all_associations = all_associations %>% dplyr::filter(Annotation==Class )
all_associations = all_associations %>% dplyr::filter(abs(Correlation)>0.5 )
# all_associations <- read.delim("all_associations.txt")
# significant ones
data <- subset(all_associations, P.Value <= 0.05 )
data$X_features=all_associations$pCresol
data$Y_features=all_associations$Feature
data$Feature=all_associations$Feature
data$group= data$Annotation
data$association=data$Correlation
data$p.values=data$P.Value
data$q.values=data$P.Value
Groups=data$Annotation
data=data %>% dplyr::select(X_features,Y_features,association,p.values,q.values)
rownames(data) <- NULL

# links
data.links <- data

# nodes
data.nodes <- data.frame(
  names = c(data$X_features, data$Y_features),
  group = c(rep("pCresol", nrow(data)),Groups)  ) 


# remove duplicated nodes
data.nodes.new <- data.nodes[-which(duplicated(data.nodes)), ]

#

# create graph
network <- graph_from_data_frame(d = data.links, vertices = data.nodes.new, directed = F)

# Make a palette of different colors
library(RColorBrewer)
n <- length(unique(data.nodes.new$group))
# coul <- brewer.pal(n, "Accent")
# coul <- jcolors::jcolors("pal3")
coul <- c("#EB7DF4", "#FA7E81", "#7AE142", "#97C2FC", "#FEFF00")


# Create a vector of color
my_color <- coul[as.numeric(as.factor(V(network)$group))]

# plot without clusters
set.seed(250)
pdf(file = glue::glue(Class,"_noCluster.pdf"), width = 12, height = 12)
plot(network,
  vertex.size = 10,
  vertex.color = my_color,
  edge.width = abs(E(network)$association) * 10,
  edge.curved = 0.3,
  edge.color = ifelse(E(network)$association < 0, "blue", "red")
)
dev.off()
# 
# ### cluster then plot
# # cluster for community detection
# clusterlouvain <- cluster_louvain(network)
# # assign vertex shapes for each group
# V(network)$shape <- ifelse(V(network)$group == "pCresol", "circle", "square")
# ##
# ## plot with community info
# pdf(file = glue::glue(Class,"_Cluster_communityShown.pdf"), width = 15, height = 15)
# plot(clusterlouvain,
#   network,
#   layout = layout_with_fr(network),
#   vertex.size = 10,
#   edge.width = abs(E(network)$association) * 10,
#   edge.curved = 0.3,
#   edge.color = ifelse(E(network)$association < 0, "blue", "red"),
#   vertex.color = rainbow(10, alpha = 0.6)[clusterlouvain$membership]
# )
# dev.off()
# 
# ## plot without community info
# pdf(file = glue::glue(Class,"_Cluster_communityNoShown.pdf"), width = 15, height = 15)
# plot(network,
#   layout = layout_with_fr(network),
#   vertex.size = 10,
#   edge.width = abs(E(network)$association) * 10,
#   edge.curved = 0.3,
#   edge.color = ifelse(E(network)$association < 0, "blue", "red"),
#   vertex.color = rainbow(10, alpha = 0.6)[clusterlouvain$membership]
# )
# dev.off()

## this script only works for two omics association output from HALLA
## if you have more than 2 omics, you may just need to adjust accordingly.
## you could also calculate association by pooling all features from more than 2 omics
## just arrange the output format as "all_associations" from HALLA where only the first three columns needed.
## import "all_associations" from HALLA
# all_associations
# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("RedeR")

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
coul <- c( "#97C2FC","#EB7DF4", "#7AE142", "#FA7E81", "#FEFF00")


# Create a vector of color
my_color <- coul[as.numeric(as.factor(V(network)$group))]


#--- Set a new graph attribute in 'network'
network$bgColor <- 'grey90'
#--- Set new node attributes in 'network'
V(network)$nodeColor <- my_color
V(network)$nodeSize <- 15
#--- Set new edge attributes in 'network'
E(network)$edgeColor <- ifelse(E(network)$association < 0, "blue", "red")
E(network)$edgeWidth <- abs(E(network)$association) * 1

#### RedeR
library(RedeR)
rdp <- RedPort()
calld(rdp)
addGraph(rdp, g=network)

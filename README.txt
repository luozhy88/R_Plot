# excalidraw
https://excalidraw.com/

# R_Plot
## ComplexHeatmap 每个单元格边界都有空白

//Create test matrix
test = matrix(rnorm(200), 20, 10)
test[1:10, seq(1, 10, 2)] = test[1:10, seq(1, 10, 2)] + 3
test[11:20, seq(2, 10, 2)] = test[11:20, seq(2, 10, 2)] + 2
test[15:20, seq(2, 10, 2)] = test[15:20, seq(2, 10, 2)] + 4
colnames(test) = paste("Test", 1:10, sep = "")
rownames(test) = paste("Gene", 1:20, sep = "")


library(ComplexHeatmap)
ComplexHeatmap::Heatmap(test,row_names_side="left",cluster_rows = F,show_row_dend = FALSE, show_heatmap_legend = FALSE,rect_gp = gpar(col="white",lwd=2))

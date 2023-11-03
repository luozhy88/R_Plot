# ggbetweenstats
##three groups
library(ggstatsplot)
i="Sepal.Length"
table_stats=ggbetweenstats(
  data  = iris,
  x     = Species,
  y     = !!i,
  type = "noparametric",
  p.adjust.method="none",
  title = "Distribution of sepal length across Iris species"
)  |> extract_stats()
table_stats1=table_stats$subtitle_data %>% data.frame()
table_stats2=table_stats$pairwise_comparisons_data%>% data.frame()
table_stats1$Feature=i
table_stats2$Feature=i
table_stats_3=base::merge(table_stats1,table_stats2,by="Feature",all.y = T)
table_stats_3

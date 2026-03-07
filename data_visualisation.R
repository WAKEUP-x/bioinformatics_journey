# script to visualize gene expression data (GSE183947)
# NOTE: run data_manipulation.R first to generate data.long

# install libraries
# install.packages("tidyverse")   # uncomment to install
# install.packages("ggplot2")   # uncomment to install

# load libraries 
library(tidyverse)
library(ggplot2)

# data
# data.long to be used from the previous file

# barplot
data.long %>%
  filter(gene == "BRCA1") %>%
  ggplot(., aes(x = samples, y = FPKM, fill = tissue)) +
  geom_col()
  
# density
data.long %>%
  filter(gene == "BRCA1") %>%
  ggplot(., aes(x = FPKM, fill = tissue)) +
  geom_density(alpha = 0.3) 

# boxplot
data.long %>%
  filter(gene == "BRCA1") %>%
  ggplot(., aes(x = metastasis, y = FPKM)) +
  # geom_boxplot()
  geom_violin()

# scatterplot 
data.long %>%
  filter(gene == "BRCA1" | gene == "BRCA2") %>%
  pivot_wider(names_from = gene, values_from = FPKM) %>%
  ggplot(., aes(x = BRCA1, y = BRCA2, color = tissue)) +
  geom_point() +
  geom_smooth(method = 'lm', se = FALSE)
 
# heatmap
genes.of.interest <- c('BRCA1', 'BRCA2', 'TP53', 'ALK', 'MYCN')
# two methods to save plots
#pdf("heatmap.h2.pdf", width = 10, height = 8)   # first method
#g <- data.long %>%   # second method
data.long %>% 
  filter(gene %in% genes.of.interest)  %>%
  ggplot(., aes(x = samples, y = gene, fill = FPKM)) +
  geom_tile() +
  scale_fill_gradient(low = 'white', high = 'red')

#dev.off()   # first method
#ggsave(h, filename = 'heatmap_h.png', width = 10, height = 8)   # second method

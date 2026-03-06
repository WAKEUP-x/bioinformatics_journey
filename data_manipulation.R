# script to manipulate gene expression data

# install libraries 
# install.packages("dplyr")   # uncomment to install
# install.packages("tidyverse")   # uncomment to install

# To install bioconductor packages is not like normal R packages
# BiocManager::install("GEOquery")   # uncomment to install

#load libraries
library("dplyr")
library("tidyverse")
library("GEOquery")

# reading the data
# GSE183947: breast cancer gene expression dataset (human, not plant)
data <- read.csv(file = "data/GSE183947_fpkm.csv")
dim(data)

# get metadata
gse <- getGEO(GEO = 'GSE183947' , GSEMatrix = TRUE)

gse

metadata <- pData(phenoData(gse[[1]]))
head(metadata)

metadata.modified <- metadata %>%
  select(1,10,11,17) %>%
  rename(tissue = characteristics_ch1) %>%
  rename(metastasis = characteristics_ch1.1) %>%
  mutate(tissue = gsub("tissue: ", "", tissue)) %>%
  mutate(metastasis = gsub("metastasis: ", "", metastasis))

head(data)

# reshaping data
data.long <- data %>%
  rename(gene = X) %>%
  pivot_longer(cols = -gene, names_to = "samples", values_to = "FPKM")


# join dataframes = data.long + metadata.modified
data.long <- data.long %>%
  left_join(., metadata.modified, by = c("samples" = "description"))

# explore data
data.long %>%
  filter(gene == 'BRCA1' | gene == 'BRCA2') %>%
  group_by(gene, tissue) %>%
  summarize(mean_FPKM = mean(FPKM),
            median_FPKM = median(FPKM)) %>%
  arrange(-mean_FPKM)



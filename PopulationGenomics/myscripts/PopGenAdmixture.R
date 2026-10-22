library(tidyverse)
setwd("~/SydHoustonEcoGenomics/PopulationGenomics/mydata")

# Choosing K 

cv <- read_tsv("cv_errors.tsv", col_names = c("K", "CV_error"))

cv_plot <- ggplot(cv, aes(K, CV_error)) +
  geom_line() +
  geom_point(size = 2) +
  scale_x_continuous(breaks = cv$K) +
  labs(x = "K (number of ancestral populations)", y = "Cross-validation error") +
  theme_bw()

OUTDIR="~/SydHoustonEcoGenomics/PopulationGenomics/myresults/PopulationStructure"

cv_plot
ggsave(cv_plot, file = paste0(OUTDIR, "/cv_error.png"), width = 6, height = 4)

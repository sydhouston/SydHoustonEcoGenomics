setwd("~/SydHoustonEcoGenomics/Transcriptomics/mydata")

library(DESeq2)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
library(ggpubr)
library(wesanderson)
library(vsn)
library(pheatmap)
library(eulerr)  

countsTable <- read.table("salmon.isoform.counts.matrix.filteredAssembly", header = TRUE, row.names = 1)
head(countsTable)
dim(countsTable)
# [1] 67916    38

# Because DESEQ doesnt like decimals, needs whole numbers
countsTableRound <- round(countsTable)  
head(countsTableRound)

# Import the sample description table
conds <- read.delim("ahud_samples_R.txt", header=TRUE, stringsAsFactors = TRUE, row.names=1)
head(conds)
dim(conds)
# [1] 38  2

dds <- DESeqDataSetFromMatrix(countData = countsTableRound, colData=conds, 
                              design= ~ treatment)
nrow(dds)
# 67916

# Filter 
dds <- dds[rowSums(counts(dds) >= 15) >= 28,]
nrow(dds)

# 25260

67916 - 25260

# 42656 transcripts removed during filtering

# Subset the DESeqDataSet to the specific level of the "generation" factor

dds_F0 <- subset(dds, select = generation == 'F0')
dim(dds_F0)

dds_F4 <- subset(dds, select = generation == 'F4')
dim(dds_F4)

# Perform DESeq2 analysis on the subset

dds_F0 <- DESeq(dds_F0)
dds_F4 <- DESeq(dds_F4)

resultsNames(dds_F0)
# [1] "Intercept" "treatment_OA_vs_AM"  "treatment_OW_vs_AM"  "treatment_OWA_vs_AM"
resultsNames(dds_F4)
# [1] "Intercept" "treatment_OA_vs_AM"  "treatment_OW_vs_AM"  "treatment_OWA_vs_AM"


# For F0

res_OWAvsAM_F0 <- results(dds_F0, name="treatment_OWA_vs_AM", alpha=0.05)
res_OWAvsAM_F0 <- res_OWAvsAM_F0[order(res_OWAvsAM_F0$padj),] 
head(res_OWAvsAM_F0)  
summary(res_OWAvsAM_F0)
#up: 2343, 9.3%
#down: 1575, 6.2%
#outliers: 22, 0.087%
#low counts: 979, 3.9%

res_OWvsAM_F0 <- results(dds_F0, name="treatment_OW_vs_AM", alpha=0.05)
res_OWvsAM_F0 <- res_OWvsAM_F0[order(res_OWvsAM_F0$padj),]
head(res_OWvsAM_F0) 
summary(res_OWvsAM_F0)
#up: 3468, 14%
#down: 2049, 8.1%
#outliers: 22, 0.087%
#low counts: 490, 1.9%

res_OAvsAM_F0 <- results(dds_F0, name="treatment_OA_vs_AM", alpha=0.05)
res_OAvsAM_F0 <- res_OAvsAM_F0[order(res_OAvsAM_F0$padj),]
head(res_OAvsAM_F0) 
summary(res_OAvsAM_F0)
#up: 426, 1.7%
#down: 176, 0.7%
#outliers: 22, 0.087%
#low counts: 3428, 14%

# For F4

res_OWAvsAM_F4 <- results(dds_F4, name="treatment_OWA_vs_AM", alpha=0.05)
res_OWAvsAM_F4 <- res_OWAvsAM_F4[order(res_OWAvsAM_F4$padj),] #sorts by significance so that head shows the most significant
head(res_OWAvsAM_F4)  
summary(res_OWAvsAM_F4)
#up: 103, 0.41%
#down: 138, 0.55%
#outliers: 12, 0.048%
#low counts: 980, 3.9%

res_OWvsAM_F4 <- results(dds_F4, name="treatment_OW_vs_AM", alpha=0.05)
res_OWvsAM_F4 <- res_OWvsAM_F4[order(res_OWvsAM_F4$padj),]
head(res_OWvsAM_F4) 
summary(res_OWvsAM_F4)
#up: 110, 0.44%
#down: 43, 0.17%
#outliers: 12, 0.048%
#low counts: 2449, 9.7%

res_OAvsAM_F4 <- results(dds_F4, name="treatment_OA_vs_AM", alpha=0.05)
res_OAvsAM_F4 <- res_OAvsAM_F4[order(res_OAvsAM_F4$padj),]
head(res_OAvsAM_F4) 
summary(res_OAvsAM_F4)
#up: 107, 0.42%
#down: 50, 0.2%
#outliers: 12, 0.048%
#low counts: 3429, 14%

# Getting the top 5 most significant genes for each and their LFC
head(res_OAvsAM_F0[, c("log2FoldChange", "padj")], 5)
head(res_OWvsAM_F0[, c("log2FoldChange", "padj")], 5)
head(res_OWAvsAM_F0[, c("log2FoldChange", "padj")], 5)
head(res_OAvsAM_F4[, c("log2FoldChange", "padj")], 5)
head(res_OWvsAM_F4[, c("log2FoldChange", "padj")], 5)
head(res_OWAvsAM_F4[, c("log2FoldChange", "padj")], 5)

# PCA

vsd <- vst(dds, blind=FALSE)

data <- plotPCA(vsd, intgroup=c("treatment","generation"), returnData=TRUE)
percentVar <- round(100 * attr(data,"percentVar"))

###########  

dataF0 <- subset(data, generation == 'F0')

F0 <- ggplot(dataF0, aes(PC1, PC2)) +
  geom_point(size=10, stroke = 1.5, aes(fill=treatment, shape=treatment)) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance")) +
  ylim(-40, 25) + xlim(-50, 55)+ # zoom for F0 with new assembly
  scale_shape_manual(values=c(21,22,23,24), labels = c("Ambient", "Acidification","Warming", "OWA"))+
  scale_fill_manual(values=c('#6699CC',"#F2AD00","#00A08A", "#CC3333"), labels = c("Ambient", "Acidification","Warming", "OWA"))+
  theme_bw() +
  theme(legend.position = "bottom") +
  theme(panel.border = element_rect(color = "black", fill = NA, size = 4))+
  theme(text = element_text(size = 20)) +
  theme(legend.title = element_blank())

F0

dataF4 <- subset(data, generation == 'F4')

F4 <- ggplot(dataF4, aes(PC1, PC2)) +
  geom_point(size=10, stroke = 1.5, aes(fill=treatment, shape=treatment)) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance")) +
  ylim(-40, 25) + xlim(-50, 55)+ # limits with filtered assembly
  scale_shape_manual(values=c(21,22,23,24), labels = c("Ambient", "Acidification","Warming", "OWA"))+
  scale_fill_manual(values=c('#6699CC',"#F2AD00","#00A08A", "#CC3333"), labels = c("Ambient", "Acidification","Warming", "OWA"))+
  guides(shape = guide_legend(override.aes = list(shape = c( 21,22, 23, 24))))+
  guides(fill = guide_legend(override.aes = list(shape = c( 21,22, 23, 24))))+
  guides(shape = guide_legend(override.aes = list(size = 5)))+
  theme_bw() +
  theme(legend.position = "bottom") +
  theme(panel.border = element_rect(color = "black", fill = NA, size = 4))+
  theme(text = element_text(size = 20)) +
  theme(legend.title = element_blank())

F4

ggarrange(F0, F4,
          nrow = 1, ncol = 2,
          common.legend = TRUE,
          legend = "bottom")

# Heatmap for F4

vsd <- vst(dds_F4, blind=FALSE)
topgenes <- head(rownames(res_OWvsAM_F4),100)
mat <- assay(vsd)[topgenes,]
mat <- mat - rowMeans(mat)
df <- as.data.frame(colData(dds_F4)[,c("treatment", "generation")])
pheatmap(mat, annotation_col=df, cluster_cols = F, show_rownames = F)

# Euler Diagrams

install.packages("UpSetR")
library(UpSetR)

# For OW vs AM F0
res_OWvsAM_F0 <- results(dds_F0, name="treatment_OW_vs_AM", alpha=0.05) # pull out the results for the contrast of interest
res_OWvsAM_F0 <- res_OWvsAM_F0[order(res_OWvsAM_F0$padj),] 
res_OWvsAM_F0 <- res_OWvsAM_F0[!is.na(res_OWvsAM_F0$padj),] # get rid of any NAs
degs_OWvsAM_F0 <- row.names(res_OWvsAM_F0[res_OWvsAM_F0$padj < 0.05,]) # make a list of significant differentially expressed genes for this contrast

# For OA vs AM F0
res_OAvsAM_F0 <- results(dds_F0, name="treatment_OA_vs_AM", alpha=0.05)
res_OAvsAM_F0 <- res_OAvsAM_F0[order(res_OAvsAM_F0$padj),]
res_OAvsAM_F0 <- res_OAvsAM_F0[!is.na(res_OAvsAM_F0$padj),]
degs_OAvsAM_F0 <- row.names(res_OAvsAM_F0[res_OAvsAM_F0$padj < 0.05,])

# For OWA vs AM F0
res_OWAvsAM_F0 <- results(dds_F0, name="treatment_OWA_vs_AM", alpha=0.05)
res_OWAvsAM_F0 <- res_OWAvsAM_F0[order(res_OWAvsAM_F0$padj),]
res_OWAvsAM_F0 <- res_OWAvsAM_F0[!is.na(res_OWAvsAM_F0$padj),]
degs_OWAvsAM_F0 <- row.names(res_OWAvsAM_F0[res_OWAvsAM_F0$padj < 0.05,])

# For OW vs AM F4
res_OWvsAM_F4 <- results(dds_F4, name="treatment_OW_vs_AM", alpha=0.05) # pull out the results for the contrast of interest
res_OWvsAM_F4 <- res_OWvsAM_F4[order(res_OWvsAM_F4$padj),]
res_OWvsAM_F4 <- res_OWvsAM_F4[!is.na(res_OWvsAM_F4$padj),] # get rid of any NAs
degs_OWvsAM_F4 <- row.names(res_OWvsAM_F4[res_OWvsAM_F4$padj < 0.05,])

# For OA vs AM F4
res_OAvsAM_F4 <- results(dds_F4, name="treatment_OA_vs_AM", alpha=0.05)
res_OAvsAM_F4 <- res_OAvsAM_F4[order(res_OAvsAM_F4$padj),]
res_OAvsAM_F4 <- res_OAvsAM_F4[!is.na(res_OAvsAM_F4$padj),]
degs_OAvsAM_F4 <- row.names(res_OAvsAM_F4[res_OAvsAM_F4$padj < 0.05,])

# For OWA vs AM F4
res_OWAvsAM_F4 <- results(dds_F4, name="treatment_OWA_vs_AM", alpha=0.05)
res_OWAvsAM_F4 <- res_OWAvsAM_F4[order(res_OWAvsAM_F4$padj),]
res_OWAvsAM_F4 <- res_OWAvsAM_F4[!is.na(res_OWAvsAM_F4$padj),]
degs_OWAvsAM_F4 <- row.names(res_OWAvsAM_F4[res_OWAvsAM_F4$padj < 0.05,])

################ For F0 ################

# Total
length(degs_OAvsAM_F0)  #602
length(degs_OWvsAM_F0)  #5517
length(degs_OWAvsAM_F0)  #3918 

# Intersections
length(intersect(degs_OAvsAM_F0,degs_OWvsAM_F0))  #444
length(intersect(degs_OAvsAM_F0,degs_OWAvsAM_F0))  #380
length(intersect(degs_OWAvsAM_F0,degs_OWvsAM_F0))  #2743 

# Shared across All
intWA <- intersect(degs_OAvsAM_F0,degs_OWvsAM_F0)
length(intersect(degs_OWAvsAM_F0,intWA)) #338

# Number unique to each treatment
602-444-380+338 # 116 OA
5517-444-2743+338 # 2668 OW 
3918-380-2743+338 # 1133 OWA

# Number shared in pairs of treatments

444-338 # 106 OA & OW
380-338 # 42 OA & OWA
2743-338 # 2405 OWA & OW

# Now assemble the results
# Note that the names are important and have to be specific to line up the diagram
fit1 <- euler(c("OA" = 116, 
                "OW" = 2668, 
                "OWA" = 1133, 
                "OA&OW" = 106, 
                "OA&OWA" = 42, 
                "OW&OWA" = 2405, 
                "OA&OW&OWA" = 338))

# And make the plot!
plot(fit1,  lty = 1:3, quantities = TRUE)

################ For F4 ################

# Total
length(degs_OAvsAM_F4)  #157
length(degs_OWvsAM_F4)  #153
length(degs_OWAvsAM_F4) #241 

# Intersections
length(intersect(degs_OAvsAM_F4,degs_OWvsAM_F4))  #58
length(intersect(degs_OAvsAM_F4,degs_OWAvsAM_F4))  #41
length(intersect(degs_OWAvsAM_F4,degs_OWvsAM_F4))  #44 

# Shared across All
intWA <- intersect(degs_OAvsAM_F4,degs_OWvsAM_F4)
length(intersect(degs_OWAvsAM_F4,intWA)) #18

# Number unique to each treatment
157-58-41+18 # 76 OA
153-58-44+18 # 69 OW 
241-41-44+18 # 174 OWA

# Number shared in pairs of treatments

58-18 # 40 OA & OW
41-18 # 23 OA & OWA
44-18 # 26 OWA & OW

# Now assemble the results
# Note that the names are important and have to be specific to line up the diagram
fit2 <- euler(c("OA" = 76, 
                "OW" = 69, 
                "OWA" = 174, 
                "OA&OW" = 40, 
                "OA&OWA" = 23, 
                "OW&OWA" = 26, 
                "OA&OW&OWA" = 18),)


# And make the plot!
plot(fit2,  lty = 1:3, quantities = TRUE)

ggarrange(fit1, fit2, nrow = 1, ncol=2)

# Percentage of OWA DEGs unique to the combined treatment
#### F0 ####
(1133 / 3918) * 100
# 28.91782
#### F4 ####
(174 / 241) * 100
#72.19917

#DEGs shared only between OW and OWA (notshared w/ OA)
#### F0 ####
2743 - 338
#### F4 ####
44 - 18

######### Scatterplots ##########


############# F0 #############

# Create merged data frame - need to use rownames because differences in filtering
plot_OWA_F0 <- data.frame(
  gene = rownames(res_OWAvsAM_F0),
  LFC_OWA = res_OWAvsAM_F0$log2FoldChange,
  padj_OWA = res_OWAvsAM_F0$padj
)

plot_OW_F0 <- data.frame(
  gene = rownames(res_OWvsAM_F0),
  LFC_OW = res_OWvsAM_F0$log2FoldChange,
  padj_OW = res_OWvsAM_F0$padj
)

plot_df_F0 <- merge(plot_OWA_F0,
                 plot_OW_F0,
                 by = "gene")

# Remove genes with missing LFC values
plot_df_F0 <- plot_df_F0 %>%
  filter(!is.na(LFC_OWA), !is.na(LFC_OW))

# Classify significance
plot_df_F0 <- plot_df_F0 %>%
  mutate(
    SigGroup = case_when(
      padj_OWA < 0.05 & padj_OW < 0.05 ~ "Both",
      padj_OWA < 0.05 ~ "OWA only",
      padj_OW < 0.05 ~ "OW only",
      TRUE ~ "Neither"
    )
  )

# Correlation for noting on the plot 
r <- cor(plot_df_F0$LFC_OWA,
         plot_df_F0$LFC_OW,
         use = "complete.obs")

# Arrange the genes by significant to make the plotting easier/more interesting to see
# ggplot plots in the order of the df, so random

plot_df_F0$SigGroup <- factor(
  plot_df_F0$SigGroup,
  levels = c("Neither", "OWA only", "OW only", "Both")
)

plot_df_F0 <- plot_df_F0 %>%
  arrange(SigGroup)

# Now make the plot!

P_F0 <- ggplot(plot_df_F0,
       aes(x = LFC_OW,
           y = LFC_OWA,
           color = SigGroup)) +
  
  geom_point(alpha = 0.6, size = 1.5) +
  
  geom_abline(intercept = 0,
              slope = 1,
              linetype = "dashed",
              color = "black") +
  
  geom_hline(yintercept = 0,
             color = "grey70") +
  
  geom_vline(xintercept = 0,
             color = "grey70") +
  
  annotate("text",
           x = min(plot_df_F0$LFC_OW, na.rm = TRUE),
           y = max(plot_df_F0$LFC_OWA, na.rm = TRUE),
           hjust = 0,
           label = paste0("r = ", round(r, 3))) +
  
  scale_color_manual(values = c(
    "Both" = "purple",
    "OWA only" = "#CC3333",
    "OW only" = "#00A08A",
    "Neither" = "grey80"
  )) +
  
  coord_fixed() + # forces the same scaling on x and y axes
  
  labs(
    x = "Log2 Fold Change: OW vs AM",
    y = "Log2 Fold Change: OWA vs AM",
    color = "",
    title = "F0 GE Responses to OW relative to OWA"
  ) +
  
  theme_bw(base_size = 14) +
  theme(
    panel.grid = element_blank(),
    legend.position = "right"
  )

########## F4 #############

# Create merged data frame - need to use rownames because differences in filtering
plot_OWA_F4 <- data.frame(
  gene = rownames(res_OWAvsAM_F4),
  LFC_OWA = res_OWAvsAM_F4$log2FoldChange,
  padj_OWA = res_OWAvsAM_F4$padj
)

plot_OW_F4 <- data.frame(
  gene = rownames(res_OWvsAM_F4),
  LFC_OW = res_OWvsAM_F4$log2FoldChange,
  padj_OW = res_OWvsAM_F4$padj
)

plot_df_F4 <- merge(plot_OWA_F4,
                    plot_OW_F4,
                    by = "gene")

# Remove genes with missing LFC values
plot_df_F4 <- plot_df_F4 %>%
  filter(!is.na(LFC_OWA), !is.na(LFC_OW))

# Classify significance
plot_df_F4 <- plot_df_F4 %>%
  mutate(
    SigGroup = case_when(
      padj_OWA < 0.05 & padj_OW < 0.05 ~ "Both",
      padj_OWA < 0.05 ~ "OWA only",
      padj_OW < 0.05 ~ "OW only",
      TRUE ~ "Neither"
    )
  )

# Correlation for noting on the plot 
r <- cor(plot_df_F4$LFC_OWA,
         plot_df_F4$LFC_OW,
         use = "complete.obs")

# Arrange the genes by significant to make the plotting easier/more interesting to see
# ggplot plots in the order of the df, so random

plot_df_F4$SigGroup <- factor(
  plot_df_F4$SigGroup,
  levels = c("Neither", "OWA only", "OW only", "Both")
)

plot_df_F4 <- plot_df_F4 %>%
  arrange(SigGroup)

# Now make the plot!

P_F4 <- ggplot(plot_df_F4,
       aes(x = LFC_OW,
           y = LFC_OWA,
           color = SigGroup)) +
  
  geom_point(alpha = 0.6, size = 1.5) +
  
  geom_abline(intercept = 0,
              slope = 1,
              linetype = "dashed",
              color = "black") +
  
  geom_hline(yintercept = 0,
             color = "grey70") +
  
  geom_vline(xintercept = 0,
             color = "grey70") +
  
  annotate("text",
           x = min(plot_df_F4$LFC_OW, na.rm = TRUE),
           y = max(plot_df_F4$LFC_OWA, na.rm = TRUE),
           hjust = 0,
           label = paste0("r = ", round(r, 3))) +
  
  scale_color_manual(values = c(
    "Both" = "purple",
    "OWA only" = "#CC3333",
    "OW only" = "#00A08A",
    "Neither" = "grey80"
  )) +
  
  coord_fixed() + # forces the same scaling on x and y axes
  
  labs(
    x = "Log2 Fold Change: OW vs AM",
    y = "Log2 Fold Change: OWA vs AM",
    color = "",
    title = "F4 GE Responses to OW relative to OWA"
  ) +
  
  theme_bw(base_size = 14) +
  theme(
    panel.grid = element_blank(),
    legend.position = "right"
  )
ggarrange(P_F0, P_F4,
          nrow = 1, ncol = 2,
          common.legend = TRUE,
          legend = "bottom")


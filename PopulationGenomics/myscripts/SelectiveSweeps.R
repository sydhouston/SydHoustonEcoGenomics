library(tidyverse)
setwd("~/SydHoustonEcoGenomics/PopulationGenomics/mydata")
OUTDIR="~/SydHoustonEcoGenomics/PopulationGenomics/myresults"

env <- read_csv("sample_metadata.csv")
pw  <- read_tsv("fst/pairwise_fst_summary.txt")

# order the populations from south to north
env <- env %>%
  distinct(Population, Latitude, Longitude)
pop_order <- env$Population[order(env$Latitude)]

# add each pair in both directions so the heatmap is symmetrical
pw_both <- bind_rows(pw, select(pw, pop1 = pop2, pop2 = pop1, mean_fst, weighted_fst)) %>%
  mutate(pop1 = factor(pop1, levels = pop_order),
         pop2 = factor(pop2, levels = pop_order))

ggplot(pw_both, aes(x = pop1, y = pop2, fill = weighted_fst)) +
  geom_tile(colour = "white") +
  geom_text(aes(label = round(weighted_fst, 3)), size = 2.5) +
  scale_fill_gradient(low = "paleturquoise1", high = "deeppink", name = "Weighted\nFST") +
  labs(x = NULL, y = NULL,
       title = "Genome-wide pairwise FST (populations ordered south to north)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(paste0(OUTDIR,"/pairwise_fst_heatmap.png"), width = 7, height = 6)

# Does differentiation increase with the geographic distance between populations?

pw_dist <- pw %>%
  left_join(select(env, Population, lat1 = Latitude), by = c("pop1" = "Population")) %>%
  left_join(select(env, Population, lat2 = Latitude), by = c("pop2" = "Population")) %>%
  mutate(lat_diff = abs(lat1 - lat2))

ggplot(pw_dist, aes(x = lat_diff, y = weighted_fst)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = FALSE, colour = "hotpink") +
  labs(x = "Difference in latitude (degrees)", y = "Weighted FST",
       title = "Isolation by distance?") +
  theme_classic()

ggsave(paste0(OUTDIR,"/fst_vs_distance.png"), width = 5, height = 4)

"vcftools --gzvcf ${VCF} \
  --weir-fst-pop pops/${POP1}.txt \
  --weir-fst-pop pops/${POP2}.txt \
  --fst-window-size 10000 \
  --fst-window-step 10000 \
  --out fst/${POP1}_vs_${POP2}_FST_10kb \
  2> fst/${POP1}_vs_${POP2}_FST_10kb.log"

pop1 <- "ASU"   #the same two populations as in the bash code
pop2 <- "KRU"

fst_win <- read_tsv(paste0("fst/", pop1, "_vs_", pop2, "_FST_10kb.windowed.weir.fst"))



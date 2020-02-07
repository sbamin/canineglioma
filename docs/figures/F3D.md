---
title: F3D &middot; Comparative Molecular Timing of Driver Events
---

### Winning Tables

>Make winning matrix of somatic variants in cancer driver genes (n=73) based on inferred clonality using [*Palimpsest*](https://github.com/FunGeST/Palimpsest) R package[^1]. Author of Palimpsest package has provided [a detailed documentation](https://github.com/FunGeST/Palimpsest/raw/master/Files/vignette_palimpsest_2.0.pdf) on how to run Palimpsest workflow.

```r
## function to trim vcfs and make winning tables

mk_win_table <- function(win_table_vcf) {

  vcf_timing <- win_table_vcf %>%
    add_count(Gene_Name, timing_state) %>%
    mutate(result = case_when(grepl("early_clonal", timing_state) ~ 5,
                              grepl("early_subclonal", timing_state) ~ 1,
                              grepl("late_clonal", timing_state) ~ -5,
                              grepl("late_subclonal", timing_state) ~ -1,
                              TRUE ~ 0)) %>%
    dplyr::select(Gene_Name, result, n) %>%
    distinct() %>%
    dplyr::select(Gene_Name, result, n) %>%
    ## get weighted counts by multiplying events and occurrence
    mutate(weighted_result = result * n) %>%
    dplyr::rename(freq = n) %>%
    group_by(Gene_Name) %>%
    mutate(mean_result = mean(weighted_result)) %>%
    ungroup() %>%
    arrange(Gene_Name, mean_result) %>%
    distinct(Gene_Name, mean_result) %>%
    ## decide early vs late per driver event using
    ## majority vote
    mutate(timing = case_when(mean_result < 0 ~ "LATE",
                              mean_result > 0 ~ "EARLY",
                              mean_result == 0 ~ "DRAW",
                              TRUE ~ "NONE"))
  
  ## let driver gene compete with one another: combination matrix
  wintbl_combn <- choose(nrow(vcf_timing), 2)
  
  snv_df_wintbl <- as.data.frame(matrix(apply(vcf_timing %>%
                            dplyr::select(Gene_Name,
                            mean_result),
                        2, combn, m = 2),
                    nrow = wintbl_combn),
                    stringsAsFactors = F) %>%
    tbl_df() %>%
    ## rename V1 and V2 to P1 and P2, respectively
    dplyr::rename_at(vars(V1, V2), ~gsub("V", "P", .)) %>%
    ## where _vaf is clonality based estimate if event
    ## is ~clonal (early) or ~subclonal
    dplyr::rename(P1_vaf = V3,
           P2_vaf = V4) %>%
    ## take a win/loss/draw call
    mutate(outcome = case_when(P1_vaf > P2_vaf ~ "P1",
                               P1_vaf < P2_vaf ~ "P2",
                               P1_vaf == P2_vaf ~ "D",
                               TRUE ~ NA_character_)) %>%
    dplyr::select(P1, P2, outcome)
  
  return(snv_df_wintbl)
}

## Get winning tables from vcfs
cg_win_table <- mk_win_table(win_table_cg_vcf)
pg_win_table <- mk_win_table(win_table_pg_vcf)
ag_win_table <- mk_win_table(win_table_ag_vcf)
```

### Fig 3D

>Run *Bradley-Terry model* to get [estimated relative timing of somatic driver events](/methods/S14_mut_timing/).

```r
#### Run and plot BT model ####
## default to Canine Glioma
plot_timing_btmodel <- function(win_table = cg_win_table,
                                plot_title = "Canine Glioma",
                                genes2plot = oncoprint_genes_snv_scna) {

  library(tidyverse)
  library(BradleyTerryScalable)
  
  library(igraph)
  library(ggridges)
  
  set.seed(1989)
    
  #### Import somatic winning table ####
  win_table_raw <- win_table
  
  #### create btdata ####       
  toy_data_4col <- codes_to_counts(win_table_raw, c("P1", "P2", "D"))
  toy_btdata <- btdata(toy_data_4col, return_graph = TRUE)
  
  #### fit model: btfit #### 
  ## Prefer using MAP estimate if summary(toy_btdata) returns
  ## not-fully connected network: Needs to be checked manually
  ## and to follow warning flags
  print(summary(toy_btdata))
  
  toy_fit_MLE <- btfit(toy_btdata, 1)
  toy_fit_MAP <- btfit(toy_btdata, 1.1)
  
  summary(toy_fit_MLE, SE = TRUE)
  summary(toy_fit_MAP, SE = TRUE)
  
  coef(toy_fit_MLE)
  coef(toy_fit_MAP)

  vcov(toy_fit_MLE, ref = "home")
  vcov(toy_fit_MAP, ref = "home")
    
  #### get winning prob ####
  
  fitted(toy_fit_MLE, as_df = TRUE)
  fitted(toy_fit_MAP, as_df = TRUE)
  
  btprob(toy_fit_MAP, as_df = TRUE)
  btprob(toy_fit_MLE, as_df = TRUE)
  
  toy_fit_MAP_prob <- btprob(toy_fit_MAP)
  toy_fit_map_df <- btprob(toy_fit_MAP, as_df = TRUE)
  
  toy_fit_map_mat <- as.data.frame(as.matrix(toy_fit_MAP_prob))
  
  ## convert to rank-order df
  toy_fit_map_mat_ranked <- toy_fit_map_mat %>%
    rownames_to_column("driver") %>%
    mutate_at(vars(-driver), ~(1 - cume_dist(.)))
  
  ## probability long table
  toy_fit_map_mat_long_tbl <- toy_fit_map_mat %>%
    rownames_to_column() %>%
    gather(p2, prob, -rowname) %>%
    distinct()
  
  ## rank order long table
  toy_fit_map_mat_ranked_long_tbl <- toy_fit_map_mat_ranked %>%
    gather(p2, rank, -driver) %>%
    distinct()
  
  #### Figure 3D: Timing Plots ####
  
  toy_fit_map_mat_long_tbl <- toy_fit_map_mat %>%
    rownames_to_column() %>%
    ## select rows to plot matching genes found in
    ## known somatic driver genes
    filter(rowname %in% genes2plot) %>%
    gather(p2, prob, -rowname) %>%
    distinct()
  
  #### export timing plots ####
  ggplot(toy_fit_map_mat_long_tbl,
    aes(1-prob, rowname, fill = ..x..), group = p2) +
    geom_density_ridges_gradient(scale = 1, rel_min_height = 0.01) +
    viridis::scale_fill_viridis(name = "Probability", option = "C") +
    labs(title = plot_title,
         x = "Probability being a late event",
         y = "Somatic Drivers") +
    guides(fill = guide_colorbar(barwidth = 15,
                                 barheight = 1.5)) +
    theme_ridges(font_size = 22) +
    theme(legend.position="bottom")

}

## plot per-cohort relative timing probabilities of driver genes
timing_plot_canine <- plot_timing_btmodel(win_table = cg_win_table,
                                plot_title = "Canine Glioma",
                                genes2plot = oncoprint_genes_snv_scna)

timing_plot_peds <- plot_timing_btmodel(win_table = pg_win_table,
                                plot_title = "Human Pediatric Glioma",
                                genes2plot = oncoprint_genes_snv_scna)

timing_plot_adult <- plot_timing_btmodel(win_table = ag_win_table,
                                plot_title = "human Adult Glioma",
                                genes2plot = oncoprint_genes_snv_scna)

library(gridExtra)

ggsave("F3D.pdf",
    grid.arrange(timing_plot_canine,
                timing_plot_peds,
                timing_plot_adult,
                ncol = 3,
                widths = c(4,4,4), heights = c(4,4,4)),
    width = 24,
    height = 24,
    useDingbats = FALSE)
```

[^1]: Shinde J, Bayard Q, Imbeaud S, Hirsch TZ, Liu F, Renault V, et al. Palimpsest: an R package for studying mutational and structural variant signatures along clonal evolution in cancer. Bioinformatics 2018. doi: [10.1093/bioinformatics/bty388](https://doi.org/10.1093/bioinformatics/bty388).

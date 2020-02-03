---
title: F1D &middot; Comparative Somatic Mutational Burden
---

### Fig 1D

>Plot CNS tumors.

```r
master_mutrate_table_cns_cg_who <- mutrate_table %>%
  mutate(who_subtype = case_when(cohort == "Canine Glioma" ~ "Canine Glioma",
                                 TRUE ~ who_subtype)) %>%
  filter(tumor_location == "Brain", total_per_mb < 10) %>%
  mutate(ctype = reorder(x = who_subtype, X = total_per_mb, FUN = median)) %>%
  select(-who_subtype) %>%
  dplyr::rename(who_subtype = ctype)

log1py_breaks_cns = c(0, 0.5, 1, 2, 5, 10)

mutrate_plot1_cns_cg_who <- ggplot(master_mutrate_table_cns_cg_who,
                                   aes(x = who_subtype,
                                       y = total_per_mb))

## color x-axis based on cohort
mutrate_plot1_cns_axis_colour_cg_who <- master_mutrate_table_cns_cg_who[
    match(levels(master_mutrate_table_cns_cg_who$who_subtype), master_mutrate_table_cns_cg_who$who_subtype, nomatch = 0),
    "cohort"
    ] %>%
  mutate(axis_colour = case_when(grepl("Adult", cohort) ~ "#8da0cb",
                                 grepl("Pedia", cohort) ~ "#fc8d62",
                                 grepl("Canine", cohort) ~ "#66c2a5",
                                 TRUE ~ "#ffffff")) %>%
  pull(axis_colour)

fig_1D <- mutrate_plot1_cns_cg_who +
  geom_boxplot(aes(fill = cohort)) +
  geom_jitter(width = 0.2) +
  scale_y_continuous(trans = "log1p", breaks = log1py_breaks_cns) +
  cowplot::theme_cowplot(font_size = 22) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, colour = mutrate_plot1_cns_axis_colour_cg_who),
        legend.position = "bottom", legend.key.size = unit(1, "cm")) +
  labs(x = "CNS cancer types across 1,443 patients",
       y = "Total coding snvs+indels per MB in log(x+1) scale") +
  scale_fill_manual(values = c("#66c2a5", "#8da0cb", "#fc8d62"),
                    name="CNS Tumors",
                    labels=c("Canine", "Adult GBM", "Pediatric"))

cowplot::save_plot("F1D.pdf", fig_1D,
                   base_height = 12, base_width = 16,
                   dpi = "retina", useDingbats=FALSE)
```

### Suppl Fig 1D

>Plot pancancer tumors

```r
master_mutrate_table_cg_who <- mutrate_table %>%
  mutate(who_subtype = case_when(cohort == "Canine Glioma" ~ "Canine Glioma",
                                 TRUE ~ who_subtype)) %>%
  mutate(ctype = reorder(x = who_subtype, X = total_per_mb, FUN = median)) %>%
  select(-who_subtype) %>%
  dplyr::rename(who_subtype = ctype)

log1py_breaks = c(0, 0.5, 1, 2, 5, 10,20,50,100,300,500)

mutrate_plot1_all_cg_who <- ggplot(master_mutrate_table_cg_who,
                                   aes(x = who_subtype,
                                       y = total_per_mb))

## color x-axis based on cohort
mutrate_plot1_axis_colour_cg_who <- master_mutrate_table_cg_who[
    match(levels(master_mutrate_table_cg_who$who_subtype),
    master_mutrate_table_cg_who$who_subtype, nomatch = 0),
    "cohort"
    ] %>%
  mutate(axis_colour = case_when(grepl("Adult", cohort) ~ "#8da0cb",
                                 grepl("Pedia", cohort) ~ "#fc8d62",
                                 grepl("Canine", cohort) ~ "#66c2a5",
                                 TRUE ~ "#ffffff")) %>%
  pull(axis_colour)

suppl_fig_1D <- mutrate_plot1_all_cg_who +
  geom_boxplot(aes(fill = tumor_location)) +
  geom_jitter(width = 0.2) +
  scale_y_continuous(trans = "log1p", breaks = log1py_breaks) +
  cowplot::theme_cowplot(font_size = 22) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, colour = mutrate_plot1_axis_colour_cg_who),
        legend.position = "bottom", legend.key.size = unit(1, "cm")) +
  labs(x = "Cancer type across 4,840 patients",
       y = "Total coding snvs+indels per MB in log(x+1) scale")

cowplot::save_plot("SF1D.pdf", suppl_fig_1D,
                   base_height = 12, base_width = 16,
                   dpi = "retina", useDingbats=FALSE)
```

### Suppl Fig 1E

>Comparing mutational burden across molecular subtypes.

```r
high_grade_gliomas <- cgp_suppl_sample_info_master %>%
  filter(Tumor_Grade == "High") %>%
  pull(Tumor_Sample_Barcode)

mutrate_table_cns_hgg_idh_classes_cg_who <- master_mutrate_table_cns_cg_who %>%
  filter(grepl("IDH|H3", who_subtype) | 
           (cohort == "Canine Glioma" & sample %in% high_grade_gliomas)) %>%
  rename(who_subtype_orig = who_subtype) %>%
  mutate(who_subtype_orig = if_else(cohort == "Canine Glioma", "Canine HGG", as.character(who_subtype_orig))) %>%
  mutate(who_subtype = reorder(x = who_subtype_orig, X = total_per_mb, FUN = median))

mutrate_comparisons_idh_classes_cg_who <- list(c("Canine HGG", "H3wt"),
                                               c("Canine HGG", "H3mut"),
                                               c("H3wt", "IDHmut-codel"),
                                               c("H3mut", "IDHmut-codel"),
                                               c("H3mut", "H3wt"),
                                               c("Canine HGG", "IDHwt"),
                                               c("Canine HGG", "IDHmut-non-codel"),
                                               c("Canine HGG", "IDHmut-codel"))

suppl_fig_1E <- ggpubr::ggboxplot(mutrate_table_cns_hgg_idh_classes_cg_who,
    x = "who_subtype", y = "total_per_mb",
    add = "jitter", bxp.errorbar = TRUE, notch = TRUE,
    font.label = list(size = 18, color = "black"),
    ylab = "Somatic Mutation Rate\nper MB",
    xlab = "Molecular Subtype",
    fill = c("#fc8d62", "#fc8d62", "#66c2a5",
        "#8da0cb", "#8da0cb", "#8da0cb")) +
  theme(axis.text = element_text(size = 18),
        axis.title = element_text(size = 20)) +
  ggpubr::stat_compare_means(comparisons = mutrate_comparisons_idh_classes_cg_who,
    method = "wilcox.test")

cowplot::save_plot("SF1E",
                   suppl_fig_1E,
                   base_height = 12, base_width = 16,
                   dpi = "retina",
                   useDingbats = FALSE)
```

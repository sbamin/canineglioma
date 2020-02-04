---
title: F2D &middot; Comparative Intratumor Heterogeneity
---

### Fig 2D

>Clonality of potential driver genes with respect to intra-tumor heterogeneity as measured with Shannon entropy.

```r
fig_2D <- ggplot(merged_ccf_vaf_df %>%
    ## Pediatric LGG has minimal somatic
    ## drivers, i.e., ~ quiet genome
    filter(who_subtype != "PG_LGG"), 
    aes(x = Shannon_entropy,
        y = Cellular_Prevalence,
     label = Hugo_Symbol)) +
    geom_point(alpha=0.3,
        aes(colour = clone_type, size = VAF)) +
    scale_size(range = c(.1, 10), name = "VAF") +
    ggrepel::geom_label_repel(
    data = . %>%
    filter(Hugo_Symbol %in%
        c(oncoprint_genes_snv_scna, "CIC")) %>%
    group_by(who_subtype, clone_type) %>%
    add_count(Hugo_Symbol, sort = T) %>%
    mutate(Hugo_Symbol = sprintf("%s (%s)", Hugo_Symbol, n)) %>%
    filter((who_subtype != "PG_H3wt" & n >= 1) | 
           (who_subtype == "PG_H3wt" & n >= 2))
    ungroup() %>%
    distinct(Hugo_Symbol, .keep_all = TRUE),
    nudge_x = 0.25,
    direction = "y",
    hjust = 0,
    force = 2,
    segment.size = 0.2,
    size = 6,
    seed = 1234) +
    facet_wrap(~ who_subtype) +
    cowplot::theme_cowplot(font_size = 24) +
    theme(legend.position = "bottom",
    legend.box = "vertical",
    legend.text = element_text(size = 14)) +
    guides(colour = guide_legend(override.aes = list(size = 10, alpha = 1)))

cowplot::save_plot("F2D",
          fig_2D,
          base_height = 12, base_width = 16,
          dpi = "retina", useDingbats = FALSE)
```

### Suppl Fig 2D

>Comparative intra-tumor heterogeneity measured using Shannon entropy.

```r
suppl_fig_2D <- ggpubr::ggboxplot(updated_merged_entropy_df_ridges,
    x = "who_subtype", y = "Shannon_entropy",
    add = "jitter",
    bxp.errorbar = TRUE, notch = FALSE,
    font.label = list(size = 18, color = "black"),
    ylab = "Shannon Diversity Index",
    xlab = "Molecular Subtype",
    fill = c("#8da0cb", "#8da0cb",
          "#66c2a5",
          "#fc8d62", "#fc8d62", "#fc8d62")) +
    theme(axis.text = element_text(size = 18),
    axis.title = element_text(size = 20)) +
    ggpubr::stat_compare_means(ref.group = "Canine Glioma",
    method = "wilcox.test",
    label = "p.format", hide.ns = TRUE,
    size = 5, label.y = 1.1)

save_plot("SF2D.pdf",
          suppl_fig_2D,
          base_height = 12, base_width = 16,
          dpi = "retina",
          useDingbats = FALSE)
```

---
title: F2B &middot; Comparative Aneuploidy Burden
---

### Fig 2B

>Comparative aneuploidy burden.

```r
fig_2B <- ggpubr::ggboxplot(merged_anp_scores %>%
    filter(!grepl("_LGG", who_subtype_alt2)) %>%
    mutate(cohort = ordered(who_subtype_alt2,
    levels = c("Canine Glioma",
         "H3wt", "H3mut",
         "IDHmut-codel",
         "IDHmut-non-codel",
         "IDHwt"))),
    x = "cohort", y = "aneuploidy",
    add = "jitter", notch = TRUE,
    bxp.errorbar = TRUE,
    xlab = "",
    ylab = "Fraction of genome\nwith aneuploidy",
    fill = c("#66c2a5",
           "#fc8d62", "#fc8d62",
           "#8da0cb", "#8da0cb" , "#8da0cb")) +
    ggpubr::stat_compare_means(ref.group = "Canine Glioma",
    method = "wilcox.test",
                 label = "p.signif", hide.ns = TRUE,
                 size = 6) +
    cowplot::theme_cowplot(font_size = 24) +
    ## make sure that breaks and labels matches order
    ## defined using levels in ordered function above
    scale_x_discrete(breaks = c("Canine Glioma",
                  "H3wt", "H3mut",
                  "IDHmut-codel",
                  "IDHmut-non-codel",
                  "IDHwt"),
       labels = c("Canine\nGlioma",
                  "H3wt", "H3mut",
                  "IDHmut\ncodel",
                  "IDHmut\nnon-codel",
                  "IDHwt")) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title.x = element_blank())

cowplot::save_plot("F2B",
          fig_2B,
          base_height = 4, base_width = 5,
          dpi = "retina", useDingbats = FALSE)
```

### Suppl Fig 2E

>Aneuploidy vs. somatic mutation burden.

```r
p3_cgp_anp_mutrate_table <- cgp_aneuploidy_metrics_master %>%
    filter(!is.na(adusted_coding_mutrate), !is.na(aneuploidy)) %>%
    mutate_if(bit64::is.integer64, as.integer) %>%
    mutate(mutation_load = if_else(
        ntile(adusted_coding_mutrate, 2) > 1,
        "HIGH", "LOW"))

suppl_fig_2E <- ggpubr::ggboxplot(p3_cgp_anp_mutrate_table,
    "mutation_load", "aneuploidy_score",
    add = "jitter", notch = TRUE,
    xlab = "Coding Mutational Rate",
    ylab = "Anueploidy Score",
    bxp.errorbar = TRUE,
    font.label = list(size = 16, color = "black", face = "bold")) +
    ggpubr::stat_compare_means(method = "wilcox.test", size = 6) +
    cowplot::theme_cowplot(font_size = 24)

save_plot("SF2E.pdf",
          suppl_fig_2E,
          base_height = 12, base_width = 16,
          dpi = "retina",
          useDingbats = FALSE)
```

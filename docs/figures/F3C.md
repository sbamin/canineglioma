---
title: F3C &middot; Comparative Somatic Mutational Signatures in Driver Genes
---

>Plot estimated mutational signature contribution per driver gene.

```r
## Function to plot each of three panels of Fig 3C
plot_driver_gene_signatures <- function(df, xtitle) {

  tmp_driver_vcf <- df %>%
    filter(Gene_Name %in% oncoprint_genes_snv_scna) %>%
    ## extract columns that have signature wise probability per somatic variant
    dplyr::select(Gene_Name, ends_with("prob")) %>%
    distinct() %>%
    gather(sigs, prop, -Gene_Name) %>%
    mutate(prop = if_else(is.na(prop), 0, prop)) %>%
    group_by(Gene_Name) %>%
    mutate(total_prop = sum(prop),
           prop_scaled = scales::rescale(prop, to = c(0, 1))) %>%
    ungroup() %>%
    filter(!total_prop == 0) %>%
    mutate(sigs = sprintf("S%s", gsub("(Signature\\.)([0-9]{1,2})(\\.prob)", "\\2", sigs))) %>%
    left_join(driver_sigs_groups %>% dplyr::rename(sigs = signature))

    cols_sig_group <- c("Aging" = "#b2182b",
                        "MMR" = "#fddbc7",
                        "HR defect" = "#ffffbf",
                        "S18_Neuroblastoma" = "#542788",
                        "APOBEC_AID" = "#ef8a62",
                        "UV" = "#998ec3",
                        "S16_S25" = "lightgray")

  ggplot(tmp_driver_vcf, aes(Gene_Name, prop_scaled, fill = factor(sig_group))) +
    geom_bar(position = "fill",stat = "identity") +
    scale_y_continuous(labels = scales::percent_format()) +
    coord_flip() +
    scale_fill_manual(values = cols_sig_group) +
    theme_cowplot(font_size = 22) +
    labs(x = "Percentage contribution from signatures",
         y = xtitle,
         fill = "Signatures") +
    theme(legend.title = element_text(color = "blue", size = 14),
          legend.text = element_text(size = 12))
}

## Plot Fig 3C panels
plot_driver_genes_sigs_cg <- plot_driver_gene_signatures(trimmed_cg_vcf,
    "Canine")
plot_driver_genes_sigs_pg <- plot_driver_gene_signatures(trimmed_pg_vcf,
    "Pediatric")
plot_driver_genes_sigs_ag <- plot_driver_gene_signatures(trimmed_ag_vcf,
    "Adult")

ggsave("F3C.pdf",
grid.arrange(plot_driver_genes_sigs_cg + theme(legend.position="bottom"),
            plot_driver_genes_sigs_pg + theme(legend.position="bottom"),
            plot_driver_genes_sigs_ag + theme(legend.position="bottom"),
            ncol = 3, widths=c(4,4,4), heights = c(8,8,8)),
width=20,
height=24,
useDingbats = FALSE)
```


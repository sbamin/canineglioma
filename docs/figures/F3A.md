---
title: F3A &middot; Somatic Mutational Signatures - Deconvoluted
---

### Required metadata

*   Canine glioma patients with [outlier mutation profile](/methods/S13_mut_sigs/).

```r
## filter out missing values in mutation rate column
cgp_sample_info_maftools_hypermuts <- cgp_suppl_sample_info_master %>%
  filter(!is.na(adusted_coding_mutrate)) %>%
  arrange(desc(adusted_coding_mutrate))

outlier_model_hypermut <- lm(adusted_coding_mutrate ~ Matched_Normal +
    Tissue_Archival, data = cgp_sample_info_maftools_hypermuts)

summary(outlier_model_hypermut)

## Hypermut outliers after correcting for archival and paired vs tonly mode
hypermut_true_outliers <- car::outlierTest(outlier_model_hypermut,
    cutoff = 0.05,
    labels = cgp_sample_info_maftools_hypermuts$Tumor_Sample_Barcode)

sprintf("hypermut case: %s", names(hypermut_true_outliers$rstudent))

cgp_sample_info_non_hypermut <- cgp_sample_info_maftools_hypermuts %>% 
    filter(!Tumor_Sample_Barcode %in%
    names(hypermut_true_outliers$rstudent))
         
#### outliers in non-hypermut cases
## cases with mut rate exceeding chi sq distribution by > 95% 
outlier_in_non_hypermut_chisq_95 <- cgp_sample_info_non_hypermut[
    outliers::scores(cgp_sample_info_non_hypermut$adusted_coding_mutrate,
    type = "chisq", prob = 0.95),] %>%
    pull(Tumor_Sample_Barcode)

sprintf("outlier among non_hypermut: %s", outlier_in_non_hypermut_chisq_95)

cgp_outlier_mutant_cases <- c(names(hypermut_true_outliers$rstudent),
    outlier_in_non_hypermut_chisq_95)

cgp_outlier_mutant_cases
```

>"i_8228" "i_95FC" "i_BD58" "i_1C36" "i_502F" "i_D732" "i_6B06" "i_56B5"

*   Pick random 9/73 cases[^1] without outlier mutation profile.

```r
## nonhm_sampled <- sample(ncol(fit_res_nonhm$contribution),
    ncol(fit_res_hm$contribution), replace = FALSE)

## following cases were used in the right-side panel of fig 3A
nonhm_sampled <- c(28,48,30,57,54,40,37,7,62)
```

*  Deconvolute known human mutational signatures

>Fitted mutational signatures, i.e., `fit_res`, `fit_res_hm` and `fit_res_nonhm` were derived using `fit_to_signatures` function from *MutationalPatterns* R package[^2].

```
## mut_mat object is within /data/cgp_base_objects_v1.0.RData
## mut_mat <- MutationalPattern::mut_matrix(vcf_list = vcfs,
    ref_genome = ref_genome)

fit_res <- fit_to_signatures(mut_mat, cancer_signatures)

hypermutators <- c("i_8228", "i_95FC", "i_BD58", "i_1C36",
    "i_502F", "i_D732", "i_6B06", "i_56B5")

non_hypermutators <- colnames(mut_mat)[!colnames(mut_mat) %in% hypermutators]

## non-hypermutators or one without outlier mutation profile
fit_res_nonhm <- fit_to_signatures(mut_mat[, colnames(mut_mat) %in%
    non_hypermutators], cancer_signatures)

## hypermutators or one with outlier mutation profile
fit_res_hm <- fit_to_signatures(mut_mat[, colnames(mut_mat) %in%
    hypermutators], cancer_signatures)
```

*   Merge signatures by proposed mechanism

```r
hm_sigs <- hm_nonhm_topsigs_tbl %>% filter(sig_enrichment != "NON_HM") %>%
    pull(sig_id)

nonhm_sigs <- hm_nonhm_topsigs_tbl %>% filter(sig_enrichment != "HM") %>%
    pull(sig_id)

fit_res_hm_merged <- as_tibble(fit_res_hm$contribution[hm_sigs, ],
    rownames = "sig_id") %>%
    left_join(hm_nonhm_topsigs_tbl %>% dplyr::select(sig_id, sig_group)) %>%
    gather(patient_id, sig_score, starts_with("i_")) %>%
    group_by(sig_group, patient_id) %>%
    mutate(group_score = sum(sig_score)) %>%
    dplyr::select(sig_group, group_score, patient_id, sig_id) %>%
    spread(patient_id, group_score) %>%
    distinct(sig_group, .keep_all = TRUE) %>%
    ungroup() %>%
    dplyr::select(-sig_id) %>%
    column_to_rownames("sig_group")

fit_res_nonhm_merged <- as_tibble(fit_res_nonhm$contribution[nonhm_sigs, ],
    rownames = "sig_id") %>%
    left_join(hm_nonhm_topsigs_tbl %>% dplyr::select(sig_id, sig_group)) %>%
    gather(patient_id, sig_score, starts_with("i_")) %>%
    group_by(sig_group, patient_id) %>%
    mutate(group_score = sum(sig_score)) %>%
    dplyr::select(sig_group, group_score, patient_id, sig_id) %>%
    spread(patient_id, group_score) %>%
    distinct(sig_group, .keep_all = TRUE) %>%
    ungroup() %>%
    dplyr::select(-sig_id) %>%
    column_to_rownames("sig_group")

## group cancer signatures context proportion for HM

cancer_signatures_merged <- as_tibble(cancer_signatures,
    rownames = "context") %>%
    gather(sig_id, sig_score, -context) %>%
    left_join(hm_nonhm_topsigs_tbl %>% dplyr::select(sig_id, sig_group)) %>%
    filter(!is.na(sig_group)) %>%
    group_by(sig_group, context) %>%
    mutate(group_score = sum(sig_score)) %>%
    filter(!is.na(group_score)) %>%
    ungroup() %>%
    dplyr::select(sig_group, group_score, context, sig_id) %>%
    distinct(sig_group, context, group_score, .keep_all = FALSE) %>%
    spread(sig_group, group_score) %>%
    distinct(context, .keep_all = TRUE) %>%
    column_to_rownames("context")

hm_nonhm_sig_group_colours <- hm_nonhm_topsigs_tbl %>%
    distinct(sig_group, .keep_all = TRUE) %>%
    pull(colour_hex)

names(hm_nonhm_sig_group_colours) <- hm_nonhm_topsigs_tbl %>%
    distinct(sig_group, .keep_all = TRUE) %>%
    pull(sig_group)
```


*   Function to plot signature contribution

>Rewrite of `plot_contribution` function from *MutationalPatterns* R package.

```r
cgp_plot_contribution <- function (contribution,
    signatures, index = c(), coord_flip = FALSE,
    mode = "relative", palette = c())
    {
        if (!(mode == "relative" | mode == "absolute"))
          stop("mode parameter should be either 'relative' or 'absolute'")

        if (length(index > 0)) {
          contribution = contribution[, index]
        }
        
        Sample = NULL
        Contribution = NULL
        Signature = NULL
        
        if (mode == "relative") {
            m_contribution = data.table::melt(contribution, "sig_id")
            colnames(m_contribution) = c("Signature",
                "Sample", "Contribution")

            plot = ggplot(m_contribution, aes(x = factor(Sample),
              y = Contribution, fill = factor(Signature), order = Sample)) +
              geom_bar(position = "fill", stat = "identity",
                colour = "black") +
              labs(x = "", y = "Relative contribution") + theme_bw() +
              theme(panel.grid.minor.x = element_blank(),
                panel.grid.major.x = element_blank()) +
              theme(panel.grid.minor.y = element_blank(),
                panel.grid.major.y = element_blank())
        } else {
            if (missing(signatures))
              stop(paste("For contribution plotting in mode 'absolute':",
                  "also provide signatures matrix"))

            total_signatures = colSums(signatures)
            abs_contribution = contribution[,-1] * total_signatures
            rownames(abs_contribution) = contribution %>%
                pull(sig_id)

            m_contribution = data.table::melt(abs_contribution, "sig_id")
            colnames(m_contribution) = c("Signature",
                "Sample", "Contribution")

            plot = ggplot(m_contribution, aes(x = factor(Sample),
              y = Contribution, fill = factor(Signature), order = Sample)) +
              geom_bar(stat = "identity", colour = "black") +
              labs(x = "", y = "Absolute contribution \n (no. mutations)") +
              theme_bw() +
              theme(panel.grid.minor.x = element_blank(),
                panel.grid.major.x = element_blank()) +
              theme(panel.grid.minor.y = element_blank(),
                panel.grid.major.y = element_blank())
        }

        if (length(palette) > 0) {
            plot = plot +
                scale_fill_manual(name = "Signature", values = palette)
        } else {
            plot = plot +
                scale_fill_discrete(name = "Signature")
        }

        if (coord_flip) {
            plot = plot +
                coord_flip() +
                xlim(rev(levels(factor(m_contribution$Sample))))
        } else {
            plot = plot + xlim(levels(factor(m_contribution$Sample)))
        }

        return(plot)
    }
```

### Fig 3A

>Plot deconvoluted signature contribution after grouping signatures based on proposed mechanism.

```r
## plot canine glioma patients with outlier mutation profile

plotsig_hm_rel_merged <- cgp_plot_contribution(as_tibble(
    fit_res_hm_merged, rownames = "sig_id"),
    cancer_signatures_merged,
    coord_flip = FALSE,
    mode = "relative", palette = hm_nonhm_sig_group_colours) +
    theme_cowplot(font_size = 20) +
    theme(axis.text.x = element_blank(),
        legend.position = "bottom",
        legend.text = element_text(size = 14)) +
    labs(x = "Canine Gliomas with outlier mutation profile\n(n=8)") +
    guides(fill = guide_legend(
        title = "Known signatures grouped by\ntheir proposed mechanism",
    title.position = "bottom",
    label.theme = element_text(size = 14),
    keywidth=0.8,
    keyheight=0.8,
    default.unit="cm", nrow = 2,byrow=TRUE))

## plot randomly sampled 9 canine patients without outlier mutation profile

plotsig_nonhm_rel_sampled_merged <- cgp_plot_contribution(as_tibble(
    fit_res_nonhm_merged[ ,nonhm_sampled], rownames = "sig_id"),
    cancer_signatures_merged,
    coord_flip = FALSE,
    mode = "relative", palette = hm_nonhm_sig_group_colours) +
    theme_cowplot(font_size = 20) +
    theme(axis.text.x = element_blank(),
        legend.position = "bottom",
        legend.text = element_text(size = 14)) +
        labs(x = "Canine Gliomas with no outlier mutation profile\n(9/73)") +
    guides(fill = guide_legend(
        title = "Signatures grouped by\ntheir proposed mechanism",
    title.position = "bottom",
    label.theme = element_text(size = 14),
    keywidth=0.8,
    keyheight=0.8,
    default.unit="cm", nrow = 2,byrow=TRUE))

ggsave("F3A.pdf",
    grid.arrange(plotsig_hm_rel_merged,
                 plotsig_nonhm_rel_sampled_merged,
        ncol = 2, widths = c(5, 5)),
        width = 18,
        height = 12,
        useDingbats = FALSE)
```

### Suppl Fig 3A

>Plot absolute and relative contribution of dominant signatures.

```r
## Select signatures with major contribution > 3rd Qu (2.75)
summary(rowMedians(fit_res$contribution))

select_high <- rownames(fit_res$contribution)[
    which(rowMedians(fit_res$contribution) > 2.75)
    ]

select_high

color_lib <- c('#8e0152','#c51b7d','#de77ae','#f1b6da','#fde0ef',
  '#f7f7f7','#e6f5d0','#b8e186','#7fbc41','#4d9221',
  '#276419')

## Plot contribution
ggsave("SF3A_top_panel.pdf",
    plot_contribution(fit_res$contribution[select_high, ],
         cancer_signatures[ , select_high],
         coord_flip = FALSE,
         mode = "absolute",
         palette = color_lib) +
    theme(axis.text.x = element_text(angle = 90)),
    width = 9,
    height = 5,
    useDingbats = FALSE)

ggsave("SF3A_bottom_panel.pdf",
    plot_contribution(fit_res$contribution[select_high, ],
        cancer_signatures[ , select_high],
        coord_flip = FALSE,
        mode = "relative",
        palette = color_lib) +
    theme(axis.text.x = element_text(angle = 90)),
    width = 9,
    height = 5,
    useDingbats = FALSE)
```

### Suppl Fig 3B

>Boxplot comparison of genomic instability related signatures between canine glioma patients separated by outlier mutation profile.

```r
suppl_fig_3B <- ggpubr::ggboxplot(instability_sigs_df,
        x = "hypermut", y = "sig_contrib",
        add = "jitter",
        facet.by = "sig_group",
        scales = "free_y",
        bxp.errorbar = TRUE, notch = TRUE,
        font.label = list(size = 7, color = "black"),
        ylab = "Signature contribution",
        xlab = "Canine Gliomas separated by\noutlier mutation profile") +
    theme(axis.text = element_text(size = 11),
        axis.title = element_text(size = 11)) +
    ggpubr::stat_compare_means(method = "wilcox.test",
    label.y.npc = 0.9, na.rm = TRUE)

ggsave("SF3B.pdf",
       suppl_fig_3B,
       width=12,
       height=8,
       useDingbats = FALSE)
```

[^1]: Earlier version of `fit_res_hm` had 9 and not 8 canine glioma patients with outlier mutation profile. Therefore, 9 cases were selected at random from remaining patients without outlier mutation profile.
[^2]: Blokzijl F, Janssen R, van Boxtel R, Cuppen E. MutationalPatterns: comprehensive genome-wide analysis of mutational processes. Genome Med 2018;10:33. doi: [10.1186/s13073-018-0539-0](https://doi.org/10.1186/s13073-018-0539-0).

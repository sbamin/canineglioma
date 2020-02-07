---
title: F3B &middot; Somatic Mutational Landscape - de novo
---

### Fig 3B, Suppl Fig 3D

>Compare de-novo mutational signatures in canine and human pediatric and adult glioma with deconvoluted ones from Human Cancers (n=42).

*   For each of three cohorts (canine, human pediatric and adult glioma), de-novo signatures were constructed as follows:

```r
nmf_res <- MutationalPatterns::extract_signatures(mut_mat, rank = 3,
    nrun = 100)
denovo_cg_sig <- as.data.frame(t(nmf_res$signatures))
```

*   Resulting de-novo signatures from three cohorts were then merged into a single dataframe.

```r
## merged_ag_pg_cg_denovo_sig is already given in cgp_base_objects_*.RData 
merged_ag_pg_cg_denovo_sig <- as_tibble(ag_denovo_sig, rownames = "sigs") %>%
    bind_rows(as_tibble(pg_denovo_sig, rownames = "sigs")) %>%
    bind_rows(as_tibble(transposed_denovo_cg_sig, rownames = "sigs")) %>%
    column_to_rownames("sigs")
```

*   Calculate cosine similarity using `deconvolution_compare` function in [*Palimpsest*](https://github.com/FunGeST/Palimpsest) R package[^1]. Author of Palimpsest package has provided [a detailed documentation](https://github.com/FunGeST/Palimpsest/raw/master/Files/vignette_palimpsest_2.0.pdf) on how to run Palimpsest workflow.

```r
## Deconvoluted signatures from human cancers
alt_cancer_sig_transposed <- as.data.frame(t(cancer_signatures))

## rename trinucleotide context pattern to match in de-novo dataframe
colnames(alt_cancer_sig_transposed) <- 
    gsub("([AGCT]{1})(\\[)([AGCT]{1})(\\>)([AGCT]{1})(\\])([AGCT]{1})",
        "\\3\\5_\\1.\\7", perl = TRUE,
        colnames(alt_cancer_sig_transposed))

## calculate cosine similarity
pdf("tmp_SF3D.pdf",
    width = 18, height = 12, pointsize = 12,
    bg = "white",
    compress = FALSE, useDingbats = FALSE)

cos_sim_denovo_cancer_sig_ag_pg_cg <- Palimpsest::deconvolution_compare(
    merged_ag_pg_cg_denovo_sig,
    alt_cancer_sig_transposed)

dev.off()

## Plot Suppl Fig 3D
## Fig3B is a cropped version of Suppl Fig 3D
pheatmap::pheatmap(cos_sim_denovo_cancer_sig_ag_pg_cg,
  filename = "SF3D.pdf",
  width = 12, height = 12,
  useDingbats = FALSE)
```

[^1]: Shinde J, Bayard Q, Imbeaud S, Hirsch TZ, Liu F, Renault V, et al. Palimpsest: an R package for studying mutational and structural variant signatures along clonal evolution in cancer. Bioinformatics 2018. doi: [10.1093/bioinformatics/bty388](https://doi.org/10.1093/bioinformatics/bty388).

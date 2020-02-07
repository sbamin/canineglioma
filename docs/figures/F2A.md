---
title: F2A &middot; Somatic Copy Number Landscape
---

### Fig 2A

>Somatic copy-number aberrations (SCNA) lanscape of glioma driver genes. Please run required code from [Fig 1A](/figures/F1A/) prior to running code from this page.

```r
pdf("F2A.pdf",
    width = 16, height = 12, pointsize = 14, useDingbats = FALSE)

mafplot_2_scna <- oncoplot(maf = cgp_maftools_gistic_matched,
    genes = oncoprint_genes_gistic,
    additionalFeature = c("dnds_mutsig", "Driver"),
    removeNonMutated = TRUE,
    keepGeneOrder = FALSE,
    writeMatrix = FALSE,
    sortByMutation = FALSE,
    fontSize = 1.6,
    legendFontSize = 2,
    annotationFontSize = 1.6,
    clinicalFeatures = c("Tumor_Morphology", "Tumor_Grade",
                        "Tumor_Location"),
    annotationColor = ann_colors,
    colors = varcall_colors[
    c(levels(cgp_maftools_gistic_matched@data$Variant_Classification),
    "Multi_Hit")
    ],
    logColBar = FALSE,
    gene_mar = 10,
    bgCol = "#ffffff",
    borderCol = "#CCCCCC")

dev.off()
```

>Somatic copy numbers were classified as follows based on GISTIC2 values.

| GISTIC2 value | Estimated copy number | Classification |
|---|---|---|
| $< -1.29$ | -2 | Deep deletion |
| $-1.29 <> -.65$ | -1 | Loss of Heterozygosity (LOH) |
| $-.65 <> 2.0$ | 0-1 | Copy-neutral or low-level amplification |
| $>2.0$ | 2 | High-level amplification |

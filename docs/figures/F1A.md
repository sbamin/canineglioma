---
title: F1A &middot; Somatic Mutational Landscape
---

### Required metadata

*   Genes to plot

>Based on [significantly mutated genes analysis](/methods/S06_smgs). See also Table S2.

```r
oncoprint_genes <- c("PDGFRA", "PIK3CA", "NF1", "TP53", "EGFR", "IDH1",
    "FGFR1", "SPOP", "TRIM11", "SMARCC2", "SMARCA4", "SMARCAD1", "ARID5B",
    "KMT2A", "KMT2D", "RB1", "CDKN2C")

oncoprint_genes_gistic <- c("PDGFRA", "MYC", "TP53", "EGFR", "RB1", "PTEN",
    "CDKN2A")

oncoprint_genes_snv_scna <- c("PDGFRA", "PIK3CA", "NF1", "TP53", "ZFHX3",
    "EGFR", "IDH1", "FGFR1", "SPOP", "TRIM11", "SMARCC2",
    "SMARCA4", "SMARCAD1", "ARID5B",
    "KMT2A", "KMT2C", "KMT2D",
    "RB1", "PTEN", "CDKN2A")
```

*   Sample and Variant Annotations 

```r
## Specify colors for sample annotations
ann_colors <- list(Tumor_Morphology = c(Astro = "#d95f02",
    Oligo = "#7570b3", Undefined = "#1b9e77"),
    Tumor_Grade = c(High = "#FEB24C", Low = "#FFEDA0"),
    Tumor_Location = c(Hemispheric = "#a6cee3",
    Cerebellar = "#1f78b4",
    midline = "#e31a1c", UN = "#fb9a99"),
    Tissue_Archival = c(`snap-frozen` = "#ffcc33", ffpe = "#cc0033"),
    Matched_Normal = c(paired = "#ffcc33", tumor_only = "#cc0033"))

## specify colors for variant types
varcall_colors <- c(Amp = "#006400",
    LOH = "#FF9999",
    Del = "#9933FF",
    Frame_Shift_Del = "#1E90FF",
    Frame_Shift_Ins = "#FF8C69",
    Splice_Site = "#00CED1",
    Splice_Region = "#00CED1",
    Translation_Start_Site = "#CD6600",
    Nonsense_Mutation = "#FFC100",
    Nonstop_Mutation = "#E7B98A",
    In_Frame_Del = "#E78A96",
    In_Frame_Ins = "#FFC1C9",
    Missense_Mutation = "#CD6600",
    Translation_Start_Site = "#008B8B",
    Multi_Hit = "#3D3D3D"
```

### Fig 1A

>Somatic mutational lanscape of glioma driver genes. Based on [significantly mutated genes analysis](/methods/S06_smgs).

```r
pdf("F1A.pdf",
    width = 18, height = 12, pointsize = 12,
    fonts = "Arial", bg = "white",
    compress = FALSE, useDingbats = FALSE)

fig_1A <- oncoplot(maf = maf_nogistic,
    genes = oncoprint_genes,
    additionalFeature = c("dnds_mutsig", "Driver"),
    removeNonMutated = TRUE,
    keepGeneOrder = FALSE,
    writeMatrix = FALSE,
    sortByMutation = FALSE,
    fontSize = 0.9,
    legendFontSize = 1.8,
    annotationFontSize = 1.8,
    clinicalFeatures = c("Tumor_Morphology", "Tumor_Grade",
                       "Tumor_Location"),
    annotationColor = ann_colors,
    colors = varcall_colors[
        c(levels(maf_nogistic@data$Variant_Classification),
        "Multi_Hit")
    ],
    logColBar = FALSE,
    gene_mar = 8,
    bgCol = "#ffffff",
    borderCol = "#CCCCCC")

dev.off()
```

### Suppl Fig 1B

>Somatic mutational lanscape of COSMIC cancer genes.

```r
pdf("SF1B.pdf",
    width = 18, height = 12, pointsize = 12,
    fonts = "Arial", bg = "white",
    compress = FALSE, useDingbats = FALSE)

suppl_fig_1B <- oncoplot(maf = maf_nogistic,
     genes = cancer_genes_maftools,
     additionalFeature = c("dnds_mutsig", "Driver"),
     removeNonMutated = FALSE,
     keepGeneOrder = FALSE,
     writeMatrix = FALSE,
     sortByMutation = TRUE,
     fontSize = 0.7,
     legendFontSize = 1.2,
     annotationFontSize = 1.2,
     clinicalFeatures = c("Tumor_Morphology", "Tumor_Grade",
                          "Tumor_Location"),
     annotationColor = ann_colors,
     colors = varcall_colors[
        c(levels(maf_nogistic@data$Variant_Classification),
        "Multi_Hit")
        ],
     logColBar = FALSE,
     gene_mar = 7,
     bgCol = "#ffffff",
     borderCol = "#CCCCCC")

dev.off()
```

### Suppl Fig 1F

>Somatic mutational lanscape, including copy-number aberrations of COSMIC cancer genes. This figure also contains somatic copy-number data which is detailed under [Fig 2A](/figures/F2A/).

```r
pdf("SF1F.pdf",
    width = 18, height = 12, pointsize = 12,
    fonts = "Arial", bg = "white",
    compress = FALSE, useDingbats = FALSE)

suppl_fig_1F <- oncoplot(maf = cgp_maftools_gistic_n81,
    ## adding known SCNA drivers
    genes = c(cancer_genes_maftools, "CDKN2A", "PTEN"),
    additionalFeature = c("dnds_mutsig", "Driver"),
    removeNonMutated = FALSE,
    keepGeneOrder = FALSE,
    writeMatrix = TRUE,
    sortByMutation = TRUE,
    fontSize = 0.7,
    legendFontSize = 1.2,
    annotationFontSize = 1.2,
    clinicalFeatures = c("Tumor_Morphology", "Tumor_Grade",
                       "Tumor_Location", "Tissue_Archival", 
                       "Matched_Normal"),
    annotationColor = ann_colors,
    colors = varcall_colors[
    c(levels(cgp_maftools_custom_scna_n81@data$Variant_Classification), 
    "Multi_Hit")
    ],
    logColBar = FALSE,
    gene_mar = 7,
    bgCol = "#ffffff",
    borderCol = "#CCCCCC")

dev.off()
```

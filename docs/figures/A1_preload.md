---
title: Preload &middot; RData
---

### R env

```r
sessionInfo()
```

>R libraries are listed in respective figure sections. Software versions for core R libraries are listed in the manuscript under STAR methods `=>` Key Resources Table.

```r
R version 3.6.1 (2019-07-05)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: CentOS Linux 7 (Core)

Matrix products: default
BLAS/LAPACK: /home/foo/anaconda3/lib/libopenblasp-r0.3.6.so

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8   
 [6] LC_MESSAGES=en_US.UTF-8    LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C               LC_TELEPHONE=C            
[11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C  
```

### Load R objects

Download [/data/cgp_base_objects_v1.0.RData](/data/cgp_base_objects_v1.0.RData)

```r
load("cgp_base_objects_v1.RData")
ls()
```

| R object | Description |
|---|---|
| cgp_suppl_sample_info_master | Donor level information on 81 canine patients with glioma. |
| maf_nogistic | maftools compatible MAF object, does not contain copy number data on 81 canine patients. Note that three patients had no detectable somatic mutations following somatic mutation filtration. |
| cgp_maftools_gistic_matched | maftools compatible MAF object **only** on 67 canine patients with paired tumor-normal samples where somatic copy number data was available. |
| cgp_maftools_gistic_n81 | maftools compatible MAF object of 81 canine patients. This object **also** contain copy number data on 67 of 81 canine patients where paired tumor-normal samples were available. |
| cgp_maftools_gistic_methy | maftools compatible MAF object of 42 canine patients where DNA methylation data was available. |
| cancer_genes_maftools | Cancer genes with observed somatic mutation in canine patients (n=48). Based on cancer hallmark analysis (Fig 1B).
| mutrate_table | Somatic mutation burden across patients of canine and human pediatric and adult cancers (n=4,840). |
| merged_anp_scores | Comparative aneuploidy metrics showing fraction of genome with aneuploidy |
| cgp_aneuploidy_metrics_master | aneuploidy metrics for 67 canine glioma patients. |
| mat_aneuploidy_summary_mostvar_cgAll | Comparative shared syntenic aneuploidy across canine and human pediatric and adult glioma. |
| updated_merged_entropy_df_ridges | Shannon entropy across canine and human pediatric and adult glioma where whole-genome sequence data was available (n=105). |
| merged_ccf_vaf_df | Comparative intra-tumor heterogeneity (Shannon entropy) and cellular prevalence matrix. |



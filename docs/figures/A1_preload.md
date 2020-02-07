---
title: Start Here &middot; Canine Glioma
---

### Raw sequence data

Sequencing data generated from canine patients with glioma (n=83 donors) is available in the Binary Alignment Map (BAM) format (n=373) at the NCBI SRA database under BioProject ID: [PRJNA579792](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA579792).

[View details](/methods/S02_data_sources/) on comparative sequencing data used from patients of human pediatric and glioma.

### R session

- [x] Prefer using RStudio or similar GUI over copy-pasting code in terminal. The latter may emit errors due to issues with syntax highlighting and font ligatures used on this website.
- [x] Code on this website was evaluated in an isolated, new environment and syntax-related errors were addressed on the top of respective code blocks. Please [report bugs](https://github.com/TheJacksonLaboratory/canineglioma/issues) by submitting a GitHub issue. 

 
```r
sessionInfo()
```

>Package versions may have updated versions here than what was used at the time of publication. Versions for core R packages that were used in the manuscript are listed in the manuscript under STAR methods `=>` Key Resources Table.

```
R version 3.6.1 (2019-07-05)
Platform: x86_64-conda_cos6-linux-gnu (64-bit)
Running under: CentOS release 6.5 (Final)

Matrix products: default
BLAS/LAPACK: /home/foo/anaconda3/lib/libopenblasp-r0.3.6.so

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
 [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
 [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
 [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
 [9] LC_ADDRESS=C               LC_TELEPHONE=C            
[11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       

attached base packages:
[1] stats4    parallel  stats     graphics  grDevices utils     datasets 
[8] methods   base     

other attached packages:
 [1] GenomicFeatures_1.36.4    AnnotationDbi_1.46.0     
 [3] MutationalPatterns_1.10.0 rtracklayer_1.44.0       
 [5] cowplot_1.0.0             ggrepel_0.8.1            
 [7] ggforce_0.3.1             gridExtra_2.3            
 [9] forcats_0.4.0             stringr_1.4.0            
[11] dplyr_0.8.3               purrr_0.3.3              
[13] readr_1.3.1               tidyr_1.0.2              
[15] tibble_2.1.3              ggplot2_3.2.1            
[17] tidyverse_1.2.1           Palimpsest_1.0.0         
[19] GenomicRanges_1.36.0      GenomeInfoDb_1.20.0      
[21] IRanges_2.18.1            S4Vectors_0.22.0         
[23] NMF_0.21.0                Biobase_2.44.0           
[25] BiocGenerics_0.30.0       cluster_2.1.0            
[27] rngtools_1.4              pkgmaker_0.27            
[29] registry_0.5-1            extrafont_0.17          

loaded via a namespace (and not attached):
  [1] colorspace_1.4-1            ggsignif_0.5.0             
  [3] ellipsis_0.3.0              rprojroot_1.3-2            
  [5] IRdisplay_0.7.0             lsa_0.73.1                 
  [7] XVector_0.24.0              ggdendro_0.1-20            
  [9] base64enc_0.1-3             rstudioapi_0.10            
 [11] ggpubr_0.2.1.999            farver_1.1.0               
 [13] SnowballC_0.6.0             bit64_0.9-7                
 [15] fansi_0.4.0                 lubridate_1.7.4            
 [17] xml2_1.2.2                  codetools_0.2-16           
 [19] doParallel_1.0.14           polyclip_1.10-0            
 [21] IRkernel_1.0.2              jsonlite_1.6               
 [23] Rsamtools_2.0.0             broom_0.5.4                
 [25] gridBase_0.4-7              graph_1.62.0               
 [27] compiler_3.6.1              httr_1.4.1                 
 [29] backports_1.1.5             assertthat_0.2.1           
 [31] Matrix_1.2-17               lazyeval_0.2.2             
 [33] cli_2.0.1                   tweenr_1.0.1               
 [35] htmltools_0.3.6             prettyunits_1.0.2          
 [37] tools_3.6.1                 gtable_0.3.0               
 [39] glue_1.3.1                  GenomeInfoDbData_1.2.1     
 [41] reshape2_1.4.3              Rcpp_1.0.3                 
 [43] cellranger_1.1.0            vctrs_0.2.2                
 [45] Biostrings_2.52.0           gdata_2.18.0               
 [47] nlme_3.1-140                iterators_1.0.10           
 [49] rvest_0.3.5                 lifecycle_0.1.0            
 [51] gtools_3.8.1                XML_3.98-1.20              
 [53] MASS_7.3-51.4               zlibbioc_1.30.0            
 [55] RCircos_1.2.1               scales_1.0.0               
 [57] BSgenome_1.52.0             VariantAnnotation_1.30.1   
 [59] hms_0.5.3                   SummarizedExperiment_1.14.0
 [61] RColorBrewer_1.1-2          memoise_1.1.0              
 [63] biomaRt_2.40.1              stringi_1.4.3              
 [65] RSQLite_2.1.1               foreach_1.4.4              
 [67] plotrix_3.7-6               caTools_1.17.1.2           
 [69] BiocParallel_1.18.0         bibtex_0.4.2               
 [71] repr_1.0.1                  rlang_0.4.3                
 [73] pkgconfig_2.0.3             matrixStats_0.54.0         
 [75] bitops_1.0-6                pracma_2.2.5               
 [77] evaluate_0.14               lattice_0.20-38            
 [79] labeling_0.3                GenomicAlignments_1.20.1   
 [81] bit_1.1-14                  tidyselect_0.2.5           
 [83] here_0.1                    plyr_1.8.4                 
 [85] magrittr_1.5                R6_2.4.1                   
 [87] gplots_3.0.1.1              generics_0.0.2             
 [89] pbdZMQ_0.3-3                DelayedArray_0.10.0        
 [91] DBI_1.1.0                   pillar_1.4.3               
 [93] haven_2.2.0                 withr_2.1.2                
 [95] RCurl_1.95-4.12             modelr_0.1.5               
 [97] crayon_1.3.4                uuid_0.1-2                 
 [99] KernSmooth_2.23-15          progress_1.2.2             
[101] grid_3.6.1                  readxl_1.3.1               
[103] data.table_1.12.2           blob_1.2.0                 
[105] Rgraphviz_2.28.0            digest_0.6.23              
[107] xtable_1.8-4                munsell_0.5.0              
```

### Load R packages

>PS: Not all of R packages were loaded for generating all figures. If you are loading all of packages, be aware of warnings related to masked functions and use pacakge name prefix, e.g., `dplyr::select` to explicitly call a function.

```r
## For Figure 1 and 2, including supplemental figures
library(knitr)
library(htmlTable)

library(tidyverse)
library(broom)

library(maftools)
library(tint)

library(DBI)

library(ggplot2)
library(gridExtra)
library(ggforce)
library(ggrepel)
library(cowplot)

## For Figure 3, including supplemental figures,
## load these extra packages.

library(Palimpsest)
library(BSgenome.Cfamiliaris.UCSC.canFam3)
library(rtracklayer)
library(MutationalPatterns)
library(tidyverse)
library(GenomicFeatures)
library(NMF)
library(BradleyTerryScalable)

## Import Arial fonts
library(extrafont)
loadfonts()
```

### Load R objects

:rocket: Download [/data/cgp_base_objects_v1_20200207.RData](/data/cgp_base_objects_v1_20200207.RData) ==Link will be active on Feb 10, 2020.==

```r
load("cgp_base_objects_v1_20200207.RData")
ls()
## 37 objects
```

| R object | Description |
|---|---|
| cgp_suppl_sample_info_master | Donor level information on 81 canine patients with glioma. |
| maf_nogistic | maftools compatible MAF object, does not contain copy number data on 81 canine patients. Note that three patients had no detectable somatic mutations following somatic mutation filtration. |
| cgp_maftools_gistic_matched | maftools compatible MAF object **only** on 67 canine patients with paired tumor-normal samples where somatic copy number data was available. |
| cgp_maftools_gistic_n81 | maftools compatible MAF object of 81 canine patients. This object **also** contain copy number data on 67 of 81 canine patients where paired tumor-normal samples were available. |
| cgp_maftools_gistic_methy | maftools compatible MAF object of 42 canine patients where DNA methylation data was available. |
| cancer_genes_maftools | Cancer genes with observed somatic mutation in canine patients (n=48). Based on cancer hallmark analysis (Fig 1B). |
| HALLMARK | Genes (n=277) to Cancer Hallmarks (n=11) mapping |
| CG_all | Somatic variants in canine glioma cohort (n=62/81 cases) |
| ALL_HALLMARK_v1 | Cancer Hallmark table for Figure 1C |
| mutrate_table | Somatic mutation burden across patients of canine and human pediatric and adult cancers (n=4,840). |
| merged_anp_scores | Comparative aneuploidy metrics showing fraction of genome with aneuploidy |
| cgp_aneuploidy_metrics_master | aneuploidy metrics for 67 canine glioma patients. |
| mat_aneuploidy_summary_mostvar_cgAll | Comparative shared syntenic aneuploidy across canine and human pediatric and adult glioma. |
| updated_merged_entropy_df_ridges | Shannon entropy across canine and human pediatric and adult glioma where whole-genome sequence data was available (n=105). |
| merged_ccf_vaf_df | Comparative intra-tumor heterogeneity (Shannon entropy) and cellular prevalence matrix. |
| mut_mat | Canine glioma mutational matrix based on 96-trinucleotide context - Derived using `mut_matrix` function in *MutationalPatterns* R package. |
| cancer_signatures | Known human mutational signatures in adult (n=30, COSMIC v2) and pediatric cancers (n=12). |
| fit_res_hm | Somatic mutational signatures in canine glioma patients with outlier mutation profile (n=8). Signatures were fitted to known human mutational signatures. |
| fit_res_nonhm | Somatic mutational signatures in canine glioma patients without outlier mutation profile (n=73). Signatures were fitted to known human mutational signatures. |
| hm_nonhm_topsigs_tbl, driver_sigs_groups | Mutational signatures and their grouping to proposed mechnaism |
| instability_sigs_df | subset of `fit_res$contribution` matrix for suppl fig 3B. |
| merged_ag_pg_cg_denovo_sig | De-novo mutational signatures from canine, human pediatric and adult cohort. |
| trimmed_{cg,pg,ag}_vcf | Trimmed VCFs for plotting Figure 3C |
| win_table_{cg,pg,ag}_vcf | Trimmed VCFs for plotting Figure 3D |
| cgp_RRBS.noNormals_class_prediction | class prediction table for Figure 4 |
| cgp_RRBS.noNormals_sample_info | Donor level information for 45 canine patients with glioma where DNA methylation data was available. |
| {cgp, tcga}_info | Sample metadata for suppl figure 5. |
| {cgp, ped, tcga}_cibersort | CIBERSORT output for three cohorts. |
| fig5b_dat | Data related to IHC panel, Figure 5B. |

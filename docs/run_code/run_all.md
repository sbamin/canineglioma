---
title: "cgp_figures"
author: "sbamin"
date: "2/8/2020"
output:
  html_document:
    code_folding: hide
    df_print: paged
    fig_caption: yes
    fig_height: 18
    fig_width: 12
    highlight: textmate
    keep_md: yes
    number_sections: yes
    theme: default
    toc: yes
    toc_depth: 4
    toc_float: yes
  pdf_document:
    toc: yes
    toc_depth: '4'
---

## Comparative molecular life history of spontaneous canine and human gliomas

>Amin et al., Comparative Molecular Life History of Spontaneous Canine and Human Gliomas, *Cancer Cell* (2020). DOI: [10.1016/j.ccell.2020.01.004](https://doi.org/10.1016/j.ccell.2020.01.004) Feb 10, 2020.

## Set Env


```r
library(knitr)
opts_chunk$set(comment = NA, fig.width = 18, fig.height = 12, 
               message = TRUE, cache = FALSE, echo = FALSE)
```

### Load R packages


```
Warning: replacing previous import 'NMF::entropy' by 'lsa::entropy' when loading
'Palimpsest'
```

```
Warning: replacing previous import 'NMF::dispersion' by 'plotrix::dispersion'
when loading 'Palimpsest'
```

```
Warning: replacing previous import 'gplots::plotCI' by 'plotrix::plotCI' when
loading 'Palimpsest'
```

### Load R objects


```
Work directory is /Users/samin1/Dropbox (Personal)/acad/scripts/HOURGLASS/cgp_keystone/canineglioma/docs/run_code
Loading base objects...
```

```
List objects
```

```
 [1] "ALL_HALLMARK_v1"                     
 [2] "cancer_genes_maftools"               
 [3] "cancer_signatures"                   
 [4] "CG_all"                              
 [5] "cgp_aneuploidy_metrics_master"       
 [6] "cgp_cibersort"                       
 [7] "cgp_info"                            
 [8] "cgp_maftools_gistic_matched"         
 [9] "cgp_maftools_gistic_methy"           
[10] "cgp_maftools_gistic_n81"             
[11] "cgp_RRBS.noNormals_class_prediction" 
[12] "cgp_RRBS.noNormals_sample_info"      
[13] "cgp_suppl_sample_info_master"        
[14] "driver_sigs_groups"                  
[15] "fig5b_dat"                           
[16] "fit_res_hm"                          
[17] "fit_res_nonhm"                       
[18] "HALLMARK"                            
[19] "hm_nonhm_topsigs_tbl"                
[20] "instability_sigs_df"                 
[21] "maf_nogistic"                        
[22] "mat_aneuploidy_summary_mostvar_cgAll"
[23] "merged_ag_pg_cg_denovo_sig"          
[24] "merged_anp_scores"                   
[25] "merged_ccf_vaf_df"                   
[26] "mut_mat"                             
[27] "mutrate_table"                       
[28] "ped_cibersort"                       
[29] "tcga_cibersort"                      
[30] "tcga_info"                           
[31] "trimmed_ag_vcf"                      
[32] "trimmed_cg_vcf"                      
[33] "trimmed_pg_vcf"                      
[34] "updated_merged_entropy_df_ridges"    
[35] "win_table_ag_vcf"                    
[36] "win_table_cg_vcf"                    
[37] "win_table_pg_vcf"                    
```

***

## Fig 1A

### Required metadata

*   Genes to plot

>Based on [significantly mutated genes analysis](/methods/S06_smgs). See also Table S2.



*   Sample and Variant Annotations 



### Plot Fig 1A

>Somatic mutational lanscape of glioma driver genes. Based on [significantly mutated genes analysis](/methods/S06_smgs).

??? error "font family 'Arial' not found"
    If you get an error, `font family 'Arial' not found in PostScript font database`, either remove *fonts* argument from `pdf` or import system fonts using *extrafont* R package. See [documentation by Gavin Simpson](https://www.fromthebottomoftheheap.net/2013/09/09/preparing-figures-for-plos-one-with-r/) for details. Run `extrafont::loadfonts()` as detailed in [Start Here](/figures/a1_preload/#load-r-packages).


```
quartz_off_screen 
                2 
```

### Suppl Fig 1B

>Somatic mutational lanscape of COSMIC cancer genes.


```
quartz_off_screen 
                2 
```

### Suppl Fig 1F

>Somatic mutational lanscape, including copy-number aberrations of COSMIC cancer genes. This figure also contains somatic copy-number data which is detailed under [Fig 2A](/figures/F2A/).


```
quartz_off_screen 
                2 
```

***

## Fig 1B

*   Alternate code using `lollipopPlot` function in R package, [*maftools*](https://bioconductor.org/packages/release/bioc/html/maftools.html)


```
    pos   conv count Variant_Classification
1:   88   R88Q     1      Missense_Mutation
2:  542  E542K     1      Missense_Mutation
3:  545  E545K     1      Missense_Mutation
4: 1047 H1047R     7      Missense_Mutation
5: 1047 H1047L     1      Missense_Mutation
```

```
   pos  conv count Variant_Classification
1: 132 R132C     3      Missense_Mutation
```

```
6 transcripts available. Use arguments refSeqID or proteinID to manually specify tx name.
```

```
   HGNC    refseq.ID   protein.ID aa.length
1: SPOP NM_001007227 NP_001007228       374
2: SPOP NM_001007228 NP_001007229       374
3: SPOP NM_001007229 NP_001007230       374
4: SPOP NM_001007230 NP_001007231       374
5: SPOP NM_001007226 NP_001007227       374
6: SPOP    NM_003563    NP_003554       374
```

```
Using longer transcript NM_001007227 for now.
```

```
   pos conv count Variant_Classification
1:  94 P94R     2      Missense_Mutation
```

```
quartz_off_screen 
                2 
```

***

## Fig 1C

Cancer Hallmarks enrichment across canine, human pediatric and adult gliomas. 
>Genes to hallmark mapping  was primarily derived from SLAPenrich R package. See also [relevant methods](/methods/S07_hallmarks/) for details.


```
Joining, by = "hallmark"
```

```
Warning: Column `hallmark` joining character vector and factor, coercing into
character vector
```

*   Similar to `CG_HALLMARK`, enrichment per hallmark tables were created for molecular subtypes across human cancers, and merged in the master table, `ALL_HALLMARK_v1`.



### Fig 1C

>Subset of hallmarks as a main figure 1C.


```
quartz_off_screen 
                2 
```

### Suppl Fig 1C

>Visualize all hallmarks.


```
quartz_off_screen 
                2 
```

***

## Fig 1D

>Plot CNS tumors.



### Suppl Fig 1D

>Plot pancancer tumors

??? error "unexpected `,` error"
    Running code by copy-paste may result in error related to R syntax, e.g., `Error: unexpected ',' in "`. If so, try to copy code first in text editor or RStudio app with lint feature. Please [report bugs](https://github.com/TheJacksonLaboratory/canineglioma/issues) by submitting a GitHub issue.



### Suppl Fig 1E

>Comparing mutational burden across molecular subtypes.


```
Warning in if (fill %in% names(data) & is.null(add.params$fill)) add.params$fill
<- fill: the condition has length > 1 and only the first element will be used
```

***

## F2A

>Somatic copy-number aberrations (SCNA) lanscape of glioma driver genes. Please run required code from [Fig 1A](/figures/F1A/) prior to running code from this page.


```
quartz_off_screen 
                2 
```

>Somatic copy numbers were classified as follows based on GISTIC2 values.

| GISTIC2 value | Estimated copy number | Classification |
|---|---|---|
| $< -1.29$ | -2 | Deep deletion |
| $-1.29 <> -.65$ | -1 | Loss of Heterozygosity (LOH) |
| $-.65 <> 2.0$ | 0-1 | Copy-neutral or low-level amplification |
| $>2.0$ | 2 | High-level amplification |

***

## Fig 2B

>Comparative aneuploidy burden. Related code is available at the GLASS consortium [marker paper code repository](https://github.com/TheJacksonLaboratory/GLASS/tree/master/sql/cnv), namely, `recapseg_postgres.sql` and `taylor_aneuploidy.sql`.


```
Warning in if (fill %in% names(data) & is.null(add.params$fill)) add.params$fill
<- fill: the condition has length > 1 and only the first element will be used
```

```
notch went outside hinges. Try setting notch=FALSE.
notch went outside hinges. Try setting notch=FALSE.
```

### Suppl Fig 2E

>Aneuploidy vs. somatic mutation burden.



***

## Fig 2C

`mat_aneuploidy_summary_mostvar_cgAll` matrix contains proportion of patients per cohort with arm-level aneuploidy, and was based on [arm-level aneuploidy metrics](/methods/S11_aneuploidy/). Related code is available at the GLASS consortium [marker paper code repository](https://github.com/TheJacksonLaboratory/GLASS/tree/master/sql/cnv), namely, `recapseg_postgres.sql` and `taylor_aneuploidy.sql`.



***

## Fig 2D

>Clonality of potential driver genes with respect to intra-tumor heterogeneity as measured with Shannon entropy.

??? error "Error: unexpected symbol in...`who_subtype`..."
    Prefer runnning code in RStudio. This error does not appear when running code in RStudio but pops up when running on command-line R. Likely due to font ligatures and/or use of of line breaks.



### Suppl Fig 2D

>Comparative intra-tumor heterogeneity measured using Shannon entropy.


```
Warning in if (fill %in% names(data) & is.null(add.params$fill)) add.params$fill
<- fill: the condition has length > 1 and only the first element will be used
```

***

## Fig 3A

### Required metadata

*   Canine glioma patients with [outlier mutation profile](/methods/S13_mut_sigs/).


```

Call:
lm(formula = adusted_coding_mutrate ~ Matched_Normal + Tissue_Archival, 
    data = cgp_sample_info_maftools_hypermuts)

Residuals:
    Min      1Q  Median      3Q     Max 
-1.4620 -0.2753 -0.1240  0.1106  6.0669 

Coefficients:
                           Estimate Std. Error t value Pr(>|t|)    
(Intercept)                 0.36934    0.14806   2.495   0.0148 *  
Matched_Normaltumor_only    1.49685    0.24842   6.025 5.62e-08 ***
Tissue_Archivalsnap-frozen  0.05463    0.19010   0.287   0.7746    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.8392 on 76 degrees of freedom
Multiple R-squared:  0.3238,	Adjusted R-squared:  0.306 
F-statistic:  18.2 on 2 and 76 DF,  p-value: 3.492e-07
```

```
[1] "hypermut case: i_8228" "hypermut case: i_95FC"
```

```
[1] "outlier among non_hypermut: i_BD58" "outlier among non_hypermut: i_1C36"
[3] "outlier among non_hypermut: i_502F" "outlier among non_hypermut: i_D732"
[5] "outlier among non_hypermut: i_6B06" "outlier among non_hypermut: i_56B5"
```

```
[1] "i_8228" "i_95FC" "i_BD58" "i_1C36" "i_502F" "i_D732" "i_6B06" "i_56B5"
```

>"i_8228" "i_95FC" "i_BD58" "i_1C36" "i_502F" "i_D732" "i_6B06" "i_56B5"

*   Pick random 9/73 cases without outlier mutation profile.



*  Deconvolute known human mutational signatures

>Fitted mutational signatures, i.e., `fit_res`, `fit_res_hm` and `fit_res_nonhm` were derived using `fit_to_signatures` function from *MutationalPatterns* R package.



*   Merge signatures by proposed mechanism


```
Joining, by = "sig_id"
Joining, by = "sig_id"
Joining, by = "sig_id"
```


*   Function to plot signature contribution

>Rewrite of `plot_contribution` function from *MutationalPatterns* R package.



### Fig 3A

>Plot deconvoluted signature contribution after grouping signatures based on proposed mechanism.



### Suppl Fig 3A

>Plot absolute and relative contribution of dominant signatures.


```
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  0.000   0.000   0.000   3.282   2.750  35.465 
```

```
 [1] "Signature 1"    "Signature 2"    "Signature 8"    "Signature 9"   
 [5] "Signature 11"   "Signature 15"   "Signature 27"   "Signature T-1" 
 [9] "Signature T-3"  "Signature T-10" "Signature T-11"
```

### Suppl Fig 3B

>Boxplot comparison of genomic instability related signatures between canine glioma patients separated by outlier mutation profile.


```
notch went outside hinges. Try setting notch=FALSE.
notch went outside hinges. Try setting notch=FALSE.
notch went outside hinges. Try setting notch=FALSE.
notch went outside hinges. Try setting notch=FALSE.
notch went outside hinges. Try setting notch=FALSE.
```

***

## Fig 3B

>Compare de-novo mutational signatures in canine and human pediatric and adult glioma with deconvoluted ones from Human Cancers (n=42).

*   For each of three cohorts (canine, human pediatric and adult glioma), de-novo signatures were constructed as follows:



*   Resulting de-novo signatures from three cohorts were then merged into a single dataframe.



*   Calculate cosine similarity using `deconvolution_compare` function in [*Palimpsest*](https://github.com/FunGeST/Palimpsest) R package. Author of Palimpsest package has provided [a detailed documentation](https://github.com/FunGeST/Palimpsest/raw/master/Files/vignette_palimpsest_2.0.pdf) on how to run Palimpsest workflow.


```
quartz_off_screen 
                2 
```

***

## Fig 3C

>Plot estimated mutational signature contribution per driver gene.


```
Joining, by = "sigs"
Joining, by = "sigs"
Joining, by = "sigs"
```

***

### Winning Tables

>Make winning matrix of somatic variants in cancer driver genes (n=73) based on inferred clonality using [*Palimpsest*](https://github.com/FunGeST/Palimpsest) R package. Author of Palimpsest package has provided [a detailed documentation](https://github.com/FunGeST/Palimpsest/raw/master/Files/vignette_palimpsest_2.0.pdf) on how to run Palimpsest workflow.



## Fig 3D

>Run *Bradley-Terry model* to get [estimated relative timing of somatic driver events](/methods/S14_mut_timing/).


```

Attaching package: 'igraph'
```

```
The following objects are masked from 'package:rtracklayer':

    blocks, path
```

```
The following object is masked from 'package:GenomicRanges':

    union
```

```
The following object is masked from 'package:IRanges':

    union
```

```
The following object is masked from 'package:S4Vectors':

    union
```

```
The following objects are masked from 'package:NMF':

    algorithm, compare
```

```
The following objects are masked from 'package:BiocGenerics':

    normalize, path, union
```

```
The following objects are masked from 'package:dplyr':

    as_data_frame, groups, union
```

```
The following objects are masked from 'package:purrr':

    compose, simplify
```

```
The following object is masked from 'package:tidyr':

    crossing
```

```
The following object is masked from 'package:tibble':

    as_data_frame
```

```
The following objects are masked from 'package:stats':

    decompose, spectrum
```

```
The following object is masked from 'package:base':

    union
```

```

Attaching package: 'ggridges'
```

```
The following object is masked from 'package:ggplot2':

    scale_discrete_manual
```

```
Number of items: 36 
Density of wins matrix: 0.2114198 
Fully-connected: FALSE 
Number of fully-connected components: 15 
Summary of fully-connected components: 
  Component size Freq
1              1   10
2              2    2
3              4    1
4              9    2
  Component size Freq
1              1   10
2              2    2
3              4    1
4              9    2
```

```
Warning in ref_check(ref, pi): The value of 'ref' is not an item name. Using ref
= NULL instead

Warning in ref_check(ref, pi): The value of 'ref' is not an item name. Using ref
= NULL instead
```

```
Number of items: 53 
Density of wins matrix: 0.1893912 
Fully-connected: FALSE 
Number of fully-connected components: 35 
Summary of fully-connected components: 
  Component size Freq
1              1   30
2              2    1
3              3    3
4             12    1
  Component size Freq
1              1   30
2              2    1
3              3    3
4             12    1
```

```
Warning in ref_check(ref, pi): The value of 'ref' is not an item name. Using ref
= NULL instead

Warning in ref_check(ref, pi): The value of 'ref' is not an item name. Using ref
= NULL instead
```

```
Number of items: 41 
Density of wins matrix: 0.2064247 
Fully-connected: FALSE 
Number of fully-connected components: 18 
Summary of fully-connected components: 
  Component size Freq
1              1   13
2              2    2
3              4    1
4              7    1
5             13    1
  Component size Freq
1              1   13
2              2    2
3              4    1
4              7    1
5             13    1
```

```
Warning in ref_check(ref, pi): The value of 'ref' is not an item name. Using ref
= NULL instead

Warning in ref_check(ref, pi): The value of 'ref' is not an item name. Using ref
= NULL instead
```

```
Picking joint bandwidth of 0.0925
```

```
Picking joint bandwidth of 0.118
```

```
Picking joint bandwidth of 0.057
```

***

## Fig 4

>DNA methylation based classification of canine glioma.

### Preprocessing

#### Format data for plotting



#### Create table for plotting annotations



#### Labels/colors for plot



#### Plot probabilities and predictions data frame simultaneously



#### Add annotations for mutation rate, purity, and age



### Fig 4


```
Loading required package: magrittr
```

```

Attaching package: 'magrittr'
```

```
The following object is masked from 'package:purrr':

    set_names
```

```
The following object is masked from 'package:tidyr':

    extract
```

```

Attaching package: 'ggpubr'
```

```
The following object is masked from 'package:egg':

    ggarrange
```

```
The following object is masked from 'package:cowplot':

    get_legend
```

```
Warning in as_grob.default(plot): Cannot convert object of class unit into a
grob.
```

```
$`1`
```

```

$`2`
```

```

attr(,"class")
[1] "list"      "ggarrange"
```

```
quartz_off_screen 
                2 
```

### Suppl Fig 4A

>Somatic mutational lanscape, including copy-number aberrations of COSMIC cancer genes, grouped by [DNA methylation classification](/methods/S15_class_predict_methy/). 


```
quartz_off_screen 
                2 
```

### Suppl Fig 4B

>DNA methylation age of human and canine glioma.

Brewing...

***

## Fig 5

>IHC Panels

### Required metadata



>There were 33029 total fields measured and 27 fields with missing data. Fields with missing positivies were removed from further analysis.

*   Number of fields by marker


Marker    # Fields
-------  ---------
CD14          7298
CD163         6601
CD3           6654
CD79A         5993
IBA1          6456

*   Counts of number of fields by marker for each sample:


               Type         Grade       CD14    CD163    CD3     CD79A    IBA1 
----------  -----------  ------------  ------  -------  ------  -------  ------
A1             Adult      Low Grade     123      155     189      142     145  
A10            Adult      High Grade    520      675     485      783     792  
A11            Adult      High Grade    240      188     221      276     234  
A2             Adult      Low Grade     422      288     300      245     300  
A3             Adult      High Grade    392      482     362      343     525  
A4             Adult      High Grade    746      689     595      473     623  
A5             Adult      High Grade    695      432     354      357     372  
A6             Adult      High Grade    271      232     130      185     248  
A7             Adult      High Grade    467      489     387      404     227  
A8             Adult      Low Grade     558      687     548      615     467  
A9             Adult      High Grade    220      192     166      194     212  
N09-531       Canine      High Grade    189      149     148      127     166  
N09-547       Canine      High Grade     68      65       57      78       58  
N09-651       Canine      High Grade     22      18       15      40       21  
N09-868       Canine      High Grade     85      47       31      39       56  
N10-159       Canine      Low Grade      55      54       46      33       57  
N10-702       Canine      Low Grade     105      47       38      21       50  
N12-166       Canine      Low Grade     223      125     153      148     163  
N13-901       Canine      High Grade    225      170     181      140     149  
N15-161       Canine      High Grade     77      52      113      64      117  
N15-604       Canine      High Grade     67      70       75      68       60  
N16-199       Canine      High Grade     43      29       41      48       29  
11434        Pediatric    High Grade     42      33       70      38       84  
KS18-1269    Pediatric    High Grade    480      492     434      468     460  
KS19-607     Pediatric    Low Grade      54      66       48      40       0   
S13-28076    Pediatric    High Grade    362      375     1222     334     559  
S14-12021    Pediatric    High Grade    547      300     245      290     282  

*   Counts of different types of samples (ped, adult, or breed):


Sample Type       Number
---------------  -------
Adult                 11
Boston terrier         4
Boxer                  4
Lab                    1
Mixed Dog?             1
Ped                    5
Pit Bull               1

*   Marker Distributions

>For each field, the "1+", "2+", and "3+" columns positivity are summed to create a new variable Positivity. The mean of the Positivity is computed across all fields for a given sample and marker. The means are shown in the table below.


Sample.Name   type        Grade         CD14   CD163   CD3   CD79A   IBA1
------------  ----------  -----------  -----  ------  ----  ------  -----
A1            Adult       Low Grade      0.1     0.6   2.9     0.0   14.6
A10           Adult       High Grade     0.2     0.4   2.5     0.0   20.6
A11           Adult       High Grade     0.1     1.6   0.3     0.0   22.5
A2            Adult       Low Grade      0.0     0.6   3.9     0.0   22.5
A3            Adult       High Grade     0.8     0.9   0.2     0.0   42.5
A4            Adult       High Grade     1.3     7.0   0.7     0.4   34.0
A5            Adult       High Grade     1.6    24.7   2.0     0.0   38.9
A6            Adult       High Grade     0.1     0.1   0.5     0.0    9.4
A7            Adult       High Grade     0.1     5.7   0.3     0.0   31.9
A8            Adult       Low Grade      0.2     3.0   1.7     0.2   14.9
A9            Adult       High Grade     0.1     0.1   0.2     0.0   18.5
N09-531       Canine      High Grade     0.1     0.0   0.3     0.1   34.1
N09-547       Canine      High Grade     0.3    20.0   0.7     0.1   28.9
N09-651       Canine      High Grade     0.0    15.2   4.6     0.2   28.1
N09-868       Canine      High Grade     3.3    12.4   0.7     0.0   23.6
N10-159       Canine      Low Grade      8.9    11.8   2.5     0.0   24.4
N10-702       Canine      Low Grade      1.9    21.2   0.3     0.0   23.6
N12-166       Canine      Low Grade      0.1     5.1   1.0     0.0   40.3
N13-901       Canine      High Grade     2.6     0.3   0.5     0.2    6.2
N15-161       Canine      High Grade     0.6     2.6   0.7     0.1   10.6
N15-604       Canine      High Grade     0.6     9.1   4.9     0.0   30.6
N16-199       Canine      High Grade    24.5     4.1   0.1     0.0    3.3
11434         Pediatric   High Grade     0.0    57.9   0.5     0.1   37.3
KS18-1269     Pediatric   High Grade     0.0    16.7   0.4     0.3   45.6
KS19-607      Pediatric   Low Grade      5.2    46.1   0.1     0.1     NA
S13-28076     Pediatric   High Grade     0.0    11.1   0.1     0.2   76.8
S14-12021     Pediatric   High Grade     0.1    23.8   0.0     0.1   54.6

### Fig 5B

>The violin plots below show the distribution of percentage positivity. The violins are constructed using all the fields. The points are subject means. The markers CD14, CD3, and CD79A are low across grade and subject type.


```
`stat_bindot()` using `bins = 30`. Pick better value with `binwidth`.
```

![](run_all_files/figure-html/unnamed-chunk-43-1.png)<!-- -->

```
`stat_bindot()` using `bins = 30`. Pick better value with `binwidth`.
```

![](run_all_files/figure-html/unnamed-chunk-43-2.png)<!-- -->

```
`stat_bindot()` using `bins = 30`. Pick better value with `binwidth`.
```

```
quartz_off_screen 
                2 
```

### p-values

>For CD163 and IBA1, mean percentage positivities are compared across sample types (Pediatric, Adult, Canine) within high grade patients. Specifically a Wilcoxon two sample p--value is computed for Pediatric vs. Canine subject means and Pediatric vs. Adult subject means.


Marker   Group 1     Group 2    p-value
-------  ----------  --------  --------
IBA1     Pediatric   Canine      0.0040
IBA1     Pediatric   Adult       0.0162
CD163    Pediatric   Canine      0.0485
CD163    Pediatric   Adult       0.0283

***

## Fig 5

>[CIBERSORT based deconvolution of immune microenvironment](/methods/S16_expression_immune/#cibersort-based-expression-analysis) in human and canine glioma. 

### Required metadata



### Fig S5


```
quartz_off_screen 
                2 
```

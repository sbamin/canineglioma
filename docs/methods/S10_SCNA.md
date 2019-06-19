---
title: Somatic Copy Number Aberrations (SCNA)
noindex: true
---

## Segmentation and Significant Peaks

Somatic copy-numbers were called for paired tumor-normal cases (n=56) using HMMCopy tool (version 1.22.0) using author’s recommendations. In brief, GC counts and mappability files for CanFam3.1 genome were generated with 1000 bp window size. Read counts for each of tumor and normal bam files were generated using 1000 bp window size. Resulting count, mappability and count files were feed into HMMCopy algorithm (http://bioconductor.org/packages/release/bioc/html/HMMcopy.html) and segmentations were called using Viterbi algorithm.

Segmented copy number calls were used to generate Integrated Genome Viewer (IGV) copy-number plots and GISTIC2 (version 2.0.22) based somatic copy number significance (Mermel et al., 2011), including calling gene-level deep deletions, loss-of-heterozygosity (LOH), and amplifications (Figure 2A) as well as inferring aneuploidy metrics (Figure 2B, 2C, 2D). Segmented copy number for pediatric gliomas (n=53) were called by using cloud-based TitanCNA workflow (https://dxapp.verhaaklab.com/dnanexus_ngsapp).

Segmented copy number for adult gliomas were derived from SNP6 based platform from the TCGA Broad Firehose platform (version stddata__2016_01_28) with following download urls:

```sh
http://gdac.broadinstitute.org/runs/stddata__2016_01_28/data/GBM/20160128/gdac.broadinstitute.org_GBM.Merge_snp__genome_wide_snp_6__broad_mit_edu__Level_3__segmented_scna_minus_germline_cnv_hg19__seg.Level_3.2016012800.0.0.tar.gz

http://gdac.broadinstitute.org/runs/stddata__2016_01_28/data/LGG/20160128/gdac.broadinstitute.org_LGG.Merge_snp__genome_wide_snp_6__broad_mit_edu__Level_3__segmented_scna_minus_germline_cnv_hg19__seg.Level_3.2016012800.0.0.tar.gz
```

Only primary tumor cases from TCGA GBM (n=577) and TCGA LGG (n=513) cohort were used for downstream analyses, i.e., pathway analysis (Figure 1C) and aneuploidy metrics (Figure 2B, 2C, 2D).

## Allele-specific SCNA

We derived allele-specific copy numbers and copy-number based clonality inference (including purity and ploidy estimates) using TitanCNA algorithm (version 1.19.1) (Ha et al., 2014). Snakemake (version 5.2.1) based workflow(Koster and Rahmann, 2018) was implemented using default arguments and genome-specific germline dbSNP resource (see under extended methods) (https://github.com/gavinha/TitanCNA/tree/master/scripts/snakemake) for WGS paired tumor-normal samples from 56 canine patients. For pediatric gliomas (n=53) and adult gbms with WGS data (n=23), allele-specific copy-number calls were used from TitanCNA workflow. Allele-specific copy-numbers were used for mutational signature and molecular timing analysis (Figure 3).

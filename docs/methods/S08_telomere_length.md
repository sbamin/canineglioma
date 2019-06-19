---
title: Telomere Length Analysis
noindex: true
---

Telomere length (TL) estimation (Figures S1C, S1D) was done using telomerecat (version 3.2) (Farmery et al., 2018) tool given it does not assume fixed number of telomeres (per chromosomes) and hence, can better model (Farmery et al., 2018) telomere length in samples with aneuploidy like canine gliomas. Using bam2telbam command, we first extracted telomeric reads from WGS bam files of tumor and matched normal samples. Telomere length per tumor and matched normal samples were then estimated using telbam2length command which counts number of telomeric reads containing the sequence “TTAGGG” or “CCCTAA” for two or more times. Additional arguments, -N 10 and -e were used to run length simulation and cohort wise error correction (snap-frozen vs FFPE) for accurate estimation of telomere length. Telomere length for human pediatric and adult tumors were taken from published studies (Barthel et al., 2017; Parker et al., 2012). Gene expression of core telomere pathway genes (TERT, ATRX, DAXX) was calculated from processed RNA-seq data (Figure S1E).

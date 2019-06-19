---
title: Immune Microenvironment Analysis
noindex: true
---

Processed RNA-seq expression matrices from canine (n=40; 25 HGG, 14 LGG, 1 unknown grade), adult (n=703; 529 LGG, 174 GBM), and pediatric glioma (n=92; 42 LGG, 50 HGG) were each run as separate jobs into the CIBERSORT webserver (https://cibersort.stanford.edu) and processed in relative mode using the following parameters: Signature Genes: LM22 CIBERSORT default, Permutations run: 100, Quantile normalization disabled (Newman et al., 2015). The resulting cellular fraction tables were then collapsed from 22 cell types into 11 based on lineage, using groupings from a prior publication (Gentles et al., 2015).

---
title: Estimating Intratumor Heterogeneity
noindex: true
---

We estimated patient-level ITH based on whole-genome derived subclonal structure and number of somatic variants in each of these subclones. Subclonal structure and cellular prevalence or cancer cell fraction of each tumor subclone (and underlying somatic variants) was derived using TITAN allele-specific copy number calls. Since accuracy of inferred subclonal structure depends largely on sequencing read depth and number of somatic variants per inferred subclone, we limited estimation of subclonal structure for maximum five subclones per patient given a minimum sequencing read depth of 30X for whole genome data we had across all three cohorts. Shannon entropy was then calculated using entropy function in the R package: entropy by taking number of somatic variants per subclone per patient as a vector. A resulting Shannon entropy value was used to plot figures along with cancer cell fraction and number of clones derived per patient. We acknowledge that our estimation of ITH and resolving subclonal structure can be improved with higher depth of sequencing (100X or more) to detect subclonal structures (number of clones) (Deshwar et al., 2015).
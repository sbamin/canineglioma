---
title: Aneuploidy Metrics
noindex: true
---

The simplest metric of aneuploidy was computed by taking the size of all non-neutral segments divided by the size of all segments. The resulting aneuploidy value indicates the proportion of the segmented genome that is non-diploid. In parallel, an arm-level aneuploidy score modeled after a previously described method was computed (Taylor et al., 2018). Briefly, adjacent segments with identical arm-level calls (-1, 0 or 1) were merged into a single segment with a single call. For each merged/reduced segment, the proportion of the chromosome arm it spans was calculated. Segments spanning greater than 80% of the arm length resulted in a call of either -1 (loss), 0 (neutral) or +1 (gain) to the entire arm, or NA if no contiguous segment spanned at least 80% of the arm's length. For each sample the number of arms with a non-neutral event was finally counted. The resulting aneuploidy score is a positive integer with a minimum value of 0 (no chromosomal arm-level events detected) and a maximum value of 38 (total number of autosomal chromosome arms – given all of canine chromosomes are either acrocentric or telocentric).

## Clustering based on shared syntenic regions

Shared syntenic regions between CanFam3.1 and hg19 reference genome were downloaded from Ensembl BioMart (version 94) database using orthologous mapped Ensembl gene ids. Arm-level synteny was based on arm-level aneuploidy scores of shared syntenic regions in the respective, canine and human genomes. Hierarchical clustering of syntenic arms was then carried out for each of canine, human pediatric and adult cohort (Figure 2C).

---
title: Significantly Mutated Genes (SMGs)
---

SMG analysis in canine gliomas (Figure 1A, 1C, 2A) with paired tumor-normal samples (n=67) was performed using dNdS (Martincorena et al., 2017) and MuSiC2 (version 0.2) (Dees et al., 2012). We excluded tumor-only cases for being conservative in SMG analysis and minimize false-positives. Also, MuSiC2 required matched normal tissue required matched normal tissue for SMG analysis. Detailed output from both methods are in Table S2.

### dnds

Please refer to [dnds github issue #9](https://github.com/im3sanger/dndscv/issues/9) for details on how to run dnds for canine genome, *CanFam3.1*, specifically [this comment](https://github.com/im3sanger/dndscv/issues/9#issuecomment-423551391) by Iñigo Martinkorena and related conversation.

### MuSiC2

*   Calculate ROI-wise coverage: Get coverage over regions of interest (ROI), i.e., protein-coding gene regions in canonical canine chromosomes.

```sh
music2 bmr calc-covg-helper \
    --normal-tumor-bam-pair="donor1  /path/to/donor1_normal.bam   /path/to/donor1_tumor.bam" \
    --roi-file=CanFam3_1_85_new_RNA_rois_pcg_canonicalchrs.bed \
    --reference-sequence=DogWGSReference/CanFam3_1.fa \
    --output-file=mutsigs/music2/s1_calc_covg/roi_covgs/donor1.covg \
    --normal-min-depth=6 \
    --tumor-min-depth=8 \
    --min-mapq=20 \
    --bp-class-types=AT,CpG,CG
```

*   Calculate gene-level coverage

```sh
music2 bmr calc-covg \
    --bam-list music2/ingest/bam_list.tsv \
    --output-dir mutsigs/music2/s1_calc_covg/ \
    --reference-sequence DogWGSReference/CanFam3_1.fa \
    --roi-file CanFam3_1_85_new_RNA_rois_pcg_canonicalchrs.bed \
    --tumor-min-depth 8 \
    --normal-min-depth 6
```

*   Calculate BMR

```sh
music2 bmr calc-bmr \
    --bam-list music2/ingest/bam_list.tsv \
    --maf-file "$M2MAF" \
    --output-dir mutsigs/music2/s1_calc_covg/ \
    --reference-sequence DogWGSReference/CanFam3_1.fa \
    --roi-file CanFam3_1_85_new_RNA_rois_pcg_canonicalchrs.bed \
    --genes-to-ignore ENSCAFG00000002057,ENSCAFG00000011212 \
    --bmr-groups 2 \
    --show-skipped \
    --bp-class-types AT,CpG,CG
```

*   Infer MuSiC2 SMGs

```sh
music2 smg \
    --gene-mr-file=gene_mrs \
    --output-file=smgs \
    --max-fdr=0.1 \
    --processors=20
```

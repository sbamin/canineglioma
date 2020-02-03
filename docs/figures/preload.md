---
title: Preload &middot; RData
---

### Load R objects

Download [/data/cgp_base_objects_v1.0.RData](/data/cgp_base_objects_v1.0.RData)

```r
load("cgp_base_objects_v1.RData")
ls()
```

| R object | Description |
|---|---|
| cgp_suppl_sample_info_master | Donor level information on 84 canine patients with glioma. |
| maf_nogistic | maftools compatible MAF object, does not contain copy number data on 81 canine patients. Note that three patients had no detectable somatic mutations following somatic mutation filtration. |
| maf_gistic_matched | maftools compatible MAF object, does contain copy number data on 67 canine patients with paired tumor-normal samples. |
| cancer_genes_maftools | Cancer genes with observed somatic mutation in canine patients (n=48). Based on cancer hallmark analysis (Fig 1B).
| mutrate_table | Somatic mutation burden across patients of canine and human pediatric and adult cancers (n=4,840). |

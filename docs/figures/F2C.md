---
title: F2C &middot; Comparative Shared Syntenic Aneuploidy
authors: "Floris P. Barthel"
---

`mat_aneuploidy_summary_mostvar_cgAll` matrix contains proportion of patients per cohort with arm-level aneuploidy, and was based on [arm-level aneuploidy metrics](/methods/S11_aneuploidy/). Related code is available at the GLASS consortium [marker paper code repository](https://github.com/TheJacksonLaboratory/GLASS/tree/master/sql/cnv), namely, `recapseg_postgres.sql` and `taylor_aneuploidy.sql` [^1].

```r
pheatmap::pheatmap(mat_aneuploidy_summary_mostvar_cgAll,
    cluster_rows = FALSE, cluster_cols = TRUE,
    cellwidth = 12, cellheight = 12,
    fontsize_col = 8, fontsize_row = 12,
    labels_col = colnames(mat_aneuploidy_summary_mostvar_cgAll),
    filename = "F2C.pdf",
    width = 12, height = 4, angle_col = 45,
    gaps_row = c(1,4),
    useDingbats = FALSE)
```

[^1]: Barthel FP, Johnson KC, Varn FS, Moskalik AD, Tanner G, Kocakavuk E, et al. Longitudinal molecular trajectories of diffuse glioma in adults. Nature 2019. doi: [10.1038/s41586-019-1775-1](https://doi.org/10.1038/s41586-019-1775-1).

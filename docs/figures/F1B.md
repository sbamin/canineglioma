---
title: F1B &middot; Somatic Recurrent Hotspot Mutations
---

Gene *lollipop* plots in the manuscript were plotted using [lollipops](https://github.com/joiningdata/lollipops) software by Jay JJ [^1]. Orthologous amino acid annotations were based on Ensembl Variant Effect Predictor (VEP), v91 annotations using column, `HGVSp_Short`. Width of plots for IDH1 and SPOP were scaled for image clarity and it is not proportional to size of protein encoded by the respective gene.

```sh
lollipops -U P42336 -legend -labels -o pik3ca.png H1047R@7 H1047L@1 E542K@1 E545K@1
lollipops -legend -labels -o idh1.png IDH1 R132C@3
lollipops -U O43791 -legend -labels -o spop.png P94R@2
```

*   Alternate code using `lollipopPlot` function in R package, [*maftools*](https://bioconductor.org/packages/release/bioc/html/maftools.html)[^2]

```r
lollipopPlot(maf = maf_nogistic,
            gene = 'PIK3CA',
            AACol = 'HGVSp_Short',
            showMutationRate = TRUE,
            labelPos = 1047, labPosSize = 1.2,
            cBioPortal = FALSE, repel = FALSE,
            collapsePosLabel = TRUE, legendTxtSize = 1.2,
            labPosAngle = 0, domainLabelSize = 1.0, axisTextSize = c(1, 1),
            printCount = TRUE, colors = NULL, domainColors = NULL,
            labelOnlyUniqueDoamins = TRUE, defaultYaxis = TRUE,
            titleSize = c(1.2, 1), pointSize = 1.2)

lollipopPlot(maf = maf_nogistic,
            gene = 'IDH1',
            AACol = 'HGVSp_Short',
            showMutationRate = TRUE,
            labelPos = 132, labPosSize = 1.2,
            cBioPortal = FALSE, repel = FALSE,
            collapsePosLabel = TRUE, legendTxtSize = 1.2,
            labPosAngle = 0, domainLabelSize = 1.0, axisTextSize = c(1, 1),
            printCount = TRUE, colors = NULL, domainColors = NULL,
            labelOnlyUniqueDoamins = TRUE, defaultYaxis = TRUE,
            titleSize = c(1.2, 1), pointSize = 1.2)

lollipopPlot(maf = maf_nogistic,
             gene = 'SPOP',
             AACol = 'HGVSp_Short',
             showMutationRate = TRUE,
             labelPos = 94, labPosSize = 1.2,
             cBioPortal = FALSE, repel = FALSE,
             collapsePosLabel = TRUE, legendTxtSize = 1.2,
             labPosAngle = 0, domainLabelSize = 1.0, axisTextSize = c(1, 1),
             printCount = TRUE, colors = NULL, domainColors = NULL,
             labelOnlyUniqueDoamins = TRUE, defaultYaxis = TRUE,
             titleSize = c(1.2, 1), pointSize = 1.2)
```


[^1]: Jay JJ, Brouwer C (2016) Lollipops in the Clinic: Information Dense Mutation Plots for Precision Medicine. PLoS ONE 11(8): e0160519. doi: [10.1371/journal.pone.0160519](http://dx.doi.org/10.1371/journal.pone.0160519).
[^2]: Mayakonda A, Lin D, Assenov Y, Plass C, Koeffler PH (2018). “Maftools: efficient and comprehensive analysis of somatic variants in cancer.” Genome Research. doi: [10.1101/gr.239244.118](https://doi.org/10.1101/gr.239244.118).

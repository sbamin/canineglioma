---
title: F1C &middot; Comparative Pathway Analysis
authors: Emre Kocakavuk
---

Cancer Hallmarks enrichment across canine, human pediatric and adult gliomas. 
>Genes to hallmark mapping  was primarily derived from SLAPenrich R package[^1]. See also [relevant methods](/methods/S07_hallmarks/) for details.

```r
table_hallmark <- as.data.frame(table(HALLMARK$hallmark)) %>%
                    rename(hallmark = Var1)

## require at least one driver event
Freq_threshold = 1

CG_HALLMARK <- CG_all %>% 
  gather(key = sample, value = value, -gene_symbol) %>%
  filter(gene_symbol %in% HALLMARK$gene_symbol) %>% 
  left_join(HALLMARK, by = "gene_symbol") %>% 
  select(-gene_symbol) %>% 
  group_by(hallmark, sample) %>% 
  mutate(sum = sum(value)) %>%  
  select(-value) %>% 
  ungroup() %>% 
  distinct() %>%
  left_join(table_hallmark) %>% 
  mutate(alteration = ifelse(sum >= Freq_threshold, 1, 0)) %>%  
  add_count(hallmark, name = "n_hallmark") %>%
  mutate(n_hallmark = n_hallmark + 5) %>% 
  add_count(hallmark, alteration, name = "n_alterations") %>% 
  mutate(proportion_CG = n_alterations/n_hallmark,
         CG_no_alterations = n_hallmark - n_alterations) %>% 
  filter(alteration != 0) %>% 
  select(hallmark, proportion_CG,
         CG_alterations = n_alterations,
         CG_no_alterations,
         CG_total = n_hallmark) %>% 
  distinct()
```

*   Similar to `CG_HALLMARK`, enrichment per hallmark tables were created for molecular subtypes across human cancers, and merged in the master table, `ALL_HALLMARK_v1`.

```r
## This code block will not run as variant calls for human cancers are not
## stored in public repository. Instead, we provide ALL_HALLMARK_v1 object
## to draw figures.

ALL_HALLMARK_v1 <- AG_IDHWT_HALLMARK %>%
    left_join(AG_IDHMUT_CODEL_HALLMARK, by = "hallmark") %>%
    left_join(AG_IDHMUT_NONCODEL_HALLMARK,  by =  "hallmark") %>%
    left_join(PG_HGG_HALLMARK,  by =  "hallmark") %>%
    left_join(PG_LGG_HALLMARK,  by =  "hallmark") %>%
    left_join(CG_HALLMARK,  by =  "hallmark") %>% 
    select(hallmark,
        IDHWT = proportion_AG_IDHWT,
        IDHMUT_CODEL = proportion_AG_IDHMUT_CODEL,
        IDHMUT_NONCODEL = proportion_AG_IDHMUT_NONCODEL,
        PG_H3mut = proportion_PG_HGG,
        PG_H3wt = proportion_PG_LGG,
        CG = proportion_CG) %>%
        gather(key = species, value = proportion, IDHWT:CG) %>%
        mutate(species = factor(species,
            levels = c("CG",
                        "PG_H3wt", "PG_H3mut",
                        "IDHMUT_CODEL", "IDHMUT_NONCODEL", "IDHWT")))
```

### Fig 1C

>Subset of hallmarks as a main figure 1C.

```r
pdf(file = "F1C.pdf",
    height = 7, width = 15,
    bg = "transparent",
    useDingbats = FALSE)

ALL_HALLMARK_v1 %>% 
  filter(hallmark %in%
    c("Avoiding Immune Destruction",
        "Deregulating Cellular Energetics",
        "Epigenetic Deregulation",
        "Genome Instability and Mutation",
        "Resisting Cell Death")) %>% 
  unite("hallmark_species", hallmark, species, remove = F) %>% 
  mutate(hallmark_species = factor(hallmark_species, 
   levels = c("Deregulating Cellular Energetics_CG", "Deregulating Cellular Energetics_PG_H3wt", "Deregulating Cellular Energetics_PG_H3mut","Deregulating Cellular Energetics_IDHMUT_CODEL", "Deregulating Cellular Energetics_IDHMUT_NONCODEL", "Deregulating Cellular Energetics_IDHWT",
              "Resisting Cell Death_CG", "Resisting Cell Death_PG_H3wt", "Resisting Cell Death_PG_H3mut", "Resisting Cell Death_IDHMUT_CODEL", "Resisting Cell Death_IDHMUT_NONCODEL", "Resisting Cell Death_IDHWT",
              "Genome Instability and Mutation_CG", "Genome Instability and Mutation_PG_H3wt", "Genome Instability and Mutation_PG_H3mut", "Genome Instability and Mutation_IDHMUT_CODEL", "Genome Instability and Mutation_IDHMUT_NONCODEL", "Genome Instability and Mutation_IDHWT",
              "Epigenetic Deregulation_CG", "Epigenetic Deregulation_PG_H3wt", "Epigenetic Deregulation_PG_H3mut", "Epigenetic Deregulation_IDHMUT_CODEL", "Epigenetic Deregulation_IDHMUT_NONCODEL", "Epigenetic Deregulation_IDHWT",
              "Avoiding Immune Destruction_CG", "Avoiding Immune Destruction_PG_H3wt","Avoiding Immune Destruction_PG_H3mut", "Avoiding Immune Destruction_IDHMUT_CODEL", "Avoiding Immune Destruction_IDHMUT_NONCODEL", "Avoiding Immune Destruction_IDHWT")),
    hallmark = factor(hallmark, levels = c("Deregulating Cellular Energetics", "Resisting Cell Death", "Genome Instability and Mutation", "Epigenetic Deregulation", "Avoiding Immune Destruction"), 
                   labels = c("Deregulating Cellular Energetics" = "Deregulating  \nCellular Energetics" , "Resisting Cell Death" = "Resisting Cell  \nDeath", "Genome Instability and Mutation" = "Genome  \nInstability", "Epigenetic  \nDeregulation", "Avoiding Immune Destruction" = "Avoiding Immune  \nDestruction"))) %>% 
    ggplot(aes(x = hallmark_species, y = proportion, fill = hallmark)) +
    geom_bar(stat = "identity", position = "dodge", width = 0.975) +
    scale_fill_brewer(palette = "Dark2", " ") +
    labs(x = " ", y = "Proportion of patients") + 
    cowplot::theme_cowplot(font_size = 18) +
    theme(legend.position = "bottom", legend.text = element_text(size=22), axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
    coord_cartesian(ylim = c(0,1)) +
    scale_x_discrete(labels=c(
        "Resisting Cell Death_IDHWT" = "IDHwt",
        "Resisting Cell Death_IDHMUT_CODEL" = "IDHmut\ncodel",
        "Resisting Cell Death_IDHMUT_NONCODEL" = "IDHmut\nnoncodel",
        "Resisting Cell Death_PG_H3mut" = "H3mut",
        "Resisting Cell Death_PG_H3wt" = "H3wt",
        "Resisting Cell Death_CG" = "CG", 
        "Avoiding Immune Destruction_IDHWT" = "IDHwt",
        "Avoiding Immune Destruction_IDHMUT_CODEL" = "IDHmut\ncodel",
        "Avoiding Immune Destruction_IDHMUT_NONCODEL" = "IDHmut\nnoncodel",
        "Avoiding Immune Destruction_PG_H3mut" = "H3mut", "Avoiding Immune Destruction_PG_H3wt" = "H3wt",
        "Avoiding Immune Destruction_CG" = "CG", 
        "Deregulating Cellular Energetics_IDHWT" = "IDHwt",
        "Deregulating Cellular Energetics_IDHMUT_CODEL" = "IDHmut\ncodel","Deregulating Cellular Energetics_IDHMUT_NONCODEL" = "IDHmut\nnoncodel",
        "Deregulating Cellular Energetics_PG_H3mut" = "H3mut",
        "Deregulating Cellular Energetics_PG_H3wt" = "H3wt",
        "Deregulating Cellular Energetics_CG" = "CG", 
        "Epigenetic Deregulation_IDHWT" = "IDHwt",
        "Epigenetic Deregulation_IDHMUT_CODEL" = "IDHmut\ncodel",
        "Epigenetic Deregulation_IDHMUT_NONCODEL" = "IDHmut\nnoncodel",
        "Epigenetic Deregulation_PG_H3mut" = "H3mut",
        "Epigenetic Deregulation_PG_H3wt" = "H3wt",
        "Epigenetic Deregulation_CG" = "CG",
        "Genome Instability and Mutation_IDHWT" = "IDHwt",
        "Genome Instability and Mutation_IDHMUT_CODEL" = "IDHmut\ncodel",
        "Genome Instability and Mutation_IDHMUT_NONCODEL" = "IDHmut\nnoncodel",
        "Genome Instability and Mutation_PG_H3mut" = "H3mut",
        "Genome Instability and Mutation_PG_H3wt" = "H3wt",
        "Genome Instability and Mutation_CG" = "CG")) + 
    geom_vline(xintercept = c(1.5, 3.5, 7.5, 9.5, 13.5, 15.5, 19.5, 21.5, 25.5, 27.5),
    color="white", linetype="solid", size=3.5) +
    geom_vline(xintercept = c(6.5, 12.5, 18.5, 24.5),
    color="black", linetype="solid", size=0.5)

dev.off()
```


### Suppl Fig 1C

>Visualize all hallmarks.

```r
barplot_all <- ALL_HALLMARK_v1 %>%
    ggplot(aes(x = species, y = proportion, fill = hallmark)) +
    geom_bar(stat = "identity", width = 0.975) + cowplot::theme_cowplot(font_size = 22) +
    geom_vline(xintercept = c(1.5, 3.5), color="white", linetype="solid", size=4) + 
    scale_fill_manual(values = c("Evading Growth Suppressors" = "#754200", 
                               "Avoiding Immune Destruction" = "#D12690", 
                               "Enabling Replicative Immortality" = "#007DB1", 
                               "Tumor-Promoting Inflammation" = "#E17A1D", 
                               "Activating Invasion and Metastasis" = "#221E1F", 
                               "Inducing Angiogenesis"  = "#EF3B34", 
                               "Genome Instability and Mutation" = "#1A3D8F", 
                               "Resisting Cell Death" = "#839098", 
                               "Deregulating Cellular Energetics" = "#7F3F98", 
                               "Sustaining Proliferative Signaling" = "#019E59", 
                               "Epigenetic Deregulation" = "#777AB1",
                               "#777AB1", 
                               "Other" = "#cdcdc1")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  labs(x = " ", y = "Proportion of patients", fill = "") +
  facet_wrap(~hallmark) + 
  theme(strip.background = element_blank(),strip.text.x = element_blank()) +
  scale_x_discrete(labels=c("CG", "H3wt", "H3mut", "IDHmut-codel", "IDHmut-noncodel", "IDHwt"))

pdf(file = "SF1C.pdf",
    height = 10, width = 15,
    bg = "transparent",
    useDingbats = FALSE)

barplot_all

dev.off()
```

[^1]: Iorio F, Garcia-Alonso L, Brammeld JS, Martincorena I, Wille DR, McDermott U, et al. Pathway-based dissection of the genomic heterogeneity of cancer hallmarks’ acquisition with SLAPenrich. Sci Rep 2018;8:6713. doi: [10.1038/s41598-018-25076-6](https://doi.org/10.1038/s41598-018-25076-6).

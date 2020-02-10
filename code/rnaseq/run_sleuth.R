#' ---
#' title: "Collate kallisto counts using sleuth"
#' subtitle: "CGP RNA seq - make gene level expression summary using kallisto and sleuth"
#' author: "Samir B. Amin"
#' date: "01/11/2019"
#' output:
#'   html_document:
#'     code_folding: hide
#'     df_print: paged
#'     fig_caption: yes
#'     highlight: textmate
#'     keep_md: yes
#'     number_sections: yes
#'     theme: default
#'     toc: yes
#'     toc_depth: 4
#'     toc_float: yes
#' ---
#' 
#' 

#' #### setup env.
#+ setup, eval = TRUE, echo=FALSE, results='hide', message=TRUE, warning=TRUE
library(knitr)

mybasedir = here::here()
message(sprintf("basedir is %s", mybasedir))

opts_chunk$set(comment=NA, fig.width=11, fig.height=8, 
               message=FALSE, cache=FALSE, echo=TRUE, warning = TRUE,
               fig.path = file.path(mybasedir, 'figures/cgp-kallisto-sleuth-'),
               cache.path = file.path(mybasedir, 'cache/'))

library(tidyverse)
library(sleuth)
#'
#'
#' #### Import kallisto results
#' Import kallisto results and prepare required sample info with covariates
#+ get_kallisto_results
kal_dirs = dir(path = "/fastscratch/amins/kallisto/rundir", pattern = "*kallisto_pizzly_*", recursive = TRUE, include.dirs = TRUE, full.names = TRUE)

length(kal_dirs)
head(kal_dirs)

sample_id = str_extract(string = kal_dirs, pattern = "(?=.*pizzly_)S[A-Za-z0-9-]{18}")
head(sample_id)

sample_info_df_normal = tibble(sample_id, kal_dirs) %>%
                    filter(grepl("u", sample_id)) %>%
                    filter(grepl("-T6", sample_id)) %>%
                    mutate(archival = if_else(grepl("-A1-", sample_id), "frozen", "ffpe"),
                           seq_ctr = if_else(grepl("-J03u-", sample_id), "JAX", "MDACC")) %>%
                    rename(path = kal_dirs,
                           sample = sample_id) %>%
                    select(sample, archival, seq_ctr, path)

sample_info_df_tumors = tibble(sample_id, kal_dirs) %>%
                    filter(grepl("u", sample_id)) %>%
                    filter(grepl("-T1", sample_id)) %>%
                    mutate(archival = if_else(grepl("-A1-", sample_id), "frozen", "ffpe"),
                    seq_ctr = if_else(grepl("-J03u-", sample_id), "JAX", "MDACC")) %>%
                    rename(path = kal_dirs,
                           sample = sample_id) %>%
                    select(sample, archival, seq_ctr, path)

sample_info_df_normal
sample_info_df_tumors

#'
#'
#' #### Prepare Sleuth Object
#' Run sleuth_prep to model kallisto counts
#+ run_sleuth_model

## Transcript to gene mapping for gene-level matrix
mart <- biomaRt::useMart(biomart = "ENSEMBL_MART_ENSEMBL",
  dataset = "cfamiliaris_gene_ensembl")

t2g <- biomaRt::getBM(attributes = c("ensembl_transcript_id", "ensembl_gene_id",
    "external_gene_name"), mart = mart)

t2g <- dplyr::rename(t2g, target_id = ensembl_transcript_id,
  ens_gene = ensembl_gene_id, ext_gene = external_gene_name)

head(t2g)

## prepare sleuth object
so_tumors = sleuth_prep(sample_info_df_tumors, ~ archival + seq_ctr, 
                        extra_bootstrap_summary = TRUE, 
                        num_cores = 10, 
                        target_mapping = t2g,
                        aggregation_column = 'ens_gene',
                        gene_mode = TRUE)

## fit full model
so_tumors <- sleuth_fit(so_tumors)

## fit reduced model
so_tumors <- sleuth_fit(so_tumors, ~1, 'reduced')

## perform fit test
so_tumors <- sleuth_lrt(so_tumors, 'reduced', 'full')

## model summary
models(so_tumors)

#'
#' 
#' #### Get gene-level table
#' Export gene-level, covariated corrected, TPM normalized matrix
#+ get_gene_table

sleuth_table <- sleuth_results(so_tumors, 'reduced:full', 'lrt', show_all = FALSE)
dim(sleuth_table)

sleuth_significant <- dplyr::filter(sleuth_table, qval <= 0.05)
sleuth_significant[1:5,1:5]
dim(sleuth_significant)

sleuth_tpm_normed = sleuth_to_matrix(so_tumors, which_df = "obs_norm", which_units = "tpm")
dim(sleuth_tpm_normed)

sleuth_tpm_normed_df = tbl_df(sleuth_tpm_normed) %>%
                       bind_cols(tbl_df(rownames(sleuth_tpm_normed))) %>%
                       rename(ens_gene = value) %>%
                       left_join(t2g %>% select(-target_id)) %>%
                       select(ens_gene, ext_gene, everything())

sleuth_tpm_normed[1:4,1:4]
sleuth_tpm_normed_df[1:4,1:4]


sleuth_srpb_normed = sleuth_to_matrix(so_tumors, which_df = "obs_norm", which_units = "scaled_reads_per_base")
dim(sleuth_srpb_normed)

sleuth_srpb_normed_df = tbl_df(sleuth_srpb_normed) %>%
                       bind_cols(tbl_df(rownames(sleuth_srpb_normed))) %>%
                       rename(ens_gene = value) %>%
                       left_join(t2g %>% select(-target_id)) %>%
                       select(ens_gene, ext_gene, everything())

sleuth_srpb_normed[1:4,1:4]
sleuth_srpb_normed_df[1:4,1:4]

## write tables
write_tsv(sleuth_tpm_normed_df, "cgp_rnaseq_tumors_n41_sleuth_tpm_normed_df.tsv")
write_tsv(sleuth_srpb_normed_df, "cgp_rnaseq_tumors_n41_sleuth_srpb_normed_df.tsv")

## save session
mysession = sessionInfo()
sleuth_save(so_tumors, "sleuth_so_tumors_n41")
save.image("sleuth_so_tumors_n41.RData")

## END ##

#' /* run this script and generate html report using following command:
#' Rscript -e "tmp = knitr::spin('run_sleuth.R', knit = FALSE); rmarkdown::render(tmp)"
#' */

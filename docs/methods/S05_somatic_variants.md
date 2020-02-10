---
title: Somatic Variant Calls
---

## Somatic callers

Somatic variant calls were called on the merged whole genome and exome bam files using three callers: GATK4 (version 4.0.8.1) (McKenna et al., 2010) Mutect2 (Cibulskis et al., 2013), VarScan2 (version 2.4.2), and LoFreq (version 2.1.3.1) (Wilm et al., 2012). Matching and fingerprint validated WGS and exome files per sample were merged using Picard tools (v2.18.0, http://broadinstitute.github.io/picard), MergeSamFiles command. Three somatic callers were then run in either paired tumor – matched normal (n=67) or tumor-only (n=14) mode.

### Mutect2

Mutect2 was first run in *panel-of-normals* (PON) mode using 57 matched normal samples. Resulting PON file was used for calling somatic variant calls using Mutect2 in both, paired and tumor-only mode along with options:

```sh
--germline-resources 58indiv.unifiedgenotyper.recalibrated_95.5_filtered.pass_snp.fill_tags.vcf.gz –af-of-alleles-not-in-resource 0.008621
```

Tumor-only Mutect2 mode was run using default arguments and paired Mutect2 calls had following arguments:

```sh
--initial-tumor-lod 2.0 --normal-lod 2.2 --tumor-lod-to-emit 3.0 --pcr-indel-model CONSERVATIVE
```

Throughout the process of using GATK4 based tools, including Mutect2, we followed best practices guidelines (DePristo et al., 2011) where practical for canine genome, e.g., in contrast to human genome, population level resources are limited for canine genome.

### VarScan2

VarScan2 *paired mode* was run with a command: `somatic` and arguments:

```sh
--min-coverage 8 --min-coverage-normal 6 --min-coverage-tumor 8 --min-reads2 2 --min-avg-qual 15 --min-var-freq 0.08 --min-freq-for-hom 0.75 --tumor-purity 1.0 --strand-filter 1 --somatic-p-value 0.05 --output-vcf 1
```

VarScan2 *tumor-only* mode was run using command:

```sh
mpileup2cns and arguments: --min-coverage 8 --min-reads2 2 --min-avg-qual 15 --min-var-freq 0.08 --min-freq-for-hom 0.75 --strand-filter 1 --p-value 0.05 --variants --output-vcf 1
```

### LoFreq

LoFreq *paired* mode was run using command:

```sh
somatic and arguments: --threads 4 --call-indels --min-cov 7 –verbose
```

and *tumor-only* mode was run using command: `call` and arguments:

```sh
--call-indels --sig 0.05 --min-cov 7 --verbose -s
```

## Filtering

Resulting raw somatic calls - single nucleotide variants (SNV) and small insertions and/or deletions (Indels) - from three callers were then subject to filtering based on caller-specific filters and hard filters. Briefly, Mutect2 calls were subject to extensive filtering based on germline risk, artifacts arising due to sequencing platforms, tissue archival (FFPE), repeat regions, etc. Filtering parameters are in [code/snv_filters](https://github.com/TheJacksonLaboratory/canineglioma/blob/master/docs/code/snv_filters) directory, and were based upon suggestions from [GATK website](https://software.broadinstitute.org/gatk/documentation/article?id=11136). VarScan2 somatic filters were applied as per developer’s guidelines (Koboldt et al., 2013). Hard filters were based upon filtering out variants present in dbSNP and PONs created via GATK4 Mutect2. Filtered somatic calls from three callers (in VCF version 4.2 format) were then subject to consensus somatic calls using *SomaticSeq* (version 3.1.0) (Fang et al., 2015) in majority voting mode with priority given to Mutect2 filtered (PASS) calls followed by consensus voting based on calls present in VarScan2 and LoFreq filtered calls.  Resulting consensus VCF file for 81 cases were finally converted to Variant Effect Predictor (VEP version 91) (McLaren et al., 2016) annotated vcfs and Mutation Annotation Format (MAF, https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format) using vcf2maf utility (https://github.com/mskcc/vcf2maf). Annotated VCFs and MAFs were used for all of downstream analyses.

---
title: Patient and Tissue Samples
---

Tissue samples from canine patients with gliomas were acquired with material transfer agreements from Auburn University College of Veterinary Medicine, Colorado State University, Texas A&M College of Veterinary Medicine & Biomedical Sciences, UC Davis School of Veterinary Medicine and Virginia-MD College of Veterinary Medicine. Tissue samples from resected tumor (n=83) and matched normal tissue (n=67 or paired cases) were collected at the surgical treatment or immediately following euthanasia. There were also four additional dog patients where we had adequate DNA and RNA for methylation (n=48) and RNA-seq (n=40) profiling but unable to do WGS/Exome sequencing because of failed library preparation (Table S1). Matched normal tissue were from post-necropsy sample of contra-lateral healthy brain tissue (n=38), white blood cells (n=13), and remaining 17 samples from other tissues. Samples were archived in snap-frozen (n=37/67 paired cases; n=8/16 tumor-only cases) and Formalin-Fixed Paraffin-Embedded (FFPE, n=30/67 paired cases; n=8/16 tumor-only cases) state. Samples were then shipped to sequencing core facilities for sample preparation, quality control and sequencing (see Methods below).

## Sample Metadata

Sample metadata for all of canine glioma specimens is available as a supplementary [table S1](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7132629/bin/NIHMS1569196-supplement-2.xlsx "NIHMS1569196-supplement-2.xlsx") of our publication, [Amin et al. *Cancer Cell* 2020](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7132629/).

## Sample Barcode

All of samples, including corresponding raw sequencing data, is barcoded with following schema:

| Barcode tag | Explanation | [Regex String](https://en.wikipedia.org/wiki/Regular_expression) |
| -- | -- | -- |
| i_ | a library prefix without any meaningful info. | `i_` |
| D0EE | Four letter alphanumeric string equals canine subject (patient) ID. | `[A-Z0-9]{4}` |
| T6 or T1 | Tissue type. T1 is tumor, T6 is normal tissue. | `T[16]{1}` | 
| A1 or A2 | Tissue archival condition. A1 is snap-frozen, A2 is FFPE. | `A[12]{1}` |
| J or M | Sequencing center: J = JAX and M = MDAnderson | `[JM]{1}` |
| 01 to 05 | Sequencing platform: 01 = WGS, 02 = Exome, 03 = RNA-seq, 04 = unassigned, and 05 = RRBS | `0[1-5]{1}` |

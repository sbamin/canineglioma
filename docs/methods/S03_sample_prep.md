---
title: Sample preparation, QC, and Sequencing
noindex: true
---

## DNA/RNA extraction

Genomic DNA and total RNA of fresh frozen tissue and FFPE tissue from paraffin scrolls were were extracted simultaneously using AllPrep DNA/RNA Mini Kit (Qiagen) and AllPrep DNA/RNA FFPE Kit (Qiagen) according to the manufacturer’s instructions, respectively. Additional DNase treatment was performed on-column for RNA purification.

## Whole-Genome Sequencing

200-400ng of DNA was sheared to 400bp using a LE220 focused-ultrasonicator (Covaris) and size selected using Ampure XP beads (Beckman Coulter).  The fragments were treated with end-repair, A-tailing, and ligation of Illumina compatible adapters (Integrated DNA Technologies) using the KAPA Hyper Prep Kit (Illumina) (KAPA Biosystems/ Roche). For FFPE samples, 5 to 10 cycles of PCR amplification were performed. Quantification of libraries were performed using real-time qPCR (Thermo Fisher). Libraries were sequenced paired end reads of 151bp on Illumina Hiseq X-Ten (Novogene).

## Exome Sequencing

Sample were prepared as described above in the WGS sample preparation, targeting 200bp with PCR amplification. Target capture was performed using SeqCap EZ Canine Exome Custom Design (canine 140702_canFam3_exomeplus_BB_EZ_HX1 probe set) (Broeckx et al., 2015) (Roche Nimblegen). Briefly, WGS libraries were hybridized with capture probes using Nimblegen SepCap EZ Kit (Roche Nimblegen) according to manufacturer’s instruction. Captured fragments were PCR amplified and purified using Ampure XP beads. Quantification of libraries were performed using real-time qPCR (Thermo Fisher). Libraries were sequenced paired end of 76bp on Hiseq4000 (Illumina).

## RNA-seq

RNA-seq libraries were prepared with KAPA Stranded mRNA-Seq kit (Kapa Biosystem/ Roche) according to manufacturer’s instruction. First, poly A RNA was isolated from 300ng total RNA using oligo-dT magnetic beads. Purified RNA was then fragmented at 85°C for 6 mins, targeting fragments range 250-300bp. Fragmented RNA is reverse-transcribed with an incubation of 25°C for 10mins, 42°C for 15 mins and an inactivation step at 70°C for 15mins. This was followed by second strand synthesis at 16°C, 60 mins. Double stranded cDNA (dscDNA) fragments were purified using Ampure XP beads (Beckman). The dscDNA were then A-tailed, and ligated with illumina compatible adaptors (IDT). Adaptor-ligated DNA was purified using Ampure XP beads. This is followed by 10 cycles of PCR amplification. The final library was cleaned up using AMpure XP beads. Quantification of libraries were performed using real-time qPCR (Thermo Fisher). Sequencing was performed on Hiseq4000 (Illumina) generating paired end reads of 75bp.

## Reduced Representation Bisulfite Sequencing (RRBS)

Library preparation for RRBS was performed using Premium RRBS Kit (Diagenode) according to manufacturer’s instructions. Briefly, 100ng of DNA was used for each sample, which was enzymatically digested, end-repaired and ligated with an adaptor. Subsequently, 8 samples with different adaptors were pooled together and subjected to bisulfite treatment. After purification steps following bisulfite conversion, the pooled DNA was amplified with 9-14 cycles of PCR and then cleaned up with Ampure XP beads. Quantification of libraries were performed using real-time qPCR (Thermo Fisher). Libraries were sequenced single end 101bp on Hiseq2500 (Illumina).

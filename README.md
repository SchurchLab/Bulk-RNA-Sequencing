# Bulk RNA Sequencing Analysis Pipeline


# Overview

This repository provides a step-by-step pipeline for analyzing bulk RNA sequencing (RNA-seq) data. It includes data quality control, alignment, quantification, and visualization, facilitating the identification of differentially expressed genes.


# Prerequisites

Ensure the following software is installed:

R: Statistical computing environment.
Bioconductor: Package manager for R.
Conda: Package and environment manager.
Recommended R packages:

DESeq2: Differential gene expression analysis.
ggplot2: Data visualization.
ggrepel: Enhanced text labels for ggplot2.
dplyr: Data manipulation.
tibble: Enhanced data frames.
Recommended Conda packages:

fastqc: Quality control for sequencing data.
fastp: Fast all-in-one preprocessing tool.
multiqc: Aggregates QC results.
star: RNA-seq aligner.
samtools: Manipulates alignments.
deeptools: Analyzes deep sequencing data.
salmon: Quantifies transcript abundance.


# Pipeline Overview

The pipeline comprises the following steps:

**1. Quality Control**
Perform initial quality assessment of raw sequencing reads using FastQC.

**2. Alignment**
Align reads to the reference genome using STAR aligner.

**3. Post-Alignment QC**
Evaluate alignment quality with Picard tools and assess transcript integrity using RSeQC.

**4. Transcript Quantification**
Quantify gene and transcript expression levels using Salmon.

**5. Differential Expression Analysis**
Identify differentially expressed genes between conditions using DESeq2.

**6. Visualization**
Generate plots such as volcano plots and bubble plots to visualize analysis results.


#!/bin/bash

# Bulk RNA-Seq Upstream Processing Pipeline
# Author: Lanzhu/Jing
# Description: This script performs quality control, trimming, alignment, and quantification for bulk RNA-seq data.

set -e  # Exit immediately if a command exits with a non-zero status

# ========== STEP 1: Create and Activate Environment ==========
echo "Creating and activating conda environment..."
mamba create -n bulk_rnaseq -y python=3.8
mamba init
source ~/.bashrc  # Reload shell configuration
mamba activate bulk_rnaseq

# ========== STEP 2: Install Required Packages ==========
echo "Installing required packages..."
mamba install -c bioconda fastqc trim-galore hisat2 samtools subread multiqc -y

# ========== STEP 3: Quality Control with FastQC ==========
echo "Running FastQC for quality control..."
INPUT_DIR="./raw_data"  # Change this to your FASTQ file directory
OUTPUT_DIR="./qc_reports"
mkdir -p $OUTPUT_DIR
fastqc -t 8 $INPUT_DIR/*.fastq.gz -o $OUTPUT_DIR
multiqc $OUTPUT_DIR -o $OUTPUT_DIR  # Summarize results

echo "FastQC completed. Check reports in $OUTPUT_DIR."

# ========== STEP 4: Trimming with Trim Galore ==========
echo "Trimming low-quality reads and adapters..."
TRIMMED_DIR="./trimmed_data"
mkdir -p $TRIMMED_DIR
trim_galore -j 4 -q 25 --phred33 --length 25 -e 0.1 --stringency 3 --gzip -o $TRIMMED_DIR $INPUT_DIR/*.fastq.gz

echo "Trimming completed. Trimmed files are in $TRIMMED_DIR."

# ========== STEP 5: Alignment with HISAT2 ==========
echo "Aligning reads to the reference genome..."
REF_INDEX="./reference/genome"  # Path to HISAT2 genome index
ALIGN_DIR="./aligned_data"
mkdir -p $ALIGN_DIR

for file in $TRIMMED_DIR/*_trimmed.fq.gz; do
    base=$(basename $file _trimmed.fq.gz)
    hisat2 -p 8 -x $REF_INDEX -U $file -S $ALIGN_DIR/${base}.sam
done
echo "Alignment completed. SAM files are in $ALIGN_DIR."

# ========== STEP 6: Convert SAM to BAM and Sort ==========
echo "Converting SAM to BAM and sorting..."
SORTED_DIR="./sorted_bam"
mkdir -p $SORTED_DIR

for filCML_MK_countse in $ALIGN_DIR/*.sam; do
    base=$(basename $file .sam)
    samtools sort -@ 8 -o $SORTED_DIR/${base}.bam $file
    rm $file  # Remove SAM files to save space
done
echo "Sorting completed. BAM files are in $SORTED_DIR."

# ========== STEP 7: Gene Expression Quantification ==========
echo "Performing gene expression quantification..."
GTF_FILE="./reference/gencode.v38.annotation.gtf.gz"
COUNTS_DIR="./gene_counts"
mkdir -p $COUNTS_DIR
featureCounts -T 8 -a $GTF_FILE -o $COUNTS_DIR/counts.txt $SORTED_DIR/*.bam
echo "Quantification completed. Gene counts are in $COUNTS_DIR/CML_MK_counts.txt."
#!/bin/bash

# -------------------------------
# Script: run_fastqc_raw.sh
# Description: Performs quality control on raw FASTQ files using FASTQC.
# -------------------------------

# Directory containing raw FASTQ files (change this path if needed)
INPUT_DIR="../raw_fastq"

# Directory to save FASTQC output reports (HTML, ZIP)
QC_OUTPUT="../qc_output"

# Display start message
echo " -> Performing QC using FASTQC on pre-processed files <- "
echo ""

# Define the input file path pattern: all compressed FASTQ files in the input directory
inputpath="$INPUT_DIR/*.fastq.gz"

# Run FASTQC using 14 threads on all input files and save results to the output directory
fastqc -t 14 $inputpath -o $QC_OUTPUT

# Display success message
echo "QC Generated for raw fastq files"
echo ""
echo "----------------------"

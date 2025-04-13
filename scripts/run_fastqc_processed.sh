#!/bin/bash

# -----------------------------------------------
# Script: run_fastqc_processed.sh
# Description: Performs quality control using FASTQC 
#              on processed (filtered/trimmed) FASTQ files.
# -----------------------------------------------

# Directory containing processed/filtered FASTQ files
INPUT_DIR="../processed_fastq"

# Directory to save FASTQC output reports (HTML and ZIP)
QC_OUTPUT="../qc_output"

# Display start message
echo " -> Performing QC using FASTQC on processed fastq <- "
echo ""

# Define input file path pattern: all filtered .fastq.gz files
inputpath="$INPUT_DIR/*.fastq.gz"

# Run FASTQC using 14 threads on all processed input files
# Output results are saved in the QC output directory
fastqc -t 14 $inputpath -o $QC_OUTPUT

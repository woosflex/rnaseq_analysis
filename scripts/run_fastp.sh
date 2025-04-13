#!/bin/bash

# ------------------------------------------------------------
# Script: run_fastp.sh
# Description: This script runs quality trimming and filtering
#              on raw FASTQ files using fastp, producing 
#              cleaned FASTQ files and QC reports (HTML + JSON).
# ------------------------------------------------------------

# Directory containing raw input FASTQ files
INPUT_DIR="../raw_fastq"

# Directory where filtered/processed FASTQ files will be saved
OUTPUT_FASTQ="../processed_fastq"

# Directory to store QC reports from fastp (HTML and JSON)
QC_OUTPUT="../qc_output"

echo " -> Performing QC using FASTP on raw fastq files <- "
echo ""

# Create output directory for processed FASTQ files if it doesn't exist
mkdir -p "$OUTPUT_FASTQ"

# Loop through each raw FASTQ file in the input directory
for file in "$INPUT_DIR"/*.fastq.gz; do

    # Extract the filename without path and extension
    filename=$(basename "$file" .fastq.gz)

    # Set output FASTQ file path with '_filtered' suffix
    outname="${OUTPUT_FASTQ}/${filename}_filtered.fastq.gz"

    # Set paths for HTML and JSON reports
    html_report="${QC_OUTPUT}/${filename}_fastp.html"
    json_report="${QC_OUTPUT}/${filename}_fast.json"

    echo "Running FASTP on $filename"
    echo ""

    # Run fastp with various trimming and filtering options
    fastp -i $file \                             # Input file
          -o $outname \                          # Output cleaned FASTQ file
          --cut_front \                          # Trim low-quality bases from the front
          --cut_tail \                           # Trim low-quality bases from the tail
          --cut_mean_quality 20 \                # Trim bases with mean quality < 20
          --length_required 25 \                 # Discard reads shorter than 25bp
          --detect_adapter_for_pe \              # Auto-detect adapter for paired-end (doesn't affect SE but is harmless)
          --trim_poly_g \                        # Remove poly-G tail (common in Illumina NextSeq/NovaSeq)
          --thread 14 \                          # Use 14 threads
          --html $html_report \                  # Output HTML report
          --json $json_report                    # Output JSON report

    echo "QC Generated for raw fastq $filename"
    echo ""
    echo "----------------------"

done

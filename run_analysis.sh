#!/usr/bin/env bash

# A self-contained, RNA-seq pipeline till alignment using Kallisto.

# To exit immediately, if a command fails with non-zero status.
# This prevents the script from continuing with errors.
set -e

# Enable extended globbing, allowing for more powerful file matching patterns
# like `@(pattern1|pattern2)`.
shopt -s extglob

echo "--- Initializing RNA-seq Pipeline ---"

# --- Default Configuration ---

# Set the default number of threads for processing.
THREADS=1

# Define the project directory structure based on the current working directory.

PROJECT_DIR=$(pwd)
TRIMMED_DIR="$PROJECT_DIR/01_trimmed_reads"
QUANT_DIR="$PROJECT_DIR/02_kallisto_quant"
QC_DIR="$PROJECT_DIR/03_reports"
BUILD_INDEX="false"

# --- Function Definitions for Modularity ---

# Function to show help message explaining how to use the script.
show_help() {
  echo "Usage: $0 [OPTIONS]"
  echo "This script runs a Kallisto quantification pipeline."
  echo
  echo "Options:"
  echo "  -i <FASTQ_FILE_DIR>  Path to the directory having FASTQ files."
  echo "  -b                   Build the Kallisto index. Requires -f."
  echo "  -f <FASTA_FILE>      Path to the transcriptome FASTA file (used with -b)."
  echo "  -x <INDEX_FILE>      Path to the pre-existing Kallisto index (default action)."
  echo "  -t <THREADS>         Number of threads to use (default: 1)."
  echo "  -h                   Show this help message."
  echo
  echo "Examples:"
  echo "  # Build an index"
  echo "  $0 -t 4 -i ./fastq_files/ -b -f reference/transcriptome.fa.gz"
  echo
  echo "  # Run quantification using a pre-built index and 8 threads"
  echo "  $0 -t 4 -i ./fastq_files/ -x reference/kallisto.idx"
}

# Function to run FASTQC on .FASTQ files
run_fastqc() {
  # Check if any arguments were provided to prevent errors.
  if [ "$#" -eq 0 ]; then
    echo "Error: No files provided to run_fastqc."
    return 1
  fi

  # The LAST argument is the output directory.
  local outdir="${@: -1}"

  # All arguments EXCEPT the last one are the input files.
  local input_files=("${@:1:$#-1}")

  # Create the output directory if it doesn't exist.
  if [[ ! -d "$outdir" ]]; then
    echo "Creating directory to store raw FASTQ QC results."
    mkdir -p "$outdir"
  fi
  
  echo "Running FASTQC on raw FASTQ files"

  # Execute the fastqc command.
  fastqc -t "$THREADS" -o "$outdir" "${input_files[@]}"
}

# Function to run fastp for adapter trimming and quality filtering.
run_fastp() {
  local input="$1"
  local outdir="$2"
  local qc_output="$3"
  echo "Running FASTP with optimum options on FASTQ files"

  # Create the output directory for trimmed reads if it doesn't exist.
  if [[ ! -d "$outdir" ]]; then
    echo "Creating directory now for storing trimmed FASTQ files."
    mkdir -p "$outdir"
  fi

  # Create the output directory for fastp's HTML/JSON reports if it doesn't exist.
  if [[ ! -d  "$qc_output" ]]; then
    echo "Creating directory now to store FASTP reports."
    mkdir -p "$qc_output"
  fi

  # Loop through all files ending in .fastq or .fastq.gz in the input directory.
  for file in "$input"/*@(.fastq|.fastq.gz); do
    local fastq_name=$(basename $file)
    local trimmed_name=${fastq_name%.fastq*}
    echo "Filtering $trimmed_name using FASTP"
    mkdir -p $qc_output/$trimmed_name
    fastp -t $THREADS \
    -i $file \
    -o $outdir/"${trimmed_name}_trimmed.fastq" \
    --cut_front \
    --cut_tail \
    --cut_mean_quality 20 \
    --length_required 25 \
    --detect_adapter_for_pe \
    --trim_poly_g \
    --html $qc_output/$trimmed_name/"${trimmed_name}_fastp_report.html" \
    --json $qc_output/$trimmed_name/"${trimmed_name}_fastp_report.json"
  done
}

# get options
while getopts ":i:b:f:x:t:h" option; do
  case $option in
  h)
    show_help
    ;;
  i)
    FASTQ_DIR="${OPTARG%/}"
    ;;
  b)
    BUILD_INDEX="true"
    ;;
  f)
    FASTA_DIR="${OPTARG%/}"
    ;;
  x)
    INDEX_FILE="${OPTARG%/}"
    ;;
  t)
    THREADS="$OPTARG"
    ;;
  *)
    echo "Error: Invalid option provided."
    show_help
    exit 1
    ;;
  esac
done

# --- Input Validation ---

# Check if the mandatory FASTQ directory path was provided. If not, show help and exit.
if [[ -z "$FASTQ_DIR" ]]; then
  echo "Error: No FASTQ files provided as input"
  show_help
  exit 1
fi

run_fastqc "$FASTQ_DIR"/*@(.fastq|.fastq.gz) "$QC_DIR/31_fastqc_raw"

run_fastp "$FASTQ_DIR" "$TRIMMED_DIR" "$QC_DIR/32_fastp_reports"

echo "--- Pipeline Finished ---"
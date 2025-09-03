#!/usr/bin/env bash

# A self-contained, RNA-seq pipeline till alignment using Kallisto.

# To exit immediately, if a command fails with non-zero status.
set -e

shopt -s extglob

echo "--- Initializing RNA-seq Pipeline ---"

# --- Default Configuration ---
THREADS=1

# Define the project directory structure

PROJECT_DIR=$(pwd)
TRIMMED_DIR="$PROJECT_DIR/01_trimmed_reads"
QUANT_DIR="$PROJECT_DIR/02_kallisto_quant"
QC_DIR="$PROJECT_DIR/03_qc_reports"
BUILD_INDEX="false"

# --- Function Definitions for Modularity ---

# Function to show help
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

# Function to run FASTQC on raw .FASTQ files
run_fastqc_raw() {
  local input=$1
  local outdir=$2
  if [[ ! -d $outdir ]]; then
    echo "Directory '$outdir' not found. Creating it now..."
    mkdir -p $outdir
  fi
  echo "Running FASTQC on raw FASTQ files"
  fastqc -t $THREADS $input -o $outdir
}

run_fastp() {
  local input=$1
  local outdir=$2
  local qc_output=$3
  echo "Running FASTP with default settings on FASTQ files"

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
    FASTA_DIR="${$OPTARG%/}"
    ;;
  x)
    INDEX_FILE="${$OPTARG%/}"
    ;;
  t)
    THREADS="$OPTARG"
    ;;
  *)
    show_help
    exit 1
    ;;
  esac
done

if [[ -z "$FASTQ_DIR" ]]; then
  echo "Error: No FASTQ files provided as input"
  show_help
  exit
fi

run_fastqc_raw "$FASTQ_DIR/*.fastq*"  "$QC_DIR/31_fastqc_raw"

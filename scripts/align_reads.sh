#!/bin/bash

# ------------------------------------------------------------
# Script: run_kallisto.sh
# Description: Perform transcript quantification using Kallisto 
#              on processed (trimmed/filtered) FASTQ files.
#              This script handles both healthy subjects (HS) 
#              and cutaneous leishmaniasis (CL) patients.
# ------------------------------------------------------------

# Directory containing processed FASTQ files
INPUT_DIR="../processed_fastq"

# Directory where Kallisto quantification outputs will be stored
OUTPUT_DIR="../kallisto_output"

# Path to the prebuilt Kallisto index (transcriptome index)
INDEX_PATH="../index/Homo_sapiens.GRCh38.cdna.all.index"

# ------------------------------------------------------------
# Quantification for Healthy Subjects (HS)
# Each call to kallisto quant:
#   -i : specifies the index
#   -o : sets output directory for this sample
#   -t : sets the number of threads (14)
#   --single : indicates single-end reads
#   -l : estimated average fragment length
#   -s : estimated standard deviation of fragment length
#   &> : redirects stdout and stderr to a log file
# ------------------------------------------------------------

kallisto quant -i $INDEX_PATH -o "${OUTPUT_DIR}/HS01" -t 14 --single -l 250 -s 30 "${INPUT_DIR}/SRR8668755_filtered.fastq.gz" &> "${OUTPUT_DIR}/HS01.log"
echo "Aligned SRR8668755_filtered.fastq.gz / HS01"
kallisto quant -i $INDEX_PATH -o "${OUTPUT_DIR}/HS02" -t 14 --single -l 250 -s 30 "${INPUT_DIR}/SRR8668756_filtered.fastq.gz" &> "${OUTPUT_DIR}/HS02.log"
echo "Aligned SRR8668756_filtered.fastq.gz / HS02"
kallisto quant -i $INDEX_PATH -o "${OUTPUT_DIR}/HS03" -t 14 --single -l 250 -s 30 "${INPUT_DIR}/SRR8668757_filtered.fastq.gz" &> "${OUTPUT_DIR}/HS03.log"
echo "Aligned SRR8668757_filtered.fastq.gz / HS03"
kallisto quant -i $INDEX_PATH -o "${OUTPUT_DIR}/HS04" -t 14 --single -l 250 -s 30 "${INPUT_DIR}/SRR8668758_filtered.fastq.gz" &> "${OUTPUT_DIR}/HS04.log"
echo "Aligned SRR8668758_filtered.fastq.gz / HS04"
kallisto quant -i $INDEX_PATH -o "${OUTPUT_DIR}/HS05" -t 14 --single -l 250 -s 30 "${INPUT_DIR}/SRR8668759_filtered.fastq.gz" &> "${OUTPUT_DIR}/HS05.log"
echo "Aligned SRR8668759_filtered.fastq.gz / HS05"

# ------------------------------------------------------------
# Quantification for Cutaneous Leishmaniasis (CL) Patients
# Same parameters as above, different sample files
# ------------------------------------------------------------

kallisto quant -i $INDEX_PATH -o "${OUTPUT_DIR}/CL08" -t 14 --single -l 250 -s 30 "${INPUT_DIR}/SRR8668769_filtered.fastq.gz" &> "${OUTPUT_DIR}/CL08.log"
echo "SRR8668769_filtered.fastq.gz / CL08"
kallisto quant -i $INDEX_PATH -o "${OUTPUT_DIR}/CL10" -t 14 --single -l 250 -s 30 "${INPUT_DIR}/SRR8668771_filtered.fastq.gz" &> "${OUTPUT_DIR}/CL10.log"
echo "SRR8668771_filtered.fastq.gz / CL10"
kallisto quant -i $INDEX_PATH -o "${OUTPUT_DIR}/CL11" -t 14 --single -l 250 -s 30 "${INPUT_DIR}/SRR8668772_filtered.fastq.gz" &> "${OUTPUT_DIR}/CL11.log"
echo "SRR8668772_filtered.fastq.gz / CL11"
kallisto quant -i $INDEX_PATH -o "${OUTPUT_DIR}/CL12" -t 14 --single -l 250 -s 30 "${INPUT_DIR}/SRR8668773_filtered.fastq.gz" &> "${OUTPUT_DIR}/CL12.log"
echo "SRR8668773_filtered.fastq.gz / CL12"
kallisto quant -i $INDEX_PATH -o "${OUTPUT_DIR}/CL13" -t 14 --single -l 250 -s 30 "${INPUT_DIR}/SRR8668774_filtered.fastq.gz" &> "${OUTPUT_DIR}/CL13.log"
echo "SRR8668774_filtered.fastq.gz / CL13"

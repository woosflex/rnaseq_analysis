# A General Purpose RNA-seq Preprocessing Pipeline (Shell Version)

This repository provides a streamlined and automated shell script for preprocessing raw RNA-seq reads. It is built using a robust combination of **FastQC** for quality control and **fastp** for high-performance adapter and quality trimming.

This shell script version is fully functional and serves as a lightweight solution for smaller-scale analyses on a local machine or single server.

## Project Status & Future Vision

**This script is a complete and stable implementation of the preprocessing stage (QC and trimming).** The function definitions and command-line options are in place to extend it into a full quantification pipeline.

The future vision is to re-implement this proven logic in **Nextflow**, a powerful workflow manager. This transition will provide massive scalability, reproducibility, and error-handling capabilities. The development of the Nextflow version will occur on a separate branch.

## Features

* **Automated Workflow:** Run the entire preprocessing pipeline with a single command.
* **Initial Quality Control:** Generates FastQC reports for raw FASTQ files to assess initial data quality.
* **High-Performance Trimming:** Uses `fastp` to efficiently remove adapters and low-quality bases.
* **Robust File Handling:** Automatically finds all FASTQ files (`.fastq` or `.fastq.gz`) using precise `extglob` patterns.
* **Future-Proofed:** The script is structured with options to easily integrate quantification tools like Kallisto.
* **Scalable:** Designed to process large batches of samples by leveraging multiple CPU threads on a single machine.

## Project Structure

The script will generate the following directory structure for its output:
```
.
├── data/             # Your raw FASTQ files
├── environment.yml   # Conda environment definition
├── reference/        # Your reference transcriptome and/or pre-built Kallisto index
├── 01_trimmed_reads/ # fastp-filtered FASTQ files
├── 02_kallisto_quant/  # (Future) Kallisto quantification results
├── 03_reports/       # All QC reports from fastp, FastQC, etc.
└── run_analysis.sh   # The main pipeline shell script
```

## Usage

### Step 1: Setup

First, clone this repository and create the Conda environment.

```bash
# Clone the repository
git clone [https://github.com/woosflex/rnaseq_analysis.git](https://github.com/woosflex/rnaseq_analysis.git)
cd rnaseq_analysis

# Create and activate the conda environment
conda env create -f environment.yml
conda activate rnaseq_analysis
```

### Step 2: Prepare Your Data
1. Place your raw FASTQ files (`.fastq` or `.fastq.gz`) inside the data/ directory.
2. (Optional) Place your reference transcriptome files or pre-built Kallisto index into the reference/ directory for the future quantification step.

### Step 3: Run the Pipeline
Execute the main script, providing the path to your data directory.
```bash
# Give the script execute permissions
chmod +x run_analysis.sh

# Example: Run the preprocessing steps on all samples using 8 threads
./run_analysis.sh -i data/ -t 8
```

## Pipeline Workflow
The run_analysis.sh script currently automates the following steps:

1. Initial QC (run_fastqc): Runs FastQC on all raw FASTQ files to generate initial quality metrics.
2. Read Trimming (run_fastp): Removes adapters and filters low-quality reads using fastp, generating cleaned FASTQ files and per-sample HTML/JSON reports.

## Future Implementation
The script includes placeholder options and is designed to be extended with:

- Kallisto Indexing: Using the -b and -f flags to build a quantification index.
- Kallisto Quantification: Using the -x flag to perform pseudoalignment on the trimmed reads.
- MultiQC Reporting: Aggregating all logs and reports into a single interactive HTML file.

## Citation
If you use this pipeline in your research, please cite the original tools:

- **fastp:** Shifu Chen, Yanqing Zhou, Yaru Chen, Jia Gu, fastp: an ultra-fast all-in-one FASTQ preprocessor, Bioinformatics, Volume 34, Issue 17, September 2018, Pages i884–i890, [https://doi.org/10.1093/bioinformatics/bty560](https://doi.org/10.1093/bioinformatics/bty560)

- **FastQC:** Andrews, S. (2010). FastQC: A Quality Control Tool for High Throughput Sequence Data. [http://www.bioinformatics.babraham.ac.uk/projects/fastqc](http://www.bioinformatics.babraham.ac.uk/projects/fastqc)

- **Kallisto:** Nicolas L Bray, Harold Pimentel, Páll Melsted and Lior Pachter, Near-optimal probabilistic RNA-seq quantification, Nature Biotechnology 34, 525–527 (2016), [https://doi.org/10.1038/nbt.3519](https://doi.org/10.1038/nbt.3519)

- **MultiQC:** Philip Ewels, Måns Magnusson, Sverker Lundin and Max Käller, MultiQC: Summarize analysis results for multiple tools and samples in a single report, Bioinformatics (2016), [https://doi.org/10.1093/bioinformatics/btw354](https://doi.org/10.1093/bioinformatics/btw354).

## Maintainer
Developed and maintained by Adnan Raza [https://www.github.com/woosflex](@woosflex).
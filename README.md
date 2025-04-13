# RNA-seq Pipeline for Cutaneous Leishmaniasis vs Healthy Controls

This repository contains a complete RNA-seq preprocessing and alignment pipeline built using **FASTP**, **FASTQC**, **Kallisto**, and **MultiQC**. The dataset consists of RNA-seq reads from human samples: cutaneous leishmaniasis (CL) patients and healthy controls (HS).

---

## Directory Structure
```
. 
├── index/ # Reference transcriptome and kallisto index 
├── kallisto_output/ # Output of Kallisto quantification per sample 
├── multiqc_data/ # Intermediate MultiQC data files 
├── multiqc_report.html # Interactive MultiQC HTML report 
├── processed_fastq/ # FASTP-filtered FASTQ files 
├── qc_output/ # FASTP and FASTQC reports (JSON, HTML, ZIP) 
├── raw_fastq/ # Original downloaded FASTQ files 
├── scripts/ # All shell scripts for running the pipeline 
├── studydesign.txt # Sample-to-condition mapping 
└── analysis/ # (To be added) Downstream R notebooks/scripts
```

---

## Installation

1. **Clone the repository** 

```bash
git clone https://github.com/woosflex/rnaseq_analysis.git
cd rnaseq_analysis
```

2. **Set up the conda environment**

```bash
# Create a conda environment from the YAML file
conda env create -f environment.yml

# Activate the environment
conda activate rnaseq_environment.yml
```

3. **Dependencies**

- fastqc
- fastp
- kallisto
- multiqc
- conda

If not using conda, you may install the above via `brew`, `apt`, or `pip` where appropriate.

## Pipeline Overview
All steps are automated using shell scripts in the scripts/ folder.

1. **Raw Data Quality Control**

```bash
bash scripts/run_fastqc_raw.sh
```
2. **Trimming & Filtering**

```bash
bash scripts/run_fastp.sh
```

3. **Post-filtering Quality Control**

```bash
bash scripts/run_fastqc_processed.sh
```

4. **Create index**

```bash
kallisto index -i "index file name" "Reference cDNA path"
```

5. **Transcript Quantification using Kallisto**

```bash
bash scripts/align_reads.sh
```

6. **Quality Summary with MultiQC**

```bash
multiqc . -o multiqc_data
```
## Downstream Analysis (R Notebooks)
*Directory*: `analysis/` (to be added)

This folder will contain scripts and notebooks for:

- Exploratory Data Analysis (EDA)

- PCA and clustering

- Differential Expression using `limma-voom` and `edgeR`

- Functional enrichment analysis (GO, KEGG)

- Visualizations (heatmaps, volcano plots, etc.)

Notebooks will be written in R and based on processed Kallisto outputs (abundance.h5) and sample metadata (studydesign.txt).

## Sample Info

Sample types are split into:
- `HSxx`: Healthy control subjects
- `CLxx`: Cutaneous leishmaniasis patients

Check `studydesign.txt` for mapping between SRA accessions and experimental conditions.

## Example Output Files
- `qc_output/`: Quality metrics in .html, .json, .zip format for both raw and filtered FASTQ files
- `kallisto_output/`: Gene expression quantifications (abundance.tsv, .h5) and logs
- `multiqc_report.html`: Aggregated QC report

## License
This project is open-source and available under the MIT License.

## Citation
If you use this pipeline in your research, please cite the tools involved:
- FASTP: Chen et al. (2018)
- FASTQC: Andrews (2010)
- Kallisto: Bray et al. (2016)
- MultiQC: Ewels et al. (2016)

## Maintainer
Developed and maintained by Adnan Raza ([woosflex](https://www.github.com/woosflex)) for educational and research use.
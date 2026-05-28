# Bash for Genomics

Bash scripts documenting essential command-line skills for bioinformatics —
from file navigation and text manipulation to automated genomics workflows.
Examples are grounded in real genomics tasks: processing FASTA/FASTQ files,
filtering annotation tables, and running QC pipelines.

---

## Motivation

Bash is the primary interface for running bioinformatics tools on Linux/HPC
environments. Proficiency in shell scripting is essential for automating
repetitive tasks, processing large datasets, and building reproducible
analysis pipelines — including pangenome construction workflows that require
batch processing of multiple genome assemblies.

---

## Repository structure

```
bash-for-genomics/
│
├── 01_basics/
│   └── 01_bash_basics.sh            # navigation, variables, loops, conditionals
│
├── 02_file_handling/
│   └── 02_file_handling.sh          # grep, awk, sed, cut, sort, uniq on genomics files
│
└── 03_genomics_workflows/
    ├── 03_fasta_fastq_handling.sh   # sequence counting, batch processing, log files
    └── 04_busco_pipeline.sh         # automated BUSCO completeness assessment (single & batch)
```

---

## Scripts overview

| Script | Topic | Key commands |
|--------|-------|-------------|
| `01_bash_basics.sh` | Navigation & control flow | `cd`, `mkdir`, `cp`, `for`, `if`, variables |
| `02_file_handling.sh` | Text file manipulation | `grep`, `awk`, `sed`, `cut`, `sort`, `uniq` |
| `03_fasta_fastq_handling.sh` | Sequence file operations | `grep`, `awk`, `wc`, `gunzip`, batch loops |
| `04_busco_pipeline.sh` | Genome QC pipeline | `busco`, batch automation, log generation |

---

## Biological context

Scripts are designed around real genomics file formats and tasks:

- **FASTA handling** — extracting headers, calculating sequence lengths, batch
  processing multiple genome assemblies (standard input for pangenome tools)
- **GFF/TSV filtering** — extracting gene features, filtering by type or
  coordinates using `awk` — equivalent to post-processing outputs from MAKER,
  BRAKER, or Minigraph-Cactus
- **BUSCO pipeline** — automated completeness assessment with batch mode for
  multiple accessions; in pangenome workflows, BUSCO QC is run on every genome
  before graph construction to ensure input quality
- **Log files** — timestamped logs for reproducibility, a requirement for
  FAPESP-funded project documentation

---

## How to run

```bash
# Make scripts executable
chmod +x 01_basics/01_bash_basics.sh

# Run a script
bash 01_basics/01_bash_basics.sh

# Run BUSCO pipeline in batch mode
bash 03_genomics_workflows/04_busco_pipeline.sh --batch
```

Scripts are designed to be read and adapted — each section is self-contained
and documented with the biological context of each command.

---

## Dependencies

- Bash ≥ 4.0 (standard on Linux/macOS)
- `busco` v5+ (for `04_busco_pipeline.sh` only) — install via conda:
  ```bash
  conda install -c bioconda busco
  ```

---

## Author

**Isis Sebastião** — Agronomist | PhD in Biotechnology | Plant Genomics & Bioinformatics  
[![ORCID](https://img.shields.io/badge/ORCID-0000--0002--1596--2523-green)](https://orcid.org/0000-0002-1596-2523)
[![Lattes](https://img.shields.io/badge/Lattes-CNPq-blue)](http://lattes.cnpq.br/5220007563821018)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-isis--sebastiao-blue)](https://www.linkedin.com/in/isis-sebastiao/)

- **Log files** — timestamped logs for reproducibility, a requirement for
  FAPESP-funded project documentation

---

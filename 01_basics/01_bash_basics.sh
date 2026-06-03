#!/usr/bin/env bash
# =============================================================================
# Script: 01_bash_basics.sh
# Author: Isis Sebastião
# Description: Essential Bash commands for bioinformatics — navigation,
#              variables, loops, and conditionals applied to genomics contexts.
# =============================================================================

# =============================================================================
# PART 1: Navigation and file system
# =============================================================================

# Print current directory
pwd

# Move between directories
cd /path/to/project
cd ..          # go one level up
cd ~           # go to home directory
cd -           # go back to previous directory

# List files
ls             # basic listing
ls -l          # detailed (permissions, size, date)
ls -lh         # human-readable sizes (KB, MB, GB)
ls -lh *.fastq # list only FASTQ files

# Create and remove directories
mkdir results
mkdir -p results/assembly/busco    # create nested directories at once
rmdir empty_folder                 # remove empty directory
rm -r old_results/                 # remove directory and contents (careful!)

# Copy and move files
cp genome.fasta backup/genome.fasta
mv sample_01.fastq raw_reads/sample_01.fastq

# =============================================================================
# PART 2: Variables
# =============================================================================

# Assign variables (no spaces around =)
SAMPLE="Arabidopsis_Col0"
THREADS=8
GENOME="TAIR10.fasta"
OUTPUT_DIR="results/assembly"

# Use variables with $
echo "Processing sample: $SAMPLE"
echo "Using $THREADS threads"
echo "Reference genome: $GENOME"

# Combine variables in a path
mkdir -p "$OUTPUT_DIR/$SAMPLE"
echo "Output will be saved to: $OUTPUT_DIR/$SAMPLE"

# Command substitution: store command output in a variable
DATE=$(date +%Y-%m-%d)
echo "Analysis started on: $DATE"

N_READS=$(grep -c "^>" sequences.fasta 2>/dev/null || echo "file not found")
echo "Number of sequences: $N_READS"

# =============================================================================
# PART 3: For loops — iterating over samples
# =============================================================================

# Loop over a list of sample names
SAMPLES=("ctrl_1" "ctrl_2" "treat_1" "treat_2")

for SAMPLE in "${SAMPLES[@]}"; do
    echo "Processing: $SAMPLE"
    mkdir -p "results/$SAMPLE"
done

# Loop over files matching a pattern
for FASTA in data/*.fasta; do
    BASENAME=$(basename "$FASTA" .fasta)
    echo "Found genome: $BASENAME"
done

# Loop with a numeric range (e.g., 3 replicates per condition)
for i in {1..3}; do
    echo "Replicate $i"
done

# =============================================================================
# PART 4: Conditionals
# =============================================================================

GENOME="TAIR10.fasta"

# Check if a file exists before running an analysis
if [ -f "$GENOME" ]; then
    echo "Genome file found: $GENOME"
else
    echo "ERROR: genome file not found — $GENOME"
    exit 1   # stop the script with an error code
fi

# Check if a directory exists
if [ -d "results/" ]; then
    echo "Results directory already exists."
else
    mkdir -p results/
    echo "Created results directory."
fi

# Compare numbers (e.g., minimum coverage check)
COVERAGE=25
MIN_COVERAGE=20

if [ "$COVERAGE" -ge "$MIN_COVERAGE" ]; then
    echo "Coverage OK: ${COVERAGE}x (minimum: ${MIN_COVERAGE}x)"
else
    echo "WARNING: low coverage — ${COVERAGE}x"
fi

# =============================================================================
# PART 5: Useful one-liners
# =============================================================================

# Count files in a directory
echo "Number of FASTQ files: $(ls data/*.fastq 2>/dev/null | wc -l)"

# Print disk usage of a folder
du -sh results/

# Show only the filename without path or extension
FILEPATH="/data/genomes/arabidopsis.fasta"
FILENAME=$(basename "$FILEPATH")        # arabidopsis.fasta
BASENAME=$(basename "$FILEPATH" .fasta) # arabidopsis
echo "$BASENAME"

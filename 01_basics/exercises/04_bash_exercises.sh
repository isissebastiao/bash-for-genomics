#!/usr/bin/env bash
# =============================================================================
# Script: 04_bash_exercises.sh
# Author: Isis Sebastião
# Description: Bash exercises aiming to consolidate essential commands for bioinformatics.
#              Separated by level of difficulty.
# =============================================================================

# =============================================================================
# Motivation: To reinforce my bash training and to practice the commands in a more practical way.
#             I will create a bash script with exercises that I can run and test my knowledge. 
#             The exercises will cover navigation, variables, loops, and conditionals, and will be related to genomics 
#             contexts.
# =============================================================================

# =============================================================================
#             Basic level:
# =============================================================================
# You are starting a new pangenome project with five accessions of Arabidopsis thaliana.
# Create a complet structure of directory using a unique command, including a root directory called project/ and 
# subdirectories data/genomes/, data/reads/, results/busco/, results/graphs/ e logs/.

# Create directory and subdirectories for the pangenome project using bash commands
mkdir -p pangenome_project/{data/{genomes,reads},results/{busco,graphs},logs}
# navigate to the root folder
cd ~ # go to home directory
# check if the structure was created using the ls command
ls -R pangenome_project # -R to list all subfolders and files recursively

# =============================================================================
#           Intermediate level:
# =============================================================================

# You have 4 RNA-seq samples: RNA-seq: ctrl_1, ctrl_2, treat_1, treat_2.
# Write a loop that creates a results folder for each sample into results/rnaseq/, and print a message confirming 
# that creation. 

# Create an array containing the sample names
rna_seq=("ctrl_1" "ctrl_2" "treat_1" "treat_2")
# use a for loop to iterate over the array and create folders for each sample
for sample in "${rna_seq[@]}"; do
    mkdir -p results/rnaseq/"$sample"
    echo "Folder results/rnaseq/$sample was created"
done

# =============================================================================
#           Advanced level:
# =============================================================================
# (1) Define variables for input genome, threads and output directory;
# (2) Check if the genome file exists - if not, print an error message and exit; 
# (3) Check if the output directory exists - if not, create it and print a creation message;
# (4) Print a summary of the configurations before starting.

# Define variables  
GENOME="TAIR12.fasta" # input genome file
THREADS=4 # number of threads to use
OUTPUT_DIR="results/assembly" # output directory
# Check if genome file exists
if [ ! -f "$GENOME" ]; then # -f checks if the file exists and is a regular file
    echo "Error: Genome file $GENOME not found!"
    exit 1
fi
# Check if output directory exists, if not create it
if [ ! -d "$OUTPUT_DIR" ]; then # -d checks if the directory exists
    mkdir -p "$OUTPUT_DIR"
    echo "Output directory $OUTPUT_DIR created."
fi
# Print summary of configurations
echo "Configuration summary:"
echo "Genome file: $GENOME"
echo "Threads: $THREADS"
echo "Output directory: $OUTPUT_DIR"
echo "Date: $(date +%Y-%m-%d)"

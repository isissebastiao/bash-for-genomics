#!/usr/bin/env bash
# =============================================================================
# Script: 02_file_handling.sh
# Author: Isis Sebastião
# Description: Text file manipulation for bioinformatics — grep, awk, sed,
#              cut, sort, and uniq applied to FASTA, GFF, VCF, and TSV files.
# =============================================================================

# =============================================================================
# PART 1: Inspecting files
# =============================================================================

# View beginning and end of a file
head -5 genome.fasta          # first 5 lines
tail -10 results.tsv          # last 10 lines

# Count lines, words, characters
wc -l annotation.gff          # number of lines
wc -l *.fastq                 # count lines across multiple files

# Display file size
ls -lh genome.fasta
du -sh genome.fasta

# =============================================================================
# PART 2: grep — searching inside files
# =============================================================================

# Count sequences in a FASTA file (each sequence starts with >)
grep -c "^>" genome.fasta

# Extract all sequence headers
grep "^>" genome.fasta

# Search for a gene ID in a GFF annotation file
grep "AT1G01010" annotation.gff

# Case-insensitive search
grep -i "transposable element" annotation.gff

# Invert match: show lines that do NOT contain a pattern
grep -v "^#" annotation.gff     # exclude comment/header lines (common in VCF/GFF)

# Show line numbers of matches
grep -n "CDS" annotation.gff | head

# Extract lines matching a list of gene IDs from a file
# (useful for filtering DESeq2 results)
grep -Ff significant_genes.txt all_annotations.tsv > significant_annotations.tsv

# =============================================================================
# PART 3: cut — extracting columns from tabular files
# =============================================================================

# Extract specific columns from a TSV file
# Example: GFF file — extract chromosome (col 1), feature type (col 3), start (col 4), end (col 5)
grep -v "^#" annotation.gff | cut -f1,3,4,5

# Extract gene IDs from a DESeq2 results file (column 1)
cut -f1 deseq2_results.tsv | tail -n +2   # skip header with tail

# Extract columns 1 and 2 from a comma-separated file
cut -d',' -f1,2 metadata.csv

# =============================================================================
# PART 4: awk — column-based filtering and calculations
# =============================================================================

# Print only lines where the 3rd column is "gene" (GFF feature type)
awk '$3 == "gene"' annotation.gff

# Filter DESeq2 results: log2FC > 1 AND padj < 0.05
# Assumes: col1=gene_id, col3=log2FC, col6=padj
awk 'NR==1 || ($3 > 1 && $6 < 0.05)' deseq2_results.tsv > upregulated.tsv

# Calculate gene length from GFF (end - start + 1)
awk '$3 == "gene" {print $1, $4, $5, $5-$4+1}' annotation.gff | head

# Count features per chromosome
awk '$3 == "gene" {count[$1]++} END {for (chr in count) print chr, count[chr]}' \
    annotation.gff | sort

# Print lines where a numeric column exceeds a threshold
awk '$4 >= 30' coverage.tsv     # minimum 30x coverage

# =============================================================================
# PART 5: sed — find and replace in files
# =============================================================================

# Replace a string in a file (print result to screen)
sed 's/Chr/chromosome/g' genome.fasta | head

# Replace and save to a new file
sed 's/Chr/chromosome/g' genome.fasta > genome_renamed.fasta

# Remove empty lines from a file
sed '/^$/d' annotation.gff > annotation_clean.gff

# Remove lines starting with # (comment lines in VCF/GFF)
sed '/^#/d' variants.vcf > variants_no_header.vcf

# Add a prefix to FASTA sequence headers
# Before: >scaffold_1  →  After: >Athaliana_scaffold_1
sed 's/^>/&Athaliana_/' genome.fasta | head

# =============================================================================
# PART 6: sort and uniq — summarizing data
# =============================================================================

# Sort a file alphabetically
sort gene_list.txt

# Sort numerically by column 2 (e.g., expression values), descending
sort -k2,2 -rn expression.tsv | head -20

# Count unique chromosomes in a GFF file
grep -v "^#" annotation.gff | cut -f1 | sort | uniq -c | sort -rn

# Extract unique gene IDs from a list
cut -f1 results.tsv | sort -u

# =============================================================================
# PART 7: Redirecting output
# =============================================================================

# Write output to a file (overwrites)
grep "^>" genome.fasta > headers.txt

# Append output to an existing file
echo "Analysis completed: $(date)" >> run_log.txt

# Pipe: chain commands together
grep -v "^#" annotation.gff | awk '$3 == "gene"' | cut -f1,4,5 | sort -k1,1 > genes.bed

# Discard error messages (stderr)
bowtie2 -x index -U reads.fastq -S output.sam 2>/dev/null

# Save both stdout and stderr to a log file
busco -i genome.fasta -o busco_results -l embryophyta_odb10 > busco.log 2>&1

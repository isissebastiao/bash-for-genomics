#!/usr/bin/env bash
# =============================================================================
# Script: bash_exercises_file_handling.sh
# Author: Isis Sebastião
# Description: Bash exercises aiming to consolidate essential commands for text file manipulation 
#              for bioinformatics. 
#              Separeted by level of difficultty.
# =============================================================================

# =============================================================================
# Motivation: To reinofroce my bash training and to practice the commands in a more practical way.
#             I will create a bash script with exercises that I can run and test my knowledge. 
#             The exercises will cover the use of grep, awk, sed, cut, sort, 
#             and uniq applied to FASTA, GFF, VCF, and TSV files.
# =============================================================================

# =============================================================================
#             Basic level:
# =============================================================================


#  You have a annotation.gff file of a genomic assembly. 
# Without opening the file in any editor, indentify:

# How many lines is there in the file?
wc -l annotation.gff
# How many lines are comments (start with #)?
grep -c "^#" annotation.gff
# What types of features exist (column 3)?
grep -v "^#" annotation.gff | cut -f3 | sort -u
# How many are of type gene?
awk '$3 == "gene"' annotation.gff | wc -l

# =============================================================================
#             Intermediate level:
# =============================================================================

# You have a file called deseq2_results.tsv with columns: gene_id (1), baseMean (2),
# log2FC (3), lfcSE (4), stat (5), pvalue (6), padj (7). 
# Extract only the significantly upregulated genes (log2FC > 1 and padj < 0.05), 
# keeping the header, and save to upregulated.tsv.
awk 'NR==1 || ($3 > 1 && $7 < 0.05)' deseq2_results.tsv > upregulated.tsv
wc -l upregulated.tsv # check how many upregulated genes were extracted (minus 1 for header)

# =============================================================================
#             Advanced level:
# =============================================================================

# All headers in the genome.fasta file need to follow the format >Species_chromosome.
# The file has headers like >Chr1, >Chr2.
# Rename them to >Athaliana_Chr1, >Athaliana_Chr2, and save to genome_renamed.fasta, then confirm the changes.

grep "^>" genome.fasta # check original headers
sed 's/^>/>Athaliana_/' genome.fasta > genome_renamed.fasta # rename headers using sed and save to new file
grep "^>" genome_renamed.fasta # check new headers to confirm changes
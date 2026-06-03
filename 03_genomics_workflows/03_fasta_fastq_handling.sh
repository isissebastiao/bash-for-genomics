#!/usr/bin/env bash
# =============================================================================
# Script: 03_fasta_and_fastq_handling.sh
# Author: Isis Sebastião
# Description: Common Bash operations on FASTA and FASTQ files — sequence
#              counting, header extraction, file splitting, and basic
#              quality checks. No external tools required (pure Bash + awk).
# =============================================================================

# =============================================================================
# PART 1: FASTA file inspection
# =============================================================================

FASTA="genome.fasta"

# Count number of sequences
echo "Number of sequences:"
grep -c "^>" "$FASTA"

# List all sequence headers
echo "Sequence headers:"
grep "^>" "$FASTA"

# Extract only sequence names (remove the > symbol)
grep "^>" "$FASTA" | sed 's/^>//'

# Get the length of each sequence using awk
awk '/^>/{if (seq) print name, length(seq); name=$0; seq=""}
     !/^>/{seq=seq$0}
     END{if (seq) print name, length(seq)}' "$FASTA"

# Extract a single sequence by name
# (replace "Chr1" with your target sequence name)
awk '/^>Chr1/{flag=1} flag; /^>/ && !/^>Chr1/{flag=0}' "$FASTA"

# =============================================================================
# PART 2: FASTQ file inspection
# =============================================================================

FASTQ="sample_R1.fastq"

# Count number of reads (each read = 4 lines in FASTQ)
echo "Number of reads:"
echo $(( $(wc -l < "$FASTQ") / 4 ))

# View the first read (4 lines)
head -4 "$FASTQ"

# Check if file is compressed (.fastq.gz) — decompress on the fly
if [[ "$FASTQ" == *.gz ]]; then
    N_READS=$(( $(zcat "$FASTQ" | wc -l) / 4 ))
else
    N_READS=$(( $(wc -l < "$FASTQ") / 4 ))
fi
echo "Total reads: $N_READS"

# =============================================================================
# PART 3: Batch processing multiple FASTA/FASTQ files
# =============================================================================

echo "=== Genome sizes ==="
for FASTA in data/genomes/*.fasta; do
    NAME=$(basename "$FASTA" .fasta)
    N_SEQ=$(grep -c "^>" "$FASTA")
    TOTAL_BP=$(grep -v "^>" "$FASTA" | tr -d '\n' | wc -c)
    echo "$NAME: $N_SEQ sequences, $TOTAL_BP bp total"
done

echo ""
echo "=== Read counts per sample ==="
for FASTQ in data/reads/*.fastq; do
    NAME=$(basename "$FASTQ" .fastq)
    N=$(( $(wc -l < "$FASTQ") / 4 ))
    echo "$NAME: $N reads"
done

# =============================================================================
# PART 4: Renaming and organizing files
# =============================================================================

# Rename files: replace spaces with underscores (common issue with Windows files)
for FILE in data/*; do
    NEW_NAME=$(echo "$FILE" | tr ' ' '_')
    [ "$FILE" != "$NEW_NAME" ] && mv "$FILE" "$NEW_NAME"
done

# Add a prefix to all FASTA files in a directory
for FASTA in raw/*.fasta; do
    NAME=$(basename "$FASTA")
    cp "$FASTA" "processed/Athaliana_${NAME}"
done

# Decompress all .gz files in a directory
for GZ in data/*.fastq.gz; do
    echo "Decompressing: $GZ"
    gunzip "$GZ"
done

# =============================================================================
# PART 5: Writing log files — tracking your analyses
# =============================================================================

LOG="run_$(date +%Y%m%d_%H%M%S).log"

echo "=== Analysis Log ===" > "$LOG"
echo "Date: $(date)" >> "$LOG"
echo "User: $(whoami)" >> "$LOG"
echo "Directory: $(pwd)" >> "$LOG"
echo "" >> "$LOG"

for FASTA in data/*.fasta; do
    NAME=$(basename "$FASTA" .fasta)
    N=$(grep -c "^>" "$FASTA")
    echo "$NAME: $N sequences" >> "$LOG"
    echo "  Processed: $NAME ($N sequences)"
done

echo "Log saved to: $LOG"

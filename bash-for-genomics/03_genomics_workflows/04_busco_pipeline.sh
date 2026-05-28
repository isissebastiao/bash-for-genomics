#!/usr/bin/env bash
# =============================================================================
# Script: 04_busco_pipeline.sh
# Author: Isis Sebastião
# Description: Automated BUSCO genome completeness assessment pipeline.
#              Runs BUSCO for one or multiple genome assemblies and summarizes
#              results. BUSCO is a standard QC step in genome assembly and
#              pangenome construction workflows.
#
# Dependencies: busco (v5+), conda or module system
# BUSCO docs: https://busco.ezlab.org/
#
# Usage:
#   bash 04_busco_pipeline.sh                 # single genome
#   bash 04_busco_pipeline.sh --batch         # all genomes in data/genomes/
# =============================================================================

# --- Configuration -----------------------------------------------------------

LINEAGE="embryophyta_odb10"     # BUSCO lineage dataset (plant genomes)
                                # Other options: fungi_odb10, bacteria_odb10
                                # Full list: busco --list-datasets
THREADS=8
MODE="genome"                   # genome | transcriptome | proteins
OUTPUT_DIR="results/busco"
mkdir -p "$OUTPUT_DIR"

# --- Single genome -----------------------------------------------------------

GENOME="data/genomes/arabidopsis_TAIR10.fasta"
SAMPLE=$(basename "$GENOME" .fasta)

echo "Running BUSCO for: $SAMPLE"
echo "Lineage: $LINEAGE"
echo "Threads: $THREADS"
echo ""

busco \
    --in "$GENOME" \
    --out "${OUTPUT_DIR}/${SAMPLE}" \
    --lineage_dataset "$LINEAGE" \
    --mode "$MODE" \
    --cpu "$THREADS" \
    --force \
    > "${OUTPUT_DIR}/${SAMPLE}.log" 2>&1

echo "Done. Log: ${OUTPUT_DIR}/${SAMPLE}.log"

# --- Batch mode: run BUSCO for all genomes in a directory -------------------

if [[ "$1" == "--batch" ]]; then

    echo "=== Batch mode: running BUSCO for all genomes ==="

    for GENOME in data/genomes/*.fasta; do

        SAMPLE=$(basename "$GENOME" .fasta)
        echo ""
        echo "[$SAMPLE] Starting BUSCO..."

        busco \
            --in "$GENOME" \
            --out "${OUTPUT_DIR}/${SAMPLE}" \
            --lineage_dataset "$LINEAGE" \
            --mode "$MODE" \
            --cpu "$THREADS" \
            --force \
            > "${OUTPUT_DIR}/${SAMPLE}.log" 2>&1

        # Check if BUSCO finished successfully
        if grep -q "Results:" "${OUTPUT_DIR}/${SAMPLE}.log"; then
            echo "[$SAMPLE] Completed successfully."
        else
            echo "[$SAMPLE] WARNING: possible error — check log."
        fi

    done

    # --- Summarize all results -----------------------------------------------

    SUMMARY="${OUTPUT_DIR}/busco_summary_all.txt"
    echo "" > "$SUMMARY"
    echo "=== BUSCO Summary Report ===" >> "$SUMMARY"
    echo "Date: $(date)" >> "$SUMMARY"
    echo "Lineage: $LINEAGE" >> "$SUMMARY"
    echo "" >> "$SUMMARY"

    for LOG in "${OUTPUT_DIR}"/*.log; do
        SAMPLE=$(basename "$LOG" .log)
        RESULT=$(grep "C:" "$LOG" | tail -1)
        echo "$SAMPLE: $RESULT" >> "$SUMMARY"
    done

    echo ""
    echo "=== Summary ==="
    cat "$SUMMARY"
    echo ""
    echo "Full summary saved to: $SUMMARY"

fi

# =============================================================================
# BUSCO output interpretation:
#
# C:98.1%[S:96.4%,D:1.7%],F:0.9%,M:1.0%,n:1614
#
# C = Complete BUSCOs (target: >90%)
#   S = Complete & Single-copy
#   D = Complete & Duplicated (may indicate assembly artifacts)
# F = Fragmented BUSCOs
# M = Missing BUSCOs
# n = Total BUSCOs in the dataset
#
# In pangenome contexts, BUSCO is run on each accession's assembly
# before graph construction to ensure all inputs meet quality thresholds.
# =============================================================================

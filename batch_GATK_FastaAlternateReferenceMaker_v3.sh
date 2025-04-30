#!/bin/bash

# Function to show usage message
usage() {
    echo "Usage: $0 -i <input_directory> -b <bed_file> -o <output_directory>"
    exit 1
}

# Parse command-line options
while getopts ":i:b:o:" opt; do
    case $opt in
        i) input_dir="$OPTARG" ;;
        b) bed_file="$OPTARG" ;;
        o) output_dir="$OPTARG" ;;
        \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
        :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
    esac
done

# Check if required options are provided
if [ -z "$input_dir" ] || [ -z "$bed_file" ] || [ -z "$output_dir" ]; then
    echo "Missing required options."
    usage
fi

# Check if input directory exists
if [ ! -d "$input_dir" ]; then
    echo "Input directory not found: $input_dir"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Iterate over all .vcf files in the input directory
for vcf_file in "$input_dir"/*.vcf; do
    # Index VCF file
    java -jar /usr/local/packages/gatk-4.2.2.0/gatk-package-4.2.2.0-local.jar IndexFeatureFile -I "$vcf_file"

    # Check if indexing succeeded
    if [ $? -ne 0 ]; then
        echo "Error indexing VCF file: $vcf_file"
        continue
    else
        echo "VCF file indexed: $vcf_file"
    fi

    # Extract filename without path
    filename=$(basename -- "$vcf_file")
    filename_no_ext="${filename%.recode.vcf}"

    # Define output FASTA file name
    output_fasta="$output_dir/${filename_no_ext}.fasta"

    # Run FastaAlternateReferenceMaker
    java -jar /usr/local/packages/gatk-4.2.2.0/gatk-package-4.2.2.0-local.jar FastaAlternateReferenceMaker \
    -R /local/projects-t3/p_falciparum/ryan.scalsky/Thesis/MalariaGen_Samples/Reference_based_reconstruction/Reference_FASTA_genome/Pfalciparum.genome.fasta \
    -O "$output_fasta" \
    -L "$bed_file" \
    -V "$vcf_file"

    # Check if GATK command succeeded
    if [ $? -ne 0 ]; then
        echo "Error processing VCF file: $vcf_file"
    else
        echo "FASTA file created: $output_fasta"
    fi
done


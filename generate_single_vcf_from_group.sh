#!/bin/bash

input_txt="$1"      # Input text file with subject IDs (i.e. index file)
input_vcf_dir="$2"  # Input directory containing VCF files
output_dir="$3"     # Output directory

# Check if the required arguments are provided
if [ -z "$input_txt" ] || [ -z "$input_vcf_dir" ] || [ -z "$output_dir" ]; then
    echo "Usage: $0 <input_txt> <input_vcf_dir> <output_dir>"
    exit 1
fi

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Loop through each subject ID in the input text file
while IFS= read -r subject_ID
do
    # Remove any trailing newline characters
    subject_ID=$(echo "$subject_ID" | tr -d '\r')

    # Loop through each VCF file in the input directory
    for input_vcf in "$input_vcf_dir"/*.vcf
    do
        # Get the base name of the input VCF file (excluding extension)
        input_vcf_base=$(basename "$input_vcf" .recode.vcf)

        # Generate the output VCF file name based on input_vcf name and subject ID
        output_vcf="${output_dir}/${input_vcf_base}_${subject_ID}"

        # Use vcftools to extract the VCF for the current subject ID
        vcftools --vcf "$input_vcf" --keep <(echo "$subject_ID") --recode --out "$output_vcf"

        echo "Created VCF for $subject_ID from $input_vcf: $output_vcf"
    done
done < "$input_txt"

echo "All VCF files created in $output_dir"


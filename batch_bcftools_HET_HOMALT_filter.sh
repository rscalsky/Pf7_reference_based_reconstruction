#!/bin/bash

# Parse command line arguments
while getopts ":i:o:" opt; do
  case $opt in
    i) input_dir="$OPTARG";;
    o) output_dir="$OPTARG";;
    \?) echo "Invalid option: -$OPTARG" >&2;;
  esac
done

# Check if both input and output directories are provided
if [ -z "$input_dir" ] || [ -z "$output_dir" ]; then
  echo "Usage: $0 -i input_dir -o output_dir" >&2
  exit 1
fi

# Loop through input directory
for input_file in "$input_dir"/*.vcf; do
  if [ -e "$input_file" ]; then
    # Compress VCF file
    yes | bgzip "$input_file"

    # Index compressed VCF file
    bcftools index "$input_file.gz"

    # Define output file name
    output_file="$output_dir/$(basename -- "$input_file" .recode.vcf)_HET_and_HOM_alt_only.recode.vcf"

    # Run bcftools command
    bcftools view -i 'GT="0/1" || GT="1/0" || GT="1/1"' "$input_file.gz" > "$output_file"

    echo "Processed: $input_file.gz -> $output_file"
  else
    echo "No files found in $input_dir" >&2
    exit 1
  fi
done


#!/bin/bash

# Check if correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_vcf> <output_vcf>"
    exit 1
fi

# Assign input and output file names
input_vcf="$1"
output_vcf="$2"

# Check if input VCF file exists
if [ ! -f "$input_vcf" ]; then
    echo "Input VCF file not found: $input_vcf"
    exit 1
fi

# Filter VCF file using bcftools
bcftools view -f PASS "$input_vcf" -o "$output_vcf"

# Check if bcftools command succeeded
if [ $? -ne 0 ]; then
    echo "Error filtering VCF file"
    exit 1
fi

echo "Filtered VCF file created: $output_vcf"


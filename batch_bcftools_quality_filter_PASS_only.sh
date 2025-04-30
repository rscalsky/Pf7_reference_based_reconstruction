#!/bin/bash

# Check if bcftools is installed
if ! command -v bcftools &> /dev/null; then
    echo "bcftools not found. Please install bcftools."
    exit 1
fi

# Iterate over all .vcf files in the current directory
for input_vcf in *.vcf; do
    # Check if the file is a regular file
    if [ -f "$input_vcf" ]; then
        # Extract filename without extension
        filename=$(basename -- "$input_vcf")
        filename_no_ext="${filename%.vcf}"
        
        # Define output VCF file name
        output_vcf="${filename_no_ext}_pass_only.recode.vcf"
        
        # Filter VCF file using bcftools
        bcftools view -f PASS "$input_vcf" -o "$output_vcf"
        
        # Check if bcftools command succeeded
        if [ $? -ne 0 ]; then
            echo "Error filtering VCF file: $input_vcf"
        else
            echo "Filtered VCF file created: $output_vcf"
        fi
    fi
done


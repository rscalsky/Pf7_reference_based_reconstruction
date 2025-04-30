#!/bin/bash
#$ -S /bin/bash
#$ -P jcsilva-gcid-proj4a-malaria
#$ -cwd

source $SGE_ROOT/igs/common/settings.sh



# Check if the input VCF file is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_vcf>"
    exit 1
fi

input_vcf="$1"

# Check if the input VCF file exists
if [ ! -f "$input_vcf" ]; then
    echo "Input VCF file not found: $input_vcf"
    exit 1
fi

# Get a list of all country.txt files in the current directory
country_files=($(find . -type f -name '*.txt'))

# Iterate through each country.txt file
for country_file in "${country_files[@]}"; do
    # Extract the country name from the file name
    country_name="$(basename "$country_file" .txt)"

    # Define the output VCF file name
    output_vcf="${country_name}_filtered"

    # Run vcftools to filter the input VCF using the current country.txt file
    vcftools --vcf "$input_vcf" --keep "$country_file" --recode --out "$output_vcf"

    # Check the exit status of vcftools
    if [ $? -ne 0 ]; then
        echo "Error processing $country_file"
        errors=$((errors+1))
    fi
done

# Check if there were any errors
if [ "$errors" -gt 0 ]; then
    echo "There were $errors errors during processing."
    exit 1
fi

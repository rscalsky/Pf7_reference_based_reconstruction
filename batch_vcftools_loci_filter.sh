#!/bin/bash
#$ -S /bin/bash
#$ -P jcsilva-gcid-proj4a-malaria
#$ -cwd

source $SGE_ROOT/igs/common/settings.sh

# Check if the correct number of command-line arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <path_to_input_vcf> <path_to_input_csv>"
    exit 1
fi

# Assign command-line arguments to variables
input_vcf="$1"
input_csv="$2"

# Check if the input files exist
if [ ! -f "$input_vcf" ]; then
    echo "Error: Input VCF file not found: $input_vcf"
    exit 1
fi

if [ ! -f "$input_csv" ]; then
    echo "Error: Input CSV file not found: $input_csv"
    exit 1
fi

# Get the current working directory
cwd=$(pwd)

# Iterate over each row in the CSV (excluding the header)
tail -n +2 "$input_csv" | while IFS=',' read -r GeneID Chromosome Strand Strand2 Total_Coord_start Total_Coord_stop; do
    # Construct the output file path using the current working directory
    output_file="${cwd}/${Chromosome}_${GeneID}"

    # Run vcftools command
    vcftools --vcf "$input_vcf" --chr "$Chromosome" --from-bp "$Total_Coord_start" --to-bp "$Total_Coord_stop" --recode --out "$output_file"

    echo "Processed: $output_file"
done

echo "Script completed successfully."


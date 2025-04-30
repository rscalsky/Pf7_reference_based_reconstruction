#README for generate_single_vcf_from_group.sh

# This scripts takes country specific VCFs (group VCF) and splits them into individual VCFs 

# Why is this script useful? Reference based reconstruction requires individual VCFs

# Script options
# $1 = index_file.txt --> A file containing all the individual subject IDs you want extracted into vcfs
# $2 = input vcf directory --> directory with VCFs filtered for subject ID and loci  
# $3 = output_directory --> relative directory where you run the script from, this is where the recoded.vcfs will be output 




This script only requires one input:

$1 = input.vcf directory

All output VCFs are deposited in the same directory as the inputs

---------------------------------------------
Version 2 was written to resolve a GT to AD indexing issue which was encountered when using the new symbolic remove script:
remove_symbolic_variants_and_corresponding_AD_value.py

Version 3 was updated to:
1. remove lines where reference = major allele
2. remove lines were summation of allele depths = 0 
3. Strip non-major alleles out of the VCF if an ALT allele is the major allele. 

This script requires that the input vcf is bgzip-ed and indexed with bcftools

1.bgzip input.vcf 
2.bcftools index input.vcf.gz 

The script needs two options
1. input.vcf.gz
2. output.vcf

The script can take a bgzip-ed file but will return a standard .vcf

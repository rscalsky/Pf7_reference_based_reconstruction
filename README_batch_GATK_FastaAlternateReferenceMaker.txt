This script has three inputs

-o = output fasta directory 
-b = bed file for the specific locus
-i = vcf file directory 

This script was modified to ignore instances with only 1 ALT allele and those instances where total allele counts = 0 
- this was throwing an error about dividing by zero 

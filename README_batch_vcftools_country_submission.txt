#README for batch_vcftools_country_submission.sh 

#Note - BEFORE RUNNING $module load sge <-required for any qsub command

This script is to be used for submitting to the grid with the qsub command

This script will read through the current directory and identify any .txt files which will be used as index lists

These txt files determine which IDs will be kept from a broader vcf such as a pf20k group VCF. 

Output files will be named after the input.txt 

User inputs: The only user input is for a relative path to the input grouped vcf 


Example of script used in qsub command:"
# $qsub --P "ProjectID" -V -N "RunName" -o "ProjectOutput" -l "memory_usage" batch_vcftools_submission.sh /pathtoinput.vcf 

qsub -P jcsilva-gcid-proj4a-malaria -V -N batch_vcf_test -o /local/scratch/ryan.scalsky/test.out -e /local/scratch/ryan.scalsky/test.err
 -l mem_free=16G batch_vcftools_submission.sh /local/scratch/ryan.scalsky/Pf3D7_13_v3.pf7.vcf

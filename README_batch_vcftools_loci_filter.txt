# This is a readme for batch_vcftools_loci_filter.txt 

Description: This script will take an input vcf and csv and trim the input vcf, producing new outputs for each row of the input csv. Specifically 
this script is meant to trim all but the desired loci of interest. 

Script options
$1 = path to vcf
$2 = path to input csv 

Input csv format - note MAKE SURE THE CHROMOSOME MATCHES YOUR INPUT CSV 

GeneID,Chromosome,Strand,Strand2,Total_Coord_start,Total_Coord_stop,Total_CDS_start,Total_CDS_stop,CDS_1_start,CDS_1_stop,CDS_2_start,CDS_2_stop,5_UTR_start,5_UTR_stop,3_UTR_start,3_UTR_stop,PlasmoDB Link
PF3D7_0703900,Pf3D7_07_v3,Neg,(-),153119,167024,153320,166396,153320,166396,,,166397,167024,153119,153319,https://plasmodb.org/plasmo/app/record/gene/PF3D7_0703900#BlatAlignmentsGbrowseUrl

If you instead want to extract a different portion of the desired locus then you can modify the script to select based on a different column for example
Total_CDS_start and Total_CDS_stop

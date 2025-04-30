This script will take any inputs in the specified input directory, bgzip them then index them using bcftools. After this it will filter them using bcftools
to only include HET sites i.e. GT = 0/1 or 1/0. These files will be saved with names that reflect the changes. 

This script requires two inputs 
-i = input directory containing vcfs
-o = output directory for HET only filtered .vcfs

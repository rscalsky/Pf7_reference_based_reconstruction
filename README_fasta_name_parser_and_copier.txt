This script takes three inputs 

$1 = input index file 
$2 = input fasta directory 
$3 = output directory

input index file format .txt file with one column, each new line is a sampleID

The script will search the input fasta directory for any files containing the sampleID in their title and copy these to a newly created directory in the output directory 
named after the index file. 

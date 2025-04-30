# Pf7_reference_based_reconstruction
Scripts associated with reference based reconstruction used in: Global Characterization of Diversity and Selective Pressures in Five Plasmodium falciparum Loci Identified by Whole-Genome Sieve Analysis as Putative Antigens

Filtering Process in Detail - All scripts are used in sequence 
###All scripts were debugged using AI coding assistance### 

1.	Download chromosome VCF from malariagen server using filezila to explore and wget to download directly to server (InSilico_Manuscript1_Guide_v2)

2.	Remove unwanted samples 
  a.	Script: vcftools_sample_filter.sh
    i.	Input: input vcf
    ii.	Note: reads cwd for .txt index file which indicate samples to extract

3.	Remove unwanted loci on that chromosome 
  a.	Script: batch_vcftools_loci_filter.sh
  b.	Note: input csv requires specific file name for output to be written correctly
    i.	Csv file name format: PF3D7_0808100_Extract_Loci_input.csv

4.	Remove symbolics 
  a.	Script: remove_symbolic_variants_and_corresponding_AD_value.py
  Note: original script – remove_symbolic_variants.py did not scrape symbolic data from AD column which causes issues when calling major allele. Updated script is: remove_symbolic_variants_and_corresponding_AD_value.py

5.	Quality filter for PASS 
  a.	Script: 
    i.	Automatic_bgzip_bcftools_index 
      1.	Requires bgzip and bcftools index of the vcf
      2.	bgzip input.vcf
      3.	bcftools index input.vcf
    ii.	bcftools_quality_filter_PASS_only.sh
      1.	input.vcf.gz
      2.	output.vcf (outputs are not compressed, no need to uncompress)
      Note: bcftools_quality_filter_PASS_only.sh works on unzipped normal files which means automatic_bgzip_bcftools_index isn’t necessary

Split into individual VCFs 
Script: generate_single_vcf_from_group.sh 
Input: index.txt, input.vcf directory, output directory
Index: /local/projects-t3/p_falciparum/ryan.scalsky/Thesis/MalariaGen_Samples/All_Samples_after_filtering_index/All_SampleID_list.txt
Note: submit as qsub

6.	Remove non-variable sites i.e. keep HET/HOM Alt only sites 
  a.	Script: batch_bctools_HET_HOMALT_filter.sh
    i.	-i = input vcf directory / -o = output directory
  b.	Requires bgzip and bcftools index of all vcfs – all included in the script
  Note: originally only HET for alt were kept but HOM for ALT should also be kept.

7.	Call major alleles, i.e. most common allele (not necessarily >50% allele)
  a.	Script: batch_identify_filter_major_allele_v3.py
    i.	Check README for version changes
    ii.	Alternate solution – run locally (tmux)
    iii.	Only input is input directory 

8.	Keep only biallelic SNP
  a.	Script: batch_biallelicSNP_only_and_remove_indels_subs.py 
    i.	Only input is input directory 

9.	Reconstruct using GATK (may require modification)
  a.	Script: batch_GATK_FastaAlternateReferenceMaker_v3.sh
    i.	-o = output fasta directory 
    ii.	-b = bed file
    iii.	-i = input vcf file directory 
    Note: Requires BED files

10.	Fix headers to reflect individuals  
  a.	Script: replace_header_wfile_title_fastas.py

11.	Separate fasta files by country
  a.	Script: fasta_name_parser_and_copier.py
  b.	May need to combine these into one multi sequence fasta 
    i.	Script: Combine_single_fasta_into_multi_sequence_FASTA.py
    ii.	Path: 	
      File name convention:
      SampleFiltered_AssemblyID_chromosome_chrom.version_AssemblyID_symbstatus_PASSstatus_SampleID_HETstatus_
      Ex: SampleFiltered_Pf3D7_07_v3_PF3D7_0703900_nosymbolic_PASSonly_SPT43193_HETonly_

Keeping single vcfs from multi-sample vcf
vcftools --vcf input.vcf --indv sample_name --recode --out output_sample 

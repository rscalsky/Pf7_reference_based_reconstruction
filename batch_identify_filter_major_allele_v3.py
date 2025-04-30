import os
import pysam
import argparse

def calculate_major_allele(ad_values):
    total_depth = sum(ad_values)
    if total_depth == 0:
        return None, None  # all alleles have 0 allele depth

    major_allele_index = ad_values.index(max(ad_values))
    major_allele_fraction = ad_values[major_allele_index] / total_depth
    return major_allele_index, major_allele_fraction

def process_vcf(input_file, output_file):
    vcf_in = pysam.VariantFile(input_file)
    vcf_out = pysam.VariantFile(output_file, 'w', header=vcf_in.header)

    for record in vcf_in.fetch():
        ad = record.samples[0]['AD']  # assuming only one sample per VCF
        major_allele_index, major_allele_fraction = calculate_major_allele(ad)

        if major_allele_index is None:
            # Remove row if all alleles have 0 allele depth
            continue
        elif major_allele_index == 0:
            # Remove row if the reference is the major allele
            continue
        else:
            # Keep only the major ALT allele in the ALT column
            if len(record.alts) > 1:
                record.alts = (record.alts[major_allele_index - 1],)
            vcf_out.write(record)

    vcf_in.close()
    vcf_out.close()

def process_directory(directory):
    for filename in os.listdir(directory):
        if filename.endswith(".vcf"):
            input_file = os.path.join(directory, filename)
            output_file = input_file.replace(".recode.vcf", "_major_allele.recode.vcf")
            process_vcf(input_file, output_file)
            print(f"Processed {input_file} and saved to {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Filter VCF files by major allele.")
    parser.add_argument("-i", "--input_directory", required=True, help="Directory containing VCF files to process")

    args = parser.parse_args()
    process_directory(args.input_directory)


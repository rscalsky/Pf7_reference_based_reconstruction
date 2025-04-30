import sys
import os

def is_biallelic_snp(ref, alt):
    return len(ref) == 1 and len(alt) == 1

def contains_single_nucleotide_change(alt):
    return all(len(allele) == 1 for allele in alt.split(','))

def process_vcf(input_vcf, output_vcf):
    with open(input_vcf, 'r') as f, open(output_vcf, 'w') as out:
        for line in f:
            if line.startswith('#'):
                out.write(line)
            else:
                fields = line.strip().split('\t')
                ref = fields[3]
                alt = fields[4]
                if is_biallelic_snp(ref, alt) and contains_single_nucleotide_change(alt):
                    out.write(line)

def main():
    if len(sys.argv) != 2:
        print("Usage: python filter_snps.py input_vcf_directory")
        sys.exit(1)

    input_dir = sys.argv[1]
    output_dir = input_dir.rstrip('/') + '_filtered'
    os.makedirs(output_dir, exist_ok=True)

    for filename in os.listdir(input_dir):
        if filename.endswith('.vcf'):
            input_vcf = os.path.join(input_dir, filename)
            output_filename = filename.replace(".recode.vcf", "") + "_biallelicSNP_only.recode.vcf"
            output_vcf = os.path.join(output_dir, output_filename)
            process_vcf(input_vcf, output_vcf)

    print("Filtered biallelic SNPs written to:", output_dir)

if __name__ == "__main__":
    main()


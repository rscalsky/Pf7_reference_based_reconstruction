import vcf
import argparse

def remove_symbolics(vcf_file, output_file):
    with open(output_file, 'w') as out_vcf:
        vcf_reader = vcf.Reader(open(vcf_file, 'r'))
        vcf_writer = vcf.Writer(out_vcf, vcf_reader)

        for record in vcf_reader:
            # Check if any alternate allele is symbolic
            symbolic_indices = [i for i, alt in enumerate(record.ALT) if str(alt).startswith("*")]
            non_symbolic_alts = [alt for i, alt in enumerate(record.ALT) if i not in symbolic_indices]

            if non_symbolic_alts:
                record.ALT = non_symbolic_alts

                # Adjust the AD values in each sample
                for sample in record.samples:
                    if 'AD' in sample.data._fields:
                        ad = list(sample.data.AD)
                        new_ad = [ad[0]]  # always include the reference allele depth
                        # Include depths for non-symbolic alleles only
                        for i in range(len(ad) - 1):
                            if i not in symbolic_indices:
                                new_ad.append(ad[i + 1])

                        # Convert AD values to a comma-separated string
                        new_ad_str = ",".join(map(str, new_ad))

                        # Create a new SampleData object with the updated AD string
                        new_sample_data = sample.data._replace(AD=new_ad_str)
                        sample.data = new_sample_data

                vcf_writer.write_record(record)
            else:
                vcf_writer.write_record(record)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Remove symbolic variants from a VCF file.")
    parser.add_argument("input_vcf", help="Input VCF file path")
    parser.add_argument("output_vcf", help="Output VCF file path")
    args = parser.parse_args()

    input_vcf = args.input_vcf
    output_vcf = args.output_vcf

    remove_symbolics(input_vcf, output_vcf)


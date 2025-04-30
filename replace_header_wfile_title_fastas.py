import os
import argparse

def replace_headers(input_dir, output_dir):
    # Ensure output directory exists
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Loop through files in the input directory
    for filename in os.listdir(input_dir):
        if filename.endswith(".fasta"):
            # Read the contents of the fasta file
            with open(os.path.join(input_dir, filename), 'r') as file:
                fasta_content = file.readlines()

            # Extract the file title (filename without extension)
            file_title = os.path.splitext(filename)[0]

            # Replace header in the fasta content
            fasta_content[0] = ">" + file_title + "\n"

            # Write modified fasta content to output directory
            with open(os.path.join(output_dir, filename), 'w') as file:
                file.writelines(fasta_content)

    print("Headers replaced successfully!")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Replace headers in fasta files.')
    parser.add_argument('input_dir', help='Input directory containing .fasta files')
    parser.add_argument('output_dir', help='Output directory for modified fasta files')

    args = parser.parse_args()

    replace_headers(args.input_dir, args.output_dir)


'''
Using the script provided by BEA19

https://www.cl.cam.ac.uk/research/nl/bea2019st/data/corr_from_m2.py
'''

import argparse
import os

# Apply the edits of a single annotator to generate the corrected sentences.
def main(input_file, output_orig_file, output_corr_file):
	m2 = open(input_file).read().strip().split("\n\n")
	orig_out = open(output_orig_file, "w")
	corr_out = open(output_corr_file, "w")
	# Do not apply edits with these error types
	skip = {"noop", "UNK", "Um"}

	for sent in m2:
		sent = sent.split("\n")
		orig_sent = sent[0].split()[1:] # Ignore "S "
		cor_sent = sent[0].split()[1:] # Ignore "S "

		edits = sent[1:]
		offset = 0
		for edit in edits:
			edit = edit.split("|||")
			if edit[1] in skip: continue # Ignore certain edits
			coder = int(edit[-1])
			# if coder != args.id: continue # Ignore other coders
			span = edit[0].split()[1:] # Ignore "A "
			start = int(span[0])
			end = int(span[1])
			cor = edit[2].split()
			cor_sent[start+offset:end+offset] = cor
			offset = offset-(end-start)+len(cor)
		
		corr_out.write(" ".join(cor_sent)+"\n")
		orig_out.write(" ".join(orig_sent)+"\n")


if __name__ == "__main__":
	# Define and parse program input
	# parser = argparse.ArgumentParser()
	# parser.add_argument("m2_file", help="The path to an input m2 file.")
	# parser.add_argument("-out", help="A path to where we save the output corrected text file.", required=True)
	# parser.add_argument("-id", help="The id of the target annotator in the m2 file.", type=int, default=0)
	# args = parser.parse_args()
	m2_folder = os.path.join(os.path.dirname(__file__), 'm2')
	txt_folder = os.path.join(os.path.dirname(__file__), 'txt')
	for m2_file in os.listdir(m2_folder):
		orig_txt_file = m2_file.rstrip('.m2') + '.orig.txt'
		corr_txt_file = m2_file.rstrip('.m2') + '.corr.txt'

		input_file = os.path.join(m2_folder, m2_file)
		output_orig_file = os.path.join(txt_folder, orig_txt_file)
		output_corr_file = os.path.join(txt_folder, corr_txt_file)

		main(input_file, output_orig_file, output_corr_file)

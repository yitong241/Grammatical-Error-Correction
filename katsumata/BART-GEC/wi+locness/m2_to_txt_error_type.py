import os


def read_m2_file(input_file):
    m2 = open(input_file, encoding="ISO-8859-1").read().strip().split("\n\n")
    skip = {"noop", "UNK", "Um"}

    sentence_corr_out = []
    sentence_orig_out = []
    errors = []

    for sent in m2:
        sent = sent.split("\n")
        orig_sent = sent[0].split()[1:]  # Ignore "S "
        cor_sent = sent[0].split()[1:]  # Ignore "S "

        edits = sent[1:]
        offset = 0
        error_types = []
        for edit in edits:
            edit = edit.split("|||")
            if edit[1] in skip: continue  # Ignore certain edits
            error_type = edit[1].split(":")[1]
            if error_type not in error_types:
                error_types.append(error_type)
            span = edit[0].split()[1:]  # Ignore "A "
            start = int(span[0])
            end = int(span[1])
            cor = edit[2].split()
            cor_sent[start + offset:end + offset] = cor
            offset = offset - (end - start) + len(cor)

        sentence_corr_out.append(" ".join(cor_sent) + "\n")
        sentence_orig_out.append(" ".join(orig_sent) + "\n")
        errors.append(error_types)

    return sentence_corr_out, sentence_orig_out, errors

def write_to_txt():
    m2_folder = os.path.join(os.path.dirname(__file__), 'm2_error_type')
    txt_folder = os.path.join(os.path.dirname(__file__), 'txt_error_type')

    for filename in os.listdir(txt_folder):
        file_path = os.path.join(txt_folder, filename)
        try:
            if os.path.isfile(file_path):
                os.remove(file_path)
        except Exception as e:
            print(f"Error: {e}")

    for m2_file in os.listdir(m2_folder):
        orig_txt_file = m2_file.rstrip('.m2') + '.orig.txt'
        corr_txt_file = m2_file.rstrip('.m2') + '.corr.txt'

        input_file = os.path.join(m2_folder, m2_file)
        sentences_corr, sentences_orig, errors = read_m2_file(input_file)

        for sentence, error_types in zip(sentences_corr, errors):
            for error_type in error_types:
                output_file = os.path.join(txt_folder, error_type+'.'+corr_txt_file)
                with open(output_file, "a+", encoding="ISO-8859-1") as fout:
                    fout.write(sentence)

        for sentence, error_types in zip(sentences_orig, errors):
            for error_type in error_types:
                output_file = os.path.join(txt_folder, error_type+'.'+orig_txt_file)
                with open(output_file, "a+", encoding="ISO-8859-1") as fout:
                    fout.write(sentence)

if __name__ == "__main__":
    write_to_txt()

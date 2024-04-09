'''
Splits ABC.train and ABCN.dev dataset based on error types
'''

import os
from collections import defaultdict, deque

cwd = os.path.dirname(os.path.abspath(__file__))
cwd_data_path = os.path.join(cwd, "data")
if not os.path.exists(cwd_data_path):
    os.mkdir(cwd_data_path)
proj_path = os.path.dirname(os.path.dirname(cwd))
wi_locness_path = os.path.join(proj_path, "katsumata", "BART-GEC", "wi+locness")
data_path = os.path.join(wi_locness_path, "m2")
m2_file = "{cefr}.{split}.gold.bea19.m2"

def split():
    newline = "\n"
    for split in ("train", "dev"):
        cefr = "ABC" if split == "train" else "ABCN"
        with open(os.path.join(data_path, m2_file.format(cefr=cefr, split=split)), "r") as f:
            m2 = deque(f.readlines())
        
        """
        error_type = {
            "error_type1": [
                [orig, edit1, edit2, ...]
            ],
            ...
        }
        """
        error_types = defaultdict(list)
        while m2:
            # Get original sentence and edits to apply
            sent = []
            while m2 and m2[0] != newline: sent.append(m2.popleft())
            while m2 and m2[0] == newline: m2.popleft()
            o = sent.pop(0)

            """
            edits = {
                "error_type1": [
                    edit1, edit2, ...
                ],
                ...
            }
            """
            edits = defaultdict(list)
            for edit in sent:
                error_type = edit.split("|||")[1]
                error_type = error_type.split(":")[0]
                edits[error_type].append(edit)
            for etype, edit in edits.items():
                error_types[etype].append([o, *edit])
        
        # Write to file
        out_path = "{cefr}.{split}.{error_type}.m2"
        for etype, lines in error_types.items():
            ofile = out_path.format(cefr=cefr, split=split, error_type=etype)
            ofile = os.path.join(cwd, "data", ofile)
            with open(ofile, "w+") as f:
                lines = [f"{''.join(line)}" for line in lines]
                f.write(newline.join(lines))
                f.write(newline)

if __name__ == "__main__":
    split()

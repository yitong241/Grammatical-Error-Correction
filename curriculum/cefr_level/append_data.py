import os

root_path = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
wi_locness_path = os.path.join(root_path, "katsumata", "BART-GEC", "wi+locness")

file = "{cefr}.{split}.gold.bea19.{lang}.txt"
for split in ("train", "dev"):
    for lang in ("orig", "corr"):
        with open(os.path.join(wi_locness_path, "txt", file.format(cefr="A", split=split, lang=lang)), 'r') as f:
            data_A = f.readlines()
        with open(os.path.join(wi_locness_path, "txt", file.format(cefr="B", split=split, lang=lang)), 'r') as f:
            data_B = f.readlines()
        with open(os.path.join(wi_locness_path, "txt", file.format(cefr="AB", split=split, lang=lang)), 'w') as f:
            f.writelines(data_A + data_B)

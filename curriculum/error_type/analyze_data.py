import os

os.path.pardir
data_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data")

def main():
    col1 = "Dataset"
    col2 = "# Sample"
    col3 = "# Edits"
    print(f"{col1:^16} | {col2} | {col3}")
    print("=" * 38)
    error = ""
    for etype in ("M", "noop", "R", "U", "UNK"):
        error += etype
        for split in ("train", "dev"):
            cefr = "ABC" + ("" if split == "train" else "N")
            file_path = f"{cefr}_{error}.{split}.gold.bea19.m2"
            with open(os.path.join(data_dir, file_path), "r") as f:
                lines = f.readlines()
            
            data = 0
            edits = 0
            for line in lines:
                if line.startswith("S"): data += 1
                elif line.startswith("A"): edits += 1
            
            row = f"{error}.{split}"
            print(f"{row:<16} | {str(data):^8} |  {edits}")

if __name__ == "__main__":
    main()

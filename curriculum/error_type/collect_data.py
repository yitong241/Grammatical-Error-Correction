import os
import re

file_dir = os.path.dirname(os.path.abspath(__file__))
logs_dir = os.path.join(file_dir, "logs")

def main():
    lowest_losses = []
    for etype in ("M", "R", "U", "noop", "UNK"):
        err_log = os.path.join(logs_dir, f"log_{etype}.txt")
        with open(err_log, "r") as f:
            content = f.read()
        matches = re.findall("\| train \| epoch \d{3} \| loss (\d\.\d[\d]?[\d]?) \|", content)
        loss = [float(score) for score in matches]
        print(f"{etype:<4}: {str(loss):<70} | Lowest Loss: {min(loss)}")
        lowest_losses.append((min(loss), etype))
    lowest_losses.sort()
    print(lowest_losses)

if __name__ == "__main__":
    main()

import os
import random

parent = os.path.dirname(os.path.abspath(__file__))
root = os.path.dirname(os.path.dirname(parent))

train_data = os.path.join(root, "katsumata", "BART-GEC", "wi+locness", "m2", "ABC.train.gold.bea19.m2")
dev_data = os.path.join(root, "katsumata", "BART-GEC", "wi+locness", "m2", "ABCN.dev.gold.bea19.m2")

def random_sample(filepath:str, num_samples: int, num_edits: int):
    with open(filepath, "r") as f:
        lines = f.readlines()
    
    samples_and_edits = []
    edits = []
    for line in lines:
        if line.startswith("S"):
            samples_and_edits.append([line])
        elif line.startswith("A"):
            edits.append(line)
        elif edits:
            samples_and_edits[-1].append(edits)
            edits = []
    
    if num_samples > len(samples_and_edits):
        n_edits = sum(len(sample[1]) for sample in samples_and_edits)
        print("WARNING: Requested num_samples is too large")
        print(f"Requested: {[num_samples, num_edits]} | Sampled: {[len(samples_and_edits), n_edits]}")
        return samples_and_edits

    # Sort in increasing order of edits and take the middle
    N = len(samples_and_edits)
    offset = (N - num_samples) // 2
    samples_and_edits.sort(key=lambda x: len(x[1]))
    middle = samples_and_edits[offset:offset+num_samples]
    outliers = samples_and_edits[:offset] + samples_and_edits[offset+num_samples:]
    random.shuffle(outliers)
    samples_and_edits = middle + outliers

    random_samples = samples_and_edits[:num_samples]
    n_edits = sum(len(sample[1]) for sample in random_samples)
    while n_edits / num_edits < 0.90:
        # Too little n_edits sampled
        newsample = samples_and_edits.pop()
        random_samples.append(newsample)
        n_edits += len(newsample[1])
    while num_edits / n_edits < 0.90:
        # Too many n_edits sampled
        nosample = random_samples.pop()
        n_edits -= len(nosample[1])
    print(f"Actual: {str(num_samples):<5}, {str(num_edits):<5} | Sampled: {len(random_samples)}, {n_edits}")

    random.shuffle(random_samples)
    return random_samples

def main():
    population = [
        [10775, 16104],
        [1314 , 2009 ],
        [22038, 27367],
        [2842 , 3537 ],
        [33037, 66490],
        [4224 , 8210 ],
        [34000, 73297],
        [4347 , 8989 ],
        [34308, 74946],
        [4384 , 9160 ],
    ]

    for i, (num_samples, num_edits) in enumerate(population):
        print(f"Sampling {i//2}/{len(population)//2} [{'train' if i & 1 == 0 else ' dev '}]", end=" | ")
        _rsamples = random_sample(train_data if i & 1 == 0 else dev_data, num_samples, num_edits)
        rsamples = []
        for sample, edits in _rsamples:
            rsamples.append(sample)
            rsamples.extend(edits)
            rsamples.append("\n")
        with open(os.path.join(parent, "data", f"random{i//2}.{'train' if i & 1 == 0 else 'dev'}.gold.bea19.m2"), "w") as f:
            f.write("".join(rsamples))
            f.write("\n")

if __name__ == "__main__":
    main()

from fairseq.models.bart import BARTModel
import torch

bart = BARTModel.from_pretrained(
    "katsumata/BART-GEC/wi+locness/bart.base/",
    checkpoint_file="gec_bart/checkpoint_best.pt",
    data_name_or_path="katsumata/BART-GEC/wi+locness/bart.base/gec_data-bin",
)
# default_args = [
#     "katsumata/BART-GEC/wi+locness/bart.base/gec_data-bin",
#     "--task",
#     "translation",
#     "--source-lang",
#     "orig",
#     "--target-lang",
#     "corr",
#     "--arch",
#     "bart_base",
# ]
# parser = options.get_training_parser()
# args = options.parse_args_and_arch(parser, input_args=default_args)

# cfg = convert_namespace_to_omegaconf(args)
# task = DifficultyEvalTask(cfg)

# task.load_dataset("train")

criterion = torch.nn.CrossEntropyLoss()
losses = {}

# for sample_id, sample in enumerate(task.dataset("train")):
#     input_ids = sample["source"]
#     output_ids = sample["target"]

#     input_ids = input_ids.unsqueeze(0)
#     output_ids = output_ids.unsqueeze(0)

#     src_lengths = torch.tensor([input_ids.ne(1).long().sum()])
#     prev_output_tokens = torch.cat(
#         [output_ids.new_full((output_ids.size(0), 1), 1), output_ids[:, :-1]], 1
#     )

#     with torch.no_grad():
#         bart.sample()
#         model_output = bart.model(
#             input_ids, src_lengths, prev_output_tokens=prev_output_tokens
#         )
#         print(model_output)
#         logits = model_output


#     logits = logits.view(-1, logits.size(-1))
#     output_ids = output_ids.view(-1)
#     print(output_ids)
#     loss = criterion(logits, output_ids)
#     losses[sample_id] = loss.mean().item()
#     print(losses[sample_id])
def read_file(file_path):
    with open(file_path, "r", encoding="utf-8") as file:
        return [line.strip() for line in file.readlines()]


base_dir = "katsumata/BART-GEC/wi+locness/"
source_text = base_dir + "txt/ABC.train.gold.bea19.orig.txt"
target_text = base_dir + "txt/ABC.train.gold.bea19.corr.txt"
output_path = base_dir + "txt_by_difficulty/"
output_source = output_path + "ABC_ordered.train.gold.bea19.orig.txt"
output_target = output_path + "ABC_ordered.train.gold.bea19.corr.txt"

source_texts = read_file(source_text)
target_texts = read_file(target_text)


def compute_loss(source, target):
    source_encoded = bart.encode(source).unsqueeze(0)
    target_encoded = bart.encode(target).unsqueeze(0)
    source_lengths = torch.tensor(
        [source_encoded.ne(bart.task.source_dictionary.pad()).long().sum()]
    )
    prev_output_tokens = torch.cat(
        [
            target_encoded.new_full(
                (1, 1), bart.task.target_dictionary.bos()
            ),  # BOS token
            target_encoded[:, :-1],
        ],
        dim=1,
    )
    bart.eval()
    with torch.no_grad():
        logits, _ = bart.model(
            source_encoded,
            src_lengths=source_lengths,
            prev_output_tokens=prev_output_tokens,
        )
    logits = logits.view(-1, logits.size(-1))
    target_flat = target_encoded.view(-1)
    loss = criterion(logits, target_flat)
    return loss


results = []
for source_txt, target_txt in zip(source_texts, target_texts):
    loss = compute_loss(source_txt, target_txt)
    results.append((source_txt, target_txt, loss))

sorted_results = sorted(results, key=lambda x: x[2])
with open(output_source, "w") as fout_s, open(output_target, "w") as fout_t:
    for sample in sorted_results:
        source, target, loss = sample
        fout_s.write(f"{source}\n")
        fout_t.write(f"{target}\n")

# BART-GEC
- Fine-tuned BART model for GEC.
  - Only English GEC.
- This script is based on fairseq.
  - original commit id: 9f4256e [[link]](https://github.com/pytorch/fairseq/tree/9f4256edf60554afbcaadfa114525978c141f2bd)
  - fairseq README: `FAIRSEQ_README.md`

## Before Running _\[Added by us\]_

1. Install dependencies

    - [See Fairseq requirements and installation](./FAIRSEQ_README.md#requirements-and-installation)

        - First, remove existing `fairseq` and `fairseq_cli` directories
        - Follow **Installing from source** instead of raw pip installing
        - Copy over [metrics.py](https://github.com/Katsumata420/generic-pretrained-GEC/blob/master/BART-GEC/fairseq/metrics.py) and [meters.py](https://github.com/Katsumata420/generic-pretrained-GEC/blob/master/BART-GEC/fairseq/meters.py) from Katsumata's repo and place inside newly created `fairseq/fairseq/` folder

    - Install additional dependencies

        - `pip install -r katsumata/requirements.txt`

    - Install BART model to use

        - Install under `katsumata/BART-GEC/wi+locness/` folder
        - After installation, directory structure should look something like

        ```md
        # Assuming BART-base was installed
        |-- katsumata/BART-GEC/wi+locness/
        |   |-- bart.base/
        |       |-- dict.txt
        |       |-- model.pt
        |       |-- NOTE
        ```

    - Install `lxml` dependencies

        1. `pip install lxml==4.9.4`
        1. If that does not work, also try

            ```bash
            # For linux
            sudo apt-get install libxml2-dev libxslt-dev python-dev
            # For Mac
            brew install brew install libxml2 libxslt
            # Don't know for Windows...sorry
            ```

        1. Build Cython components

            - Run `python setup.py build_ext --inplace`

1. Might need to install an earlier version of Python

    - I tried Python3.8 and it seems to work fine for the most part
    - Made a few tweaks here and there (e.g., change `np.float` to `float`)

1. Install datasets and preprocess them

    - https://www.cl.cam.ac.uk/research/nl/bea2019st/#data
    - Use [.m2 to .txt conversion script](./wi+locness/m2_to_txt.py) to convert dataset in `.m2` format back to original text

1. Update file paths used in shell files accordingly

    - `apply_bpe.sh`
    - `preprocess.sh`
    - `train.sh`
    - `translate.sh`

## How To Run
[Summarization example](https://github.com/Katsumata420/generic-pretrained-GEC/blob/master/BART-GEC/examples/bart/README.cnn.md) is used for GEC fine-tuning.

1. Prepare the BEA-train/valid/test data (Lang-8, NUCLE, and so on).
    - https://www.cl.cam.ac.uk/research/nl/bea2019st/#data
2. Prepare pretrained BART model (`bart.large.tar.gz`) and related files
 (`encoder.json`, `vocab.bpe` and `dict.txt`).
    - `bart.large.tar.gz`: [url](https://dl.fbaipublicfiles.com/fairseq/models/bart.large.tar.gz)
    - `encoder.json`: [url](https://dl.fbaipublicfiles.com/fairseq/gpt2_bpe/encoder.json)
    - `vocab.bpe`: [url](https://dl.fbaipublicfiles.com/fairseq/gpt2_bpe/vocab.bpe)
    - `dict.txt`: [url](https://dl.fbaipublicfiles.com/fairseq/gpt2_bpe/dict.txt)

        - Use correct `dict.txt`
        - When you download bart-large or bart-base, it comes with a `dict.txt`; use that

2. Apply BART BPE to the BEA-train/valid data.
    - Use `apply_bpe.sh`.
3. Binarize train/valid data.
    - Use `preprocess.sh`.
4. Fine-tune the BART model with binarized data.
    - Use `train.sh`.
5. Translate BEA-test using the fine-tuned model.
    - Use `translate.sh`.

### Caution
Lewis et al. have instructed to run BPE on non-tokenization text in CNN/DailyMail.

However, I didn't detokenized the text.

I used the original tokenization in BEA-train and applied BPE to the tokenized BEA-train text.


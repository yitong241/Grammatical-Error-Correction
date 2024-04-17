# Example command:
# ./apply_bpe.sh [TRAIN] [DEV]

# If TRAIN is not provided, default to ABC
TRAIN=$1
if [[ -z $1 ]]; then
    TRAIN=ABC
fi

# If DEV is not provided, default to ABCN
DEV=$2
if [[ -z $2 ]]; then
    DEV=ABCN
fi

BPE_FOLDER=./wi+locness/bpe/

TRAIN_BPE_NAME="${BPE_FOLDER}${TRAIN}.train.bpe"
VALID_BPE_NAME="${BPE_FOLDER}${DEV}.dev.bpe"

MODEL_PATH=./wi+locness/bart.base
DICT_PATH="${MODEL_PATH}/dict.txt"

fairseq-preprocess \
  --source-lang orig \
  --target-lang corr \
  --trainpref $TRAIN_BPE_NAME \
  --validpref $VALID_BPE_NAME \
  --destdir "${MODEL_PATH}/gec_data-bin/" \
  --workers 10 \
  --srcdict $DICT_PATH \
  --tgtdict $DICT_PATH;

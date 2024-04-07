# Example command:
# ./apply_bpe.sh [CEFR_LEVEL]

# If CEFR_LEVEL is not provided, default to ABC
CEFR_LEVEL=$1
if [[ (-z $1) || ($1 != A && $1 != B && $1 != C && $1 != ABC) ]]; then
    CEFR_LEVEL=ABC
fi

TRAIN=$CEFR_LEVEL
DEV=$CEFR_LEVEL
if [[ $DEV = ABC ]]; then
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

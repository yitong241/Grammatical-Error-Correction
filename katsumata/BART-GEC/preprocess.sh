CEFR_LEVEL=A
BPE_FOLDER=./wi+locness/bpe/

TRAIN_BPE_NAME="${BPE_FOLDER}${CEFR_LEVEL}.train.bpe"
VALID_BPE_NAME="${BPE_FOLDER}${CEFR_LEVEL}.dev.bpe"

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

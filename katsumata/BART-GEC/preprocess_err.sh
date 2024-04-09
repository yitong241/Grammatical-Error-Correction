# Example command:
# ./preprocess_err.sh [ERROR_TYPE]


ERROR_TYPE=$1

TRAIN=ABC
DEV=ABCN


BPE_FOLDER=./wi+locness/bpe_error_type/

TRAIN_BPE_NAME="${BPE_FOLDER}${ERROR_TYPE}.${TRAIN}.train.bpe"
VALID_BPE_NAME="${BPE_FOLDER}${ERROR_TYPE}.${DEV}.dev.bpe"

MODEL_PATH=./wi+locness/bart.base
DICT_PATH="${MODEL_PATH}/dict.txt"

fairseq-preprocess \
  --source-lang orig \
  --target-lang corr \
  --trainpref $TRAIN_BPE_NAME \
  --validpref $VALID_BPE_NAME \
  --destdir "${MODEL_PATH}/gec_data-bin/${ERROR_TYPE}/" \
  --workers 10 \
  --srcdict $DICT_PATH \
  --tgtdict $DICT_PATH;
# Example command:
# ./apply_bpe.sh [ERROR_TYPE]

DATASET_PATH=./wi+locness/txt_error_type/
OUT_PATH=./wi+locness/bpe_error_type/

# If CEFR_LEVEL is not provided, default to ABC
ERROR_TYPE=$1
#if [[ (-z $1) || ($1 != A && $1 != B && $1 != C && $1 != AB && $1 != ABC) ]]; then
#    CEFR_LEVEL=ABC
#fi

TRAIN=ABC
DEV=ABCN
if [[ $DEV = ABC ]]; then
    DEV=ABCN
fi

mkdir -p $OUT_PATH

for SPLIT in "${ERROR_TYPE}.${TRAIN}.train" "${ERROR_TYPE}.${DEV}.dev"
do
    for LANG in orig corr
    do
        python -m examples.roberta.multiprocessing_bpe_encoder \
            --encoder-json encoder.json \
            --vocab-bpe vocab.bpe \
            --inputs "${DATASET_PATH}${SPLIT}.gold.bea19.${LANG}.txt" \
            --outputs "${OUT_PATH}${SPLIT}.bpe.${LANG}" \
            --workers 10 \
            --keep-empty;
    done
done
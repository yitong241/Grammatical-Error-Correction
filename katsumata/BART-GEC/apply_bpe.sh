# Example command:
# ./apply_bpe.sh [CEFR_LEVEL]

DATASET_PATH=./wi+locness/txt/
OUT_PATH=./wi+locness/bpe/

# If CEFR_LEVEL is not provided, default to ABC
CEFR_LEVEL=$1
if [[ (-z $1) || ($1 != A && $1 != B && $1 != C && $1 != AB && $1 != ABC) ]]; then
    CEFR_LEVEL=ABC
fi

TRAIN=$CEFR_LEVEL
DEV=$CEFR_LEVEL
if [[ $DEV = ABC ]]; then
    DEV=ABCN
fi

mkdir -p $OUT_PATH

for SPLIT in "${TRAIN}.train" "${DEV}.dev"
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


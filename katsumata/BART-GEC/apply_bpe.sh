# Example command:
# ./apply_bpe.sh [TRAIN] [DEV]

DATASET_PATH=./wi+locness/txt/
OUT_PATH=./wi+locness/bpe/

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

mkdir -p $OUT_PATH

for SPLIT in "${TRAIN}.train" "${DEV}.dev"
do
    for LANG in orig corr
    do
        python -m examples.roberta.multiprocessing_bpe_encoder \
            --encoder-json encoder.json \
            --vocab-bpe vocab.bpe \
            --inputs "${DATASET_PATH}/${SPLIT}.gold.bea19.${LANG}.txt" \
            --outputs "${OUT_PATH}/${SPLIT}.bpe.${LANG}" \
            --workers 10 \
            --keep-empty;
    done
done


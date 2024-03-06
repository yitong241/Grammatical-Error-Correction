DATASET_PATH=./wi+locness/txt/
OUT_PATH=./wi+locness/bpe/
CEFR_LEVEL=A

mkdir $OUT_PATH

for SPLIT in train dev
do
    for LANG in orig corr
    do
        python -m examples.roberta.multiprocessing_bpe_encoder \
            --encoder-json encoder.json \
            --vocab-bpe vocab.bpe \
            --inputs "${DATASET_PATH}${CEFR_LEVEL}.${SPLIT}.gold.bea19.${LANG}.txt" \
            --outputs "${OUT_PATH}${CEFR_LEVEL}.${SPLIT}.bpe.${LANG}" \
            --workers 10 \
            --keep-empty;
    done
done


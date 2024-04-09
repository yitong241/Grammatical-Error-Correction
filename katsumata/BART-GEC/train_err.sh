TOTAL_NUM_UPDATES=20000
WARMUP_UPDATES=500
LR=3e-05
MAX_TOKENS=4000
UPDATE_FREQ=1

MODEL_PATH=./wi+locness/bart.base
BART_PATH=${MODEL_PATH}/model.pt
ERROR_TYPE=$1

CUDA_VISIBLE_DEVICES=1 python train.py ${MODEL_PATH}/gec_data-bin/${ERROR_TYPE} \
    --save-dir ${MODEL_PATH}/gec_bart \
    --log-format simple \
    --log-interval 100 \
    --seed 1 \
    --restore-file $BART_PATH \
    --max-tokens $MAX_TOKENS \
    --task translation \
    --source-lang orig --target-lang corr \
    --truncate-source \
    --layernorm-embedding \
    --share-all-embeddings \
    --share-decoder-input-output-embed \
    --reset-optimizer --reset-dataloader --reset-meters \
    --arch bart_base \
    --criterion label_smoothed_cross_entropy \
    --label-smoothing 0.1 \
    --dropout 0.3 --attention-dropout 0.3 \
    --weight-decay 0.01 --optimizer adam --adam-betas "(0.9, 0.999)" --adam-eps 1e-08 \
    --clip-norm 0.1 \
    --lr-scheduler polynomial_decay --lr $LR --total-num-update $TOTAL_NUM_UPDATES --warmup-updates $WARMUP_UPDATES \
    --skip-invalid-size-inputs-valid-test \
    --max-epoch 10 \
    --find-unused-parameters;
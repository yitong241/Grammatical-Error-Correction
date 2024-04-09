# Immediately exit if any error is raised
set -e
trap cleanup EXIT

MODEL_PATH=./wi+locness/bart.base
TEST_DIR=./wi+locness/test

cleanup() {
    # CD into correct directory
    cd "$( dirname "$0" )"
    cd ../../katsumata/BART-GEC
    
    # Restore original bart model
    echo "Restoring original BART model"
    mv "${MODEL_PATH}/model_backup.pt" "${MODEL_PATH}/model.pt"
}

train() {
    # CD into correct directory
    cd "$( dirname "$0" )"
    cd ../../katsumata/BART-GEC

    # Backup original bart model
    echo "Backup BART model.pt file"
    cp "${MODEL_PATH}/model.pt" "${MODEL_PATH}/model_backup.pt"

    # Train BART on dataset in increasing fluency level
    for CEFR in A AB ABC
    do
        ./apply_bpe.sh $CEFR   # Convert data into BPE tokens
        ./preprocess.sh $CEFR  # Preprocess the tokens
        ./train.sh             # Train BART model
        ./translate.sh         # Generates hyp.txt file for prediction

        # Change hyp.txt file
        mv "${TEST_DIR}/hyp.txt" "${TEST_DIR}/${CEFR}.txt"

        # Replace BART with best checkpoint
        cp "${MODEL_PATH}/gec_bart/checkpoint_best.pt" "${MODEL_PATH}/model.pt"
    done
}

train | tee -- "log.txt"

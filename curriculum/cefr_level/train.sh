# Immediately exit if any error is raised
set -e
trap cleanup EXIT

MODEL_PATH=./wi+locness/bart.base
TEST_DIR=./wi+locness/test

cleanup() {    
    # Restore original bart model
    echo "Restoring original BART model"
    mv "${MODEL_PATH}/model_backup.pt" "${MODEL_PATH}/model.pt"
}

train() {
    # Train BART on dataset with given CEFR level
    ./apply_bpe.sh $CEFR   # Convert data into BPE tokens
    ./preprocess.sh $CEFR  # Preprocess the tokens
    ./train.sh             # Train BART model
    ./translate.sh         # Generates hyp.txt file for prediction

    # Change hyp.txt file
    mv "${TEST_DIR}/hyp.txt" "${TEST_DIR}/${CEFR}.txt"

    # Replace BART with best checkpoint
    cp "${MODEL_PATH}/gec_bart/checkpoint_best.pt" "${MODEL_PATH}/model.pt"
}

# CD into correct directory
ROOT_DIR="$( cd "$( dirname "$0" )" && pwd )"
cd ${ROOT_DIR}
cd ../../katsumata/BART-GEC

# Backup original bart model
echo "Backup BART model.pt file"
cp "${MODEL_PATH}/model.pt" "${MODEL_PATH}/model_backup.pt"

# Empty log files
LOGS_DIR="${ROOT_DIR}/logs"
rm -rf "${LOGS_DIR}"
mkdir -p "${LOGS_DIR}"

# Train model on each CEFR level
for CEFR in A AB ABC
do
    train $CEFR | tee -- "${ROOT_DIR}/logs/log_${ERR_TYPE}.txt"
done

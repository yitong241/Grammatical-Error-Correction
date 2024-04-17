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
    local ERR_TYPE=$1

    # Train BART on dataset in increasing fluency level
    ./apply_bpe.sh "ABC_${ERR_TYPE}" "ABCN_${ERR_TYPE}"   # Convert data into BPE tokens
    ./preprocess.sh "ABC_${ERR_TYPE}" "ABCN_${ERR_TYPE}"  # Preprocess the tokens
    ./train.sh      # Train BART model
    ./translate.sh  # Generates hyp.txt file for prediction

    # Change hyp.txt file
    mv "${TEST_DIR}/hyp.txt" "${TEST_DIR}/${ERR_TYPE}.txt"

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

# Train model on each error type
# TODO: Replace order
for ERR_TYPE in M Mnoop MnoopR MnoopRU MnoopRUUNK
do
    train $ERR_TYPE | tee -- "${ROOT_DIR}/logs/log_train_${ERR_TYPE}.txt"
done

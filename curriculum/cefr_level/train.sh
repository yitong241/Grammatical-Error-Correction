# Immediately exit if any error is raised
set -e
trap cleanup EXIT

cleanup() {
    # Restore original bart model
    mv "${MODEL_PATH}/model_backup.pt" "${MODEL_PATH}/model.pt"
}

# CD into correct directory
cd "$( dirname "$0" )"
cd ../../katsumata/BART-GEC

# Backup original bart model
MODEL_PATH=./wi+locness/bart.base
cp "${MODEL_PATH}/model.pt" "${MODEL_PATH}/model_backup.pt"

# Train BART on dataset in increasing fluency level
for CEFR in A B C ABC
do
    ./apply_bpe.sh $CEFR
    ./preprocess.sh $CEFR
    ./train.sh
    # Replace BART with best checkpoint
    cp "${MODEL_PATH}/gec_bart/checkpoint_best.pt" "${MODEL_PATH}/model.pt"
done

# Generate test result to use to evaluate model performance
./translate.sh

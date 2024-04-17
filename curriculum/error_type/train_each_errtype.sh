# Immediately exit if any error is raised
set -e

MODEL_PATH=./wi+locness/bart.base
TEST_DIR=./wi+locness/test

train() {
    local ERR_TYPE=$1

    # Train BART on dataset in increasing fluency level
    ./apply_bpe.sh "ABC_${ERR_TYPE}" "ABCN_${ERR_TYPE}"   # Convert data into BPE tokens
    ./preprocess.sh "ABC_${ERR_TYPE}" "ABCN_${ERR_TYPE}"  # Preprocess the tokens
    ./train.sh  # Train BART model
}

# CD into correct directory
ROOT_DIR="$( cd "$( dirname "$0" )" && pwd )"
cd ${ROOT_DIR}
cd ../../katsumata/BART-GEC

# Train model on each error type
for ERR_TYPE in M R U noop UNK
do
    train $ERR_TYPE | tee -- "${ROOT_DIR}/logs/log_errtype_${ERR_TYPE}.txt"
done

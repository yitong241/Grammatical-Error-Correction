# OUT=$1
# GPU=$2
# model=$3

OUT=wi+locness/test
GPU=1
model=wi+locness/bart.base

mkdir -p $OUT

CUDA_VISIBLE_DEVICES=$GPU python translate.py \
  $model \
  wi+locness/test/ABCN.test.bea19.orig \
  $OUT

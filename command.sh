bea-exp

git clone https://github.com/chrisjbryant/errant.git

python run.py --train --data_dir bea-exp/dev-text --m2_dir bea-exp/dev-m2 --model_path bea-exp/models --vocab_path bea-exp/vocab.idx

python run.py --test --data_dir bea-exp/dev-text --m2_dir bea-exp/dev-m2 --model_path bea-exp/models/model.pt --vocab_path bea-exp/vocab.idx --output_path bea-exp/outputs/dev.out

errant_parallel -orig bea-exp/dev-text/source.txt -cor bea-exp/outputs/dev.out -out bea-exp/outputs/dev.m2
errant_compare -ref bea-full-valid.m2 -hyp bea-exp/outputs/dev.m2

python run.py --test --data_dir bea-exp/test-text --m2_dir bea-exp/test-m2 --model_path bea-exp/models/model.pt --vocab_path bea-exp/vocab.idx --output_path bea-exp/outputs/test.out

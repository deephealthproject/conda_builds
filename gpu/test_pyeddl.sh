#!/usr/bin/env bash

set -eo pipefail
source /opt/conda/etc/profile.d/conda.sh

if [ "${1-}" = "cloud" ]; then
    dhealth_args=("-c" "dhealth")
else
    dhealth_args=("--use-local")
fi

examples_dir="/examples"
tests_dir="/tests"

for v in 3.6 3.7 3.8; do
    echo "*** testing ${v} ***"
    conda create -y -n test${v}
    conda activate test${v}
    conda install -y "${dhealth_args[@]}" pyeddl-gpu python=${v} pytest
    pytest "${tests_dir}"
    python3 "${examples_dir}"/NN/1_MNIST/mnist_mlp.py --epochs 1 --small --gpu
    conda deactivate
done

#!/usr/bin/env bash

set -eo pipefail
source /opt/conda/etc/profile.d/conda.sh

if [ ${1-} = "cloud" ]; then
    dhealth_args=("-c" "dhealth")
else
    dhealth_args=("--use-local")
fi

examples_dir="/examples"

echo running example
cp "${examples_dir}"/nn/1_mnist/1_mnist_mlp.cpp example.cpp
conda create -y -n test
conda activate test
conda install -y "${dhealth_args[@]}" eddl-cpu gxx_linux-64=8
x86_64-conda-linux-gnu-g++ -I/opt/conda/envs/test/include -I/opt/conda/envs/test/include/eigen3 -L /opt/conda/envs/test/lib example.cpp -o example -std=c++11 -leddl -pthread
./example --testing --cpu

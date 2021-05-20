#!/usr/bin/env bash

set -eo pipefail

wd=$(mktemp -d)
pushd "${wd}"

source /opt/conda/etc/profile.d/conda.sh

echo getting tests and examples
pyeddl_version=$(conda list -ef -n test3.6 pyeddl-gpu | tail -1 | cut -d '=' -f 2)
wget -q https://github.com/deephealthproject/pyeddl/archive/${pyeddl_version}.tar.gz
tar -xf ${pyeddl_version}.tar.gz --strip-components 1 --wildcards '*/tests' '*/examples'

echo getting example data
wget -q https://www.dropbox.com/s/khrb3th2z6owd9t/mnist_trX.bin
wget -q https://www.dropbox.com/s/m82hmmrg46kcugp/mnist_trY.bin
wget -q https://www.dropbox.com/s/7psutd4m4wna2d5/mnist_tsX.bin
wget -q https://www.dropbox.com/s/q0tnbjvaenb4tjs/mnist_tsY.bin

for v in 3.6 3.7 3.8; do
    conda activate test${v}
    conda install -y pytest
    pytest tests
    python3 examples/NN/1_MNIST/mnist_auto_encoder.py --epochs 1 --small --gpu
    conda deactivate
done

popd
rm -rf "${wd}"

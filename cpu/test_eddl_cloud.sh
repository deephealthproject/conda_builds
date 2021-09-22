#!/usr/bin/env bash

set -eo pipefail

wd=$(mktemp -d)
pushd "${wd}"

source /opt/conda/etc/profile.d/conda.sh

echo getting examples
eddl_version=$(conda search --json --offline --use-local eddl-cpu | grep -m 1 version | sed -E 's/ *"version": "(.*)"/\1/g')
upstream_eddl_version=v${eddl_version::-1}
eddl_url=https://github.com/deephealthproject/eddl/archive/${upstream_eddl_version}.tar.gz
echo "  ${eddl_url}"
wget -q ${eddl_url}
tar -xf ${upstream_eddl_version}.tar.gz --strip-components 1 --wildcards '*/examples'

echo getting example data
mnist_urls=(
    https://www.dropbox.com/s/khrb3th2z6owd9t/mnist_trX.bin
    https://www.dropbox.com/s/m82hmmrg46kcugp/mnist_trY.bin
    https://www.dropbox.com/s/7psutd4m4wna2d5/mnist_tsX.bin
    https://www.dropbox.com/s/q0tnbjvaenb4tjs/mnist_tsY.bin
)
for url in "${mnist_urls[@]}"; do
    echo "  ${url}"
    wget -q "${url}"
done

echo running example
cp examples/nn/1_mnist/1_mnist_mlp.cpp example.cpp
conda create -y -n test
conda activate test
conda install -y -c dhealth eddl-cpu gxx_linux-64=8
x86_64-conda-linux-gnu-g++ -I/opt/conda/envs/test/include -I/opt/conda/envs/test/include/eigen3 -L /opt/conda/envs/test/lib example.cpp -o example -std=c++11 -leddl -pthread
./example --testing --cpu

popd

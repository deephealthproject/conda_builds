#!/usr/bin/env bash

set -eo pipefail

wd=$(mktemp -d)
pushd "${wd}"

source /opt/conda/etc/profile.d/conda.sh

apt-get -y update
apt-get -y install unzip

echo getting tests and examples
pyecvl_version=$(conda list -ef -n test3.6 pyecvl-cpu | tail -1 | cut -d '=' -f 2)
wget -q https://github.com/deephealthproject/pyecvl/archive/${pyecvl_version}.tar.gz
tar -xf ${pyecvl_version}.tar.gz --strip-components 1 --wildcards '*/tests' '*/examples'

echo getting example data
wget -q https://www.dropbox.com/s/fe3bo0206eklofh/data.zip
echo extracting example data
unzip -oq -d examples data.zip
echo extracting MNIST example data
unzip -oq -d examples/data examples/data/mnist.zip

for v in 3.6 3.7 3.8; do
    conda activate test${v}
    conda install -y pytest
    pytest tests
    bash examples/run_all.sh "${PWD}"/examples/data
    conda deactivate
done

popd
rm -rf "${wd}"

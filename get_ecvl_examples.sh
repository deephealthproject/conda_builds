#!/usr/bin/env bash

set -euo pipefail

source /opt/conda/etc/profile.d/conda.sh

target="/"

apt-get -y update && apt-get -y install --no-install-recommends unzip

echo getting examples
mkdir -p "${target}"
ecvl_version=$(conda search --json --offline --use-local ecvl-cpu | grep -m 1 version | sed -E 's/ *"version": "(.*)"/\1/g')
upstream_ecvl_version=v${ecvl_version}
ecvl_url=https://github.com/deephealthproject/ecvl/archive/${upstream_ecvl_version}.tar.gz
echo "  ${ecvl_url}"
wget -q ${ecvl_url}
tar -xf ${upstream_ecvl_version}.tar.gz --strip-components 1 --wildcards '*/examples'

echo getting example data
example_data_url=https://www.dropbox.com/s/fe3bo0206eklofh/data.zip
echo "  ${example_data_url}"
wget -q ${example_data_url}
echo extracting example data
unzip -oq -d examples data.zip
echo extracting MNIST example data
unzip -oq -d examples/data examples/data/mnist.zip

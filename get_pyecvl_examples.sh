#!/usr/bin/env bash

set -eo pipefail
source /opt/conda/etc/profile.d/conda.sh
set -u

die() {
    echo $1 1>&2
    exit 1
}

nargs=1
if [ $# -ne ${nargs} ]; then
    die "Usage: $0 CSTYPE (e.g., $0 cpu)"
fi
cstype=$1

target="/"

apt-get -y update && apt-get -y install --no-install-recommends unzip

echo getting pyecvl tests and examples
mkdir -p "${target}"
pyecvl_version=$(conda search --json --offline --use-local pyecvl-${cstype} | grep -m 1 version | sed -E 's/ *"version": "(.*)"/\1/g')
pyecvl_url=https://github.com/deephealthproject/pyecvl/archive/${pyecvl_version}.tar.gz
echo "  ${pyecvl_url}"
wget -q ${pyecvl_url}
tar -xf ${pyecvl_version}.tar.gz --strip-components 1 --wildcards '*/tests' '*/examples'

echo getting example data
example_data_url=https://www.dropbox.com/s/fe3bo0206eklofh/data.zip
echo "  ${example_data_url}"
wget -q ${example_data_url}
echo extracting example data
unzip -oq -d examples data.zip
echo extracting MNIST example data
unzip -oq -d examples/data examples/data/mnist.zip

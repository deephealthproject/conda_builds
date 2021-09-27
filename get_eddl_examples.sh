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

echo getting examples
mkdir -p "${target}"
eddl_version=$(conda search --json --offline --use-local eddl-${cstype} | grep -m 1 version | sed -E 's/ *"version": "(.*)"/\1/g')
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

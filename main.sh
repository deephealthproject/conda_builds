#!/usr/bin/env bash

set -euo pipefail
set +x

this="${BASH_SOURCE:-$0}"
this_dir=$(cd -P -- "$(dirname -- "${this}")" && pwd -P)

die() {
    echo $1 1>&2
    exit 1
}

nargs=1
if [ $# -ne ${nargs} ]; then
    die "Usage: $0 CSTYPE (e.g., $0 cpu)"
fi
cstype=$1

pushd "${this_dir/cstype}"

make test-eddl
make upload-eddl
make test-eddl-cloud

make test-ecvl
make upload-ecvl
make test-ecvl-cloud

make test-pyeddl
make upload-pyeddl
make test-pyeddl-cloud

make test-pyecvl
make upload-pyecvl
make test-pyecvl-cloud

popd

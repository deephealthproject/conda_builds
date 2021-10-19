#!/usr/bin/env bash

set -euo pipefail

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

pushd "${this_dir}/${cstype}"

make clean-pyecvl
make clean-pyeddl
make clean-ecvl
make clean-eddl

popd

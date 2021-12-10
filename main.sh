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

pushd "${this_dir}/${cstype}"

if [ -z ${SKIP_EDDL:-} ]; then
    make test-eddl
    make upload-eddl
    make test-eddl-cloud
else
    echo "skipping eddl"
fi

if [ -z ${SKIP_ECVL:-} ]; then
    make test-ecvl
    make upload-ecvl
    make test-ecvl-cloud
else
    echo "skipping ecvl"
fi

if [ -z ${SKIP_PYEDDL:-} ]; then
    make test-pyeddl
    make upload-pyeddl
    make test-pyeddl-cloud
else
    echo "skipping pyeddl"
fi

if [ -z ${SKIP_PYECVL:-} ]; then
    make test-pyecvl
    make upload-pyecvl
    make test-pyecvl-cloud
else
    echo "skipping pyecvl"
fi

popd

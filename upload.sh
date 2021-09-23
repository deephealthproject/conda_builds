#!/usr/bin/env bash

set -euo pipefail
this="${BASH_SOURCE-$0}"
this_dir=$(cd -P -- "$(dirname -- "${this}")" && pwd -P)

die() {
    echo $1 1>&2
    exit 1
}

nargs=2
if [ $# -ne ${nargs} ]; then
    die "Usage: $0 LIBNAME CSTYPE (e.g., $0 eddl cpu)"
fi
libname=$1
cstype=$2

rm -rf dhealth
bash "${this_dir}/get_pkg.sh" ${libname} ${cstype}
docker run --rm -i -v ${PWD}:${PWD}:ro conda-upload bash -c "anaconda login --username deephealthproject && find ${PWD}/dhealth -type f -exec anaconda upload -u dhealth {} \;"

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

[ -n "${DH_CONDA_TOKEN:-}" ] || die "DH_CONDA_TOKEN not set"

rm -rf dhealth
bash "${this_dir}/get_pkg.sh" ${libname} ${cstype}
set +x
docker run --rm -i -e DH_CONDA_TOKEN="${DH_CONDA_TOKEN}" -v ${PWD}:${PWD}:ro conda-upload bash -c "find ${PWD}/dhealth -type f -exec anaconda -t ${DH_CONDA_TOKEN} upload -u dhealth --skip-existing {} \;"

#!/usr/bin/env bash

set -euo pipefail

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

pkg=${libname}-${cstype}
img=${libname}-conda-${cstype}
target="dhealth/linux-64"
mkdir -p "${target}"
docker run --rm ${img} bash -c "conda search --json --offline --use-local ${pkg} | grep '\"url\":' | sed -E 's/ *\"url\": \"file:(.*)\",/\1/g'" | while read f; do
    name=$(basename ${f})
    echo "getting ${name}"
    docker run --rm ${img} bash -c "cat ${f}" > "${target}/${name}"
done

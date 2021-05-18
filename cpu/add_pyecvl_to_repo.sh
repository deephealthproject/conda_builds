#!/usr/bin/env bash

set -euo pipefail

pkg_dir="dhealth/linux-64"

for v in 36 37 38; do
    pkg=$(docker run --rm pyecvl-conda bash -c "ls -1 /opt/conda/conda-bld/linux-64/pyecvl-cpu-*-py${v}* | head -n 1")
    echo "adding ${pkg}"
    docker run --rm pyecvl-conda bash -c "cat ${pkg}" > "${pkg_dir}/$(basename ${pkg})"
done

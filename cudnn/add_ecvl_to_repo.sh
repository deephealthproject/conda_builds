#!/usr/bin/env bash

set -euo pipefail

pkg_dir="dhealth/linux-64"

mkdir -p "${pkg_dir}"
for v in 36 37 38; do
    pkg=$(docker run --rm ecvl-conda bash -c "ls -1 /opt/conda/conda-bld/linux-64/ecvl-cudnn-*-py${v}* | head -n 1")
    echo "adding ${pkg}"
    docker run --rm ecvl-conda bash -c "cat ${pkg}" > "${pkg_dir}/$(basename ${pkg})"
done

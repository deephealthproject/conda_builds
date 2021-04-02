#!/usr/bin/env bash

set -euo pipefail

pkg_dir="dhealth/linux-64"

pkg=$(docker run --rm ecvl-conda bash -c 'ls -1 /opt/conda/conda-bld/linux-64/ecvl-cpu-* | head -n 1')
mkdir -p "${pkg_dir}"
docker run --rm ecvl-conda bash -c "cat ${pkg}" > "${pkg_dir}/$(basename ${pkg})"

#!/usr/bin/env bash

set -euo pipefail

pkg_dir="dhealth/linux-64"

for v in 36 37 38; do
    pkg=$(docker run --rm pyecvl-conda bash -c "ls -1 /opt/conda/conda-bld/linux-64/pyecvl-cpu-*-py${v}* | head -n 1")
    echo "adding ${pkg}"
    docker run --rm pyecvl-conda bash -c "cat ${pkg}" > "${pkg_dir}/$(basename ${pkg})"
done

pyecvl_v=$(ls -1 "${pkg_dir}" | grep -m1 pyecvl | cut -d '-' -f 3)
echo downloading tests for pyecvl ${pyecvl_v}
wget -q https://github.com/deephealthproject/pyecvl/archive/${pyecvl_v}.tar.gz
tar xf ${pyecvl_v}.tar.gz
rm -rf tests
mv pyecvl-${pyecvl_v}/tests .
rm -rf pyecvl-${pyecvl_v}

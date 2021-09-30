#!/usr/bin/env bash

set -eo pipefail
source /opt/conda/etc/profile.d/conda.sh

if [ "${1-}" = "cloud" ]; then
    dhealth_args=("-c" "dhealth")
else
    dhealth_args=("--use-local")
fi

examples_dir="/examples"

names=(
    example_dataset_generator
    example_dataset_parser
    example_ecvl_eddl
    example_imgcodecs
    example_imgproc
    example_moments
    example_nifti_dicom
    example_openslide
    example_pipeline
    example_threshold
)

for v in 3.6 3.7 3.8; do
    echo "*** testing ${v} ***"
    conda create -y -n test${v}
    conda activate test${v}
    conda install -y "${dhealth_args[@]}" ecvl-cudnn python=${v} gxx_linux-64=8
    pushd "${examples_dir}"
    for n in "${names[@]}"; do
	echo "  ${n}"
	x86_64-conda-linux-gnu-g++ -DECVL_WITH_DICOM -DECVL_WITH_OPENSLIDE -I/opt/conda/envs/test${v}/include -I/opt/conda/envs/test${v}/include/eigen3 -L /opt/conda/envs/test${v}/lib ${n}.cpp -o ${n} -std=c++17 -lecvl_core -lecvl_eddl -leddl -ldataset -lopencv_core -lyaml-cpp -lopenslide -ldcmdata -ldcmimage -ldcmimgle -ldcmjpeg -li2d -lijg8 -lijg12 -lijg16 -loflog -lofstd -pthread
	./${n}
	rm -fv ${n}
    done
    popd
    conda deactivate
done

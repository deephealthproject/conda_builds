#!/usr/bin/env bash

set -eo pipefail

source /opt/conda/etc/profile.d/conda.sh

apt-get -y update
apt-get -y install unzip

mkdir examples

echo getting examples
ecvl_version=$(conda list -ef -n test3.6 ecvl-cpu | tail -1 | cut -d '=' -f 2)
upstream_ecvl_version=v${ecvl_version}
wget -q https://github.com/deephealthproject/ecvl/archive/${upstream_ecvl_version}.tar.gz
tar -xf ${upstream_ecvl_version}.tar.gz --strip-components 1 --wildcards '*/examples'

echo getting example data
wget -q https://www.dropbox.com/s/fe3bo0206eklofh/data.zip
echo extracting example data
unzip -oq -d examples data.zip
echo extracting MNIST example data
unzip -oq -d examples/data examples/data/mnist.zip

names=(
    example_dataset_generator
    example_dataset_parser
    example_ecvl_eddl
    example_imgcodecs
    example_imgproc
    example_moments
    example_nifti_dicom
    example_openslide
    example_threshold
)

for v in 3.6 3.7 3.8; do
    echo "*** testing ${v} ***"
    conda activate test${v}
    conda install -y gxx_linux-64==7.3.0
    pushd examples
    for n in "${names[@]}"; do
	echo "  ${n}"
	x86_64-conda_cos6-linux-gnu-g++ -DECVL_WITH_DICOM -DECVL_WITH_OPENSLIDE -I/opt/conda/envs/test${v}/include -I/opt/conda/envs/test${v}/include/eigen3 -L /opt/conda/envs/test${v}/lib ${n}.cpp -o ${n} -std=c++17 -lecvl_core -lecvl_eddl -leddl -ldataset -lyaml-cpp -lopenslide -ldcmdata -ldcmimage -ldcmimgle -ldcmjpeg -li2d -lijg8 -lijg12 -lijg16 -loflog -lofstd -lstdc++fs -pthread
	./${n}
	rm -fv ${n}
    done
    popd
    conda deactivate
done

#!/usr/bin/env bash

set -eo pipefail

source /opt/conda/etc/profile.d/conda.sh

apt-get -y update
apt-get -y install unzip
echo getting example data
wget -q https://www.dropbox.com/s/fe3bo0206eklofh/data.zip
unzip data.zip
# unzip -d data data/mnist.zip

cat <<EOF >example.cpp
#include <iostream>
#include "ecvl/core.h"

using namespace ecvl;
using namespace std;

int main() {
    Image img, tmp;
    if (!ImRead("data/test.jpg", img)) {
        return EXIT_FAILURE;
    }
    cout << "ResizeDim: data/test.jpg to test_resized.jpg" << endl;
    ResizeDim(img, tmp, {225, 300}, InterpolationType::nearest);
    ImWrite("test_resized.jpg", tmp);
}
EOF

for v in 3.7 3.8; do
    echo "*** testing ${v} ***"
    conda activate test${v}
    conda install -y gxx_linux-64==7.3.0
    x86_64-conda_cos6-linux-gnu-g++ -I/opt/conda/envs/test${v}/include -L /opt/conda/envs/test${v}/lib example.cpp -o example -std=c++17 -lecvl_core -ldataset -lyaml-cpp -lopenslide -ldcmdata -ldcmimage -ldcmimgle -ldcmjpeg -li2d -lijg8 -lijg12 -lijg16 -loflog -lofstd -lstdc++fs -pthread
    ./example
    rm -fv example
    conda deactivate
done

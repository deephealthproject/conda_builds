#!/usr/bin/env bash

set -eo pipefail

source /opt/conda/etc/profile.d/conda.sh
conda activate ecvl-test
conda install -y gxx_linux-64==7.3.0 unzip
echo getting example data
wget -q https://www.dropbox.com/s/fe3bo0206eklofh/data.zip
unzip data.zip
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
x86_64-conda_cos6-linux-gnu-g++ -I/opt/conda/envs/ecvl-test/include -L /opt/conda/envs/ecvl-test/lib example.cpp -o example -std=c++17 -lecvl_core -ldataset -lyaml-cpp -lstdc++fs -pthread
./example

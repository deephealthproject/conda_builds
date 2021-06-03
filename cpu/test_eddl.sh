#!/usr/bin/env bash

set -eo pipefail

source /opt/conda/etc/profile.d/conda.sh

echo getting examples
cat <<EOF >example.cpp
#include <eddl/apis/eddl.h>
#include <eddl/tensor/tensor.h>

int main() {
    eddl::download_mnist();
    int epochs = 1;
    int batch_size = 1000;
    eddl::layer in = eddl::Input({784});
    eddl::layer l = in;
    l = eddl::Activation(eddl::Dense(l, 128), "relu");
    l = eddl::Activation(eddl::Dense(l, 64), "relu");
    l = eddl::Activation(eddl::Dense(l, 128), "relu");
    eddl::layer out = eddl::Dense(l, 784);
    eddl::model net = eddl::Model({in}, {out});
    eddl::build(net, eddl::sgd(0.001, 0.9),
		{"mean_squared_error"}, {"mean_squared_error"},
		eddl::CS_CPU(-1, "low_mem"));
    eddl::summary(net);
    Tensor* x_train = Tensor::load("mnist_trX.bin");
    x_train->div_(255.0);
    eddl::fit(net, {x_train}, {x_train}, batch_size, epochs);
}
EOF

echo getting example data
wget -q https://www.dropbox.com/s/khrb3th2z6owd9t/mnist_trX.bin
wget -q https://www.dropbox.com/s/m82hmmrg46kcugp/mnist_trY.bin
wget -q https://www.dropbox.com/s/7psutd4m4wna2d5/mnist_tsX.bin
wget -q https://www.dropbox.com/s/q0tnbjvaenb4tjs/mnist_tsY.bin

echo running example
conda activate eddl-test
conda install -y gxx_linux-64==7.3.0
x86_64-conda_cos6-linux-gnu-g++ -I/opt/conda/envs/eddl-test/include -I/opt/conda/envs/eddl-test/include/eigen3 -L /opt/conda/envs/eddl-test/lib example.cpp -o example -std=c++11 -leddl -pthread
./example

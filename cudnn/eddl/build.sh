#!/bin/bash

mkdir build
cd build
cmake -DBUILD_EXAMPLES=OFF \
      -DBUILD_SHARED_LIBS=ON \
      -DBUILD_HPC=OFF \
      -DBUILD_TESTS=OFF \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      -DBUILD_PROTOBUF=ON \
      -DBUILD_TARGET=CUDNN \
      -DBUILD_SUPERBUILD=OFF \
      -DCMAKE_CUDA_COMPILER=${PREFIX}/bin/nvcc \
      -DCMAKE_CUDA_HOST_COMPILER=${CXX} \
      ${SRC_DIR}
make -j${CPU_COUNT}
make install

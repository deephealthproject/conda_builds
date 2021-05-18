#!/bin/bash

mkdir build
cd build
cmake -DECVL_BUILD_DEPS=OFF \
      -DECVL_SHARED=ON \
      -DECVL_BUILD_EXAMPLES=OFF \
      -DECVL_TESTS=OFF \
      -DECVL_WITH_DICOM=ON \
      -DECVL_WITH_OPENSLIDE=ON \
      -DECVL_DATASET=ON \
      -DECVL_BUILD_EDDL=ON \
      -DCMAKE_INSTALL_PREFIX=${PREFIX} \
      ${SRC_DIR}
make -j${CPU_COUNT}
make install

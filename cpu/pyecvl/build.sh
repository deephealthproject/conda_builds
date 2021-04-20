#!/bin/bash

export ECVL_WITH_DICOM=OFF
export ECVL_WITH_OPENSLIDE=OFF
export ECVL_EDDL=ON

export CPATH="${PREFIX}/include/eigen3:${CPATH}"

${PYTHON} setup.py install

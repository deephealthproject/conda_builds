#!/bin/bash

export ECVL_WITH_DICOM=ON
export ECVL_WITH_OPENSLIDE=ON
export ECVL_EDDL=ON

export CPATH="${PREFIX}/include/eigen3:${PREFIX}/include/openslide:${CPATH}"

${PYTHON} setup.py install

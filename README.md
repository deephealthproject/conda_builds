# DeepHealth Conda Builds

[Conda](https://docs.conda.io/en/latest/) recipes for DeepHealth software.

## Installation

DeepHealth packages come in three flavors:

* `*-cpu`: CPU-only
* `*-gpu`: GPU-enabled
* `*-cudnn`: GPU-enabled, with cuDNN support

The gpu-enabled packages support CUDA 10.1 (like Tensorflow).

Note that ECVL/PyECVL does not actually offer cuDNN support. The `cudnn` tag
in this case simply means that the package pulls the corresponding
`eddl-cudnn` and/or `pyeddl-cudnn` dependency.

### [EDDL](https://github.com/deephealthproject/eddl)

```
conda install -c dhealth eddl-cpu
conda install -c dhealth eddl-gpu
conda install -c dhealth -c conda-forge eddl-cudnn
```

### [PyEDDL](https://github.com/deephealthproject/pyeddl)

```
conda install -c dhealth pyeddl-cpu
conda install -c dhealth pyeddl-gpu
conda install -c dhealth pyeddl-cudnn
```

### [ECVL](https://github.com/deephealthproject/ecvl)

```
conda install -c dhealth -c bioconda -c conda-forge ecvl-cpu
conda install -c dhealth -c bioconda -c conda-forge ecvl-gpu
conda install -c dhealth -c bioconda -c conda-forge ecvl-cudnn
```

### [PyECVL](https://github.com/deephealthproject/pyecvl)

```
conda install -c dhealth -c bioconda -c conda-forge pyecvl-cpu
conda install -c dhealth -c bioconda -c conda-forge pyecvl-gpu
conda install -c dhealth -c bioconda -c conda-forge -c conda-forge pyecvl-cudnn
```


## Building packages

The build setup is based on simple Makefiles and Dockerfiles. For instance, to build the eddl-cpu package:

```
cd cpu
make eddl-conda
```

At the end of the build process, the package will be available in the corresponding Docker image. Look for lines like this in the build log:

```
/opt/conda/conda-bld/linux-64/eddl-cpu-0.7.1-h3fd9d12_0.tar.bz2
```

Here is an example of how you can get the package from the image:

```
docker run --rm eddl-conda bash -c "cat /opt/conda/conda-bld/linux-64/eddl-cpu-0.7.1-h3fd9d12_0.tar.bz2" > eddl-cpu-0.7.1-h3fd9d12_0.tar.bz2
```

The Makefile also includes testing targets. After building the package, you can test it with:

```
make test-eddl
```


## Note on EDDL version tags

Conda follows the [PEP 440](https://www.python.org/dev/peps/pep-0440/)
versioning scheme, which is not followed by some EDDL releases. In this cases,
the Conda recipe changes the upstream version in order to make it compatible
with PEP 440. For instance the Conda package for EDDL v0.8.3a has a version
tag of 0.8.3a0.

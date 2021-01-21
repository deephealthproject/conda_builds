# DeepHealth Conda Builds

[Conda](https://docs.conda.io/en/latest/) recipes for DeepHealth software.

To install, run:

```
conda install -c dhealth eddl-cpu  # eddl cpu-only version
conda install -c dhealth eddl-gpu  # eddl gpu-enabled version
conda install -c dhealth pyeddl-cpu  # pyeddl cpu-only version
conda install -c dhealth pyeddl-gpu  # pyeddl gpu-enabled version
```

The gpu-enabled packages support CUDA 10.1 (like Tensorflow).


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

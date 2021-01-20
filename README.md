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


## Note for EDDL 0.5.4a

The EDDL recipes for EDDL 0.5.4a change the upstream version from `v0.5.4a` to
`0.5.4a0`, in order to make it compatible with the Conda versioning scheme
(i.e., [PEP 440](https://www.python.org/dev/peps/pep-0440/)).

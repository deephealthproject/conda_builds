# DeepHealth Conda Builds

[Conda](https://docs.conda.io/en/latest/) recipes for DeepHealth software.

## Installation

[DeepHealth Conda packages](https://anaconda.org/dhealth) come in three flavors:

* `*-cpu`: CPU-only
* `*-gpu`: GPU-enabled
* `*-cudnn`: GPU-enabled, with cuDNN support

The GPU-enabled packages support CUDA 10.1 (like Tensorflow).

Note that ECVL/PyECVL does not actually offer cuDNN support. The `cudnn` tag
in this case simply means that the package pulls the corresponding
`eddl-cudnn` and/or `pyeddl-cudnn` dependency.

### Configuring channels

Before installing, run the following configuration commands (you can omit the
`bioconda` channel if you only want to install EDDL/PyEDDL):

```
conda config --add channels dhealth
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict
```

Make sure you add the channels in the order shown above. Since `--add` adds
the channel to the beginning of the list, the channels section in your
configuration file (`conda config --show`) should now look like this:

```
channel_priority: strict
channels:
  - conda-forge
  - bioconda
  - dhealth
  - defaults
```

### Package dependency

The DeepHealth Toolkit consists of two main C++ libraries:
[EDDL](https://github.com/deephealthproject/eddl) and
[ECVL](https://github.com/deephealthproject/ecvl). Python bindings are also
available for both libraries:
[PyEDDL](https://github.com/deephealthproject/pyeddl) and
[PyECVL](https://github.com/deephealthproject/pyecvl). The dependency graph
is shown below:

```
      +--------+
      | PyECVL |
      +--------+
       ^      ^
       |      |
+------+-+  +-+------+
|  ECVL  |  | PyEDDL |
+--------+  +--------+
        ^    ^
        |    |
      +-+----+-+
      |  EDDL  |
      +--------+
```

For instance, if you install PyEDDL, you will also pull EDDL as a dependency,
while if you install PyECVL you will install all four.

The Conda packages, available from the [dhealth](https://anaconda.org/dhealth)
channel, are named according to a simple `<library>-<target>` scheme (e.g.,
`pyeddl-gpu`). Additionally, most of them (all except `eddl`) are compiled for
a specific Python version. Currently, packages are available for Python 3.6,
3.7 and 3.8. Which one will be pulled depends on the Python version installed
in your environment.

### Example: install Python 3.7 and PyECVL compiled for GPU

```
conda config --add channels dhealth
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict
conda create -y -n dh_toolkit
conda activate dh_toolkit
conda install -y python=3.7 pyecvl-gpu
```

### Speeding up the installation

When popular channels such as conda-forge and bioconda are involved,
[installing packages can take a considerable amount of
time](https://www.anaconda.com/blog/understanding-and-improving-condas-performance). One
of the easiest ways to get a huge speedup is to use
[Mamba](https://mamba.readthedocs.io/en/latest/index.html). The `mamba`
command can be used as a faster drop-in replacement for `conda`. For instance:

```
mamba install -y python=3.7 eddl-cpu
```


## Note on version tags

In some cases, the upstream version tag has been slightly altered to comply
with the [PEP 440](https://www.python.org/dev/peps/pep-0440/) scheme. For
instance, the Conda package for EDDL v0.8.3a has a version tag of 0.8.3a0.

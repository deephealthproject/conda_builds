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


## Note for EDDL 0.5.4a

The EDDL recipes for EDDL 0.5.4a change the upstream version from `v0.5.4a` to
`0.5.4a0`, in order to make it compatible with the Conda versioning scheme
(i.e., [PEP 440](https://www.python.org/dev/peps/pep-0440/)).

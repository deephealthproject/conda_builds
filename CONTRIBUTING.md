# How to contribute

## Building and testing packages

The build setup is based on simple Makefiles and Dockerfiles. For instance, to
build the ecvl-cpu packages:

```
cd cpu
make ecvl-conda
```

At the end of the build process, the packages will be available in the
corresponding Docker image. A bash script is available to extract them:

```
bash ../get_pkg.sh ecvl cpu
```

The Makefile also includes testing targets. After building the packages, you
can test them with:

```
make test-ecvl
```

## Build & Deploy workflow

Makefile targets are listed in the order they're supposed to be executed. The
main actions are: building and testing locally; uploading to Anaconda; testing
installation from the cloud. For instance:

```
make test-eddl
make upload-eddl
make test-eddl-cloud
```

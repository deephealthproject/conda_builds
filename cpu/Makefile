SHELL := /bin/bash

.PHONY: conda-base conda-upload eddl-conda eddl-conda-test test-eddl upload-eddl test-eddl-cloud clean-eddl ecvl-conda ecvl-conda-test test-ecvl upload-ecvl test-ecvl-cloud clean-ecvl pyeddl-conda pyeddl-conda-test test-pyeddl upload-pyeddl test-pyeddl-cloud clean-pyeddl pyecvl-conda pyecvl-conda-test test-pyecvl upload-pyecvl test-pyecvl-cloud clean-pyecvl

# base images
conda-base: ../Dockerfile.cpu-base
	docker build -t conda-cpu-base -f $< .

conda-upload: ../Dockerfile.upload
	docker build -t conda-upload -f $< .

# eddl
eddl-conda: Dockerfile.eddl conda-base
	docker build -t eddl-conda-cpu -f $< .

eddl-conda-test: Dockerfile.eddl-test eddl-conda
	docker build -t eddl-conda-cpu-test -f $< ..

test-eddl: test_eddl.sh eddl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro eddl-conda-cpu-test bash ${PWD}/$<

upload-eddl: eddl-conda conda-upload
	bash ../upload.sh eddl cpu

test-eddl-cloud: test_eddl.sh eddl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro eddl-conda-cpu-test bash ${PWD}/$< cloud

clean-eddl:
	docker rmi -f eddl-conda-cpu-test eddl-conda-cpu

# ecvl
ecvl-conda: Dockerfile.ecvl conda-base
	docker build -t ecvl-conda-cpu -f $< .

ecvl-conda-test: Dockerfile.ecvl-test ecvl-conda
	docker build -t ecvl-conda-cpu-test -f $< ..

test-ecvl: test_ecvl.sh ecvl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro ecvl-conda-cpu-test bash ${PWD}/$<

upload-ecvl: ecvl-conda conda-upload
	bash ../upload.sh ecvl cpu

test-ecvl-cloud: test_ecvl.sh ecvl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro ecvl-conda-cpu-test bash ${PWD}/$< cloud

clean-ecvl:
	docker rmi -f ecvl-conda-cpu-test ecvl-conda-cpu

# pyeddl
pyeddl-conda: Dockerfile.pyeddl conda-base
	docker build -t pyeddl-conda-cpu -f $< .

pyeddl-conda-test: Dockerfile.pyeddl-test pyeddl-conda
	docker build -t pyeddl-conda-cpu-test -f $< ..

test-pyeddl: test_pyeddl.sh pyeddl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro pyeddl-conda-cpu-test bash ${PWD}/$<

upload-pyeddl: pyeddl-conda conda-upload
	bash ../upload.sh pyeddl cpu

test-pyeddl-cloud: test_pyeddl.sh pyeddl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro pyeddl-conda-cpu-test bash ${PWD}/$< cloud

clean-pyeddl:
	docker rmi -f pyeddl-conda-cpu-test pyeddl-conda-cpu

# pyecvl
pyecvl-conda: Dockerfile.pyecvl conda-base
	docker build -t pyecvl-conda-cpu -f $< .

pyecvl-conda-test: Dockerfile.pyecvl-test pyecvl-conda
	docker build -t pyecvl-conda-cpu-test -f $< ..

test-pyecvl: test_pyecvl.sh pyecvl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro pyecvl-conda-cpu-test bash ${PWD}/$<

upload-pyecvl: pyecvl-conda conda-upload
	bash ../upload.sh pyecvl cpu

test-pyecvl-cloud: test_pyecvl.sh pyecvl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro pyecvl-conda-cpu-test bash ${PWD}/$< cloud

clean-pyecvl:
	docker rmi -f pyecvl-conda-cpu-test pyecvl-conda-cpu

SHELL := /bin/bash

.PHONY: conda-base conda-upload ecvl-conda ecvl-conda-test eddl-conda pyecvl-conda pyecvl-conda-test pyeddl-conda pyeddl-conda-test test-ecvl test-ecvl-cloud test-eddl test-eddl-cloud test-pyecvl test-pyecvl-cloud test-pyeddl test-pyeddl-cloud upload-ecvl upload-eddl upload-pyeddl upload-pyecvl

conda-base: ../Dockerfile.cpu-base
	docker build -t conda-cpu-base -t conda-base -f $< .

eddl-conda: Dockerfile.eddl conda-base
	docker build -t eddl-conda-cpu -t eddl-conda -f $< .

ecvl-conda: Dockerfile.ecvl conda-base
	docker build -t ecvl-conda-cpu -t ecvl-conda -f $< .

ecvl-conda-test: Dockerfile.ecvl-test ecvl-conda
	docker build -t ecvl-conda-cpu-test -t ecvl-conda-test -f $< ..

pyeddl-conda: Dockerfile.pyeddl conda-base
	docker build -t pyeddl-conda-cpu -t pyeddl-conda -f $< .

pyeddl-conda-test: Dockerfile.pyeddl-test pyeddl-conda
	docker build -t pyeddl-conda-test -t pyeddl-conda-cpu-test -f $< ..

pyecvl-conda: Dockerfile.pyecvl conda-base
	docker build -t pyecvl-conda-cpu -t pyecvl-conda -f $< .

pyecvl-conda-test: Dockerfile.pyecvl-test pyecvl-conda
	docker build -t pyecvl-conda-test -t pyecvl-conda-cpu-test -f $< ..

test-eddl: eddl-conda
	docker run --rm -v ${PWD}:${PWD}:ro eddl-conda bash ${PWD}/test_eddl.sh

test-ecvl: ecvl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro ecvl-conda-test bash ${PWD}/test_ecvl.sh

test-eddl-cloud: eddl-conda
	docker run --rm -v ${PWD}:${PWD}:ro eddl-conda bash ${PWD}/test_eddl_cloud.sh

test-ecvl-cloud: test_ecvl.sh ecvl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro ecvl-conda-test bash ${PWD}/$< cloud

test-pyeddl: test_pyeddl.sh pyeddl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro pyeddl-conda-test bash ${PWD}/$<

test-pyecvl: test_pyecvl.sh pyecvl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro pyecvl-conda-test bash ${PWD}/$<

test-pyeddl-cloud: test_pyeddl.sh pyeddl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro pyeddl-conda-test bash ${PWD}/$< cloud

test-pyecvl-cloud: test_pyecvl.sh pyecvl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro pyecvl-conda-test bash ${PWD}/$< cloud

conda-upload: ../Dockerfile.upload
	docker build -t conda-upload -f $< .

upload-eddl: eddl-conda conda-upload
	bash ../upload.sh eddl cpu

upload-ecvl: ecvl-conda conda-upload
	bash ../upload.sh ecvl cpu

upload-pyeddl: pyeddl-conda conda-upload
	bash ../upload.sh pyeddl cpu

upload-pyecvl: pyecvl-conda conda-upload
	bash ../upload.sh pyecvl cpu

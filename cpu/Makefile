SHELL := /bin/bash

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

pyecvl-conda: Dockerfile.pyecvl ecvl-conda-test
	docker build -t pyecvl-conda -f Dockerfile.pyecvl .

pyecvl-conda-test: Dockerfile.pyecvl-test pyecvl-conda
	${SHELL} add_pyecvl_to_repo.sh
	docker build -t pyecvl-conda-test -f Dockerfile.pyecvl-test .

pyecvl-conda-test-cloud: Dockerfile.pyecvl-test-cloud
	docker build -t pyecvl-conda-test-cloud -f Dockerfile.pyecvl-test-cloud .

test-eddl: eddl-conda
	docker run --rm -v ${PWD}:${PWD}:ro eddl-conda bash ${PWD}/test_eddl.sh

test-ecvl: ecvl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro ecvl-conda-test bash ${PWD}/test_ecvl.sh

test-eddl-cloud: eddl-conda
	docker run --rm -v ${PWD}:${PWD}:ro eddl-conda bash ${PWD}/test_eddl_cloud.sh

test-ecvl-cloud: test_ecvl.sh ecvl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro ecvl-conda-test bash ${PWD}/$< cloud

test-pyeddl: pyeddl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro pyeddl-conda-test bash ${PWD}/test_pyeddl.sh

test-pyecvl: pyecvl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro pyecvl-conda-test bash ${PWD}/test_pyecvl.sh

test-pyeddl-cloud: test_pyeddl.sh pyeddl-conda-test
	docker run --rm -v ${PWD}:${PWD}:ro pyeddl-conda-test bash ${PWD}/$< cloud

test-pyecvl-cloud: pyecvl-conda-test-cloud
	docker run --rm -v ${PWD}:${PWD}:ro pyecvl-conda-test-cloud bash ${PWD}/test_pyecvl.sh

conda-upload: ../Dockerfile.upload
	docker build -t conda-upload -f $< .

upload-eddl: eddl-conda conda-upload
	bash ../upload.sh eddl cpu

upload-ecvl: ecvl-conda conda-upload
	bash ../upload.sh ecvl cpu

upload-pyeddl: pyeddl-conda conda-upload
	bash ../upload.sh pyeddl cpu

.PHONY: eddl-conda pyeddl-conda pyeddl-conda-test test-eddl test-pyeddl test-eddl-cloud test-pyeddl-cloud conda-upload upload-eddl

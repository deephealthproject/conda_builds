SHELL := /bin/bash
DEVICE := 0

eddl-conda: Dockerfile.eddl
	docker build -t eddl-conda -f Dockerfile.eddl .

eddl-conda-test: Dockerfile.eddl-test eddl-conda
	${SHELL} add_eddl_to_repo.sh
	docker build -t eddl-conda-test -f Dockerfile.eddl-test .

eddl-conda-test-cloud: Dockerfile.eddl-test-cloud
	docker build -t eddl-conda-test-cloud -f Dockerfile.eddl-test-cloud .

ecvl-conda: Dockerfile.ecvl
	docker build -t ecvl-conda -f Dockerfile.ecvl .

ecvl-conda-test: Dockerfile.ecvl-test ecvl-conda
	${SHELL} add_ecvl_to_repo.sh
	docker build -t ecvl-conda-test -f Dockerfile.ecvl-test .

ecvl-conda-test-cloud: Dockerfile.ecvl-test-cloud
	docker build -t ecvl-conda-test-cloud -f Dockerfile.ecvl-test-cloud .

pyeddl-conda: Dockerfile.pyeddl eddl-conda-test
	docker build -t pyeddl-conda -f Dockerfile.pyeddl .

pyeddl-conda-test: Dockerfile.pyeddl-test pyeddl-conda
	${SHELL} add_pyeddl_to_repo.sh
	docker build -t pyeddl-conda-test -f Dockerfile.pyeddl-test .

pyeddl-conda-test-cloud: Dockerfile.pyeddl-test-cloud
	docker build -t pyeddl-conda-test-cloud -f Dockerfile.pyeddl-test-cloud .

pyecvl-conda: Dockerfile.pyecvl ecvl-conda-test
	docker build -t pyecvl-conda -f Dockerfile.pyecvl .

pyecvl-conda-test: Dockerfile.pyecvl-test pyecvl-conda
	${SHELL} add_pyecvl_to_repo.sh
	docker build -t pyecvl-conda-test -f Dockerfile.pyecvl-test .

pyecvl-conda-test-cloud: Dockerfile.pyecvl-test-cloud
	docker build -t pyecvl-conda-test-cloud -f Dockerfile.pyecvl-test-cloud .

test-eddl: eddl-conda-test
	docker run --gpus "device=${DEVICE}" --rm -v ${PWD}:${PWD}:ro eddl-conda-test bash ${PWD}/test_eddl.sh

test-ecvl: ecvl-conda-test
	docker run --gpus "device=${DEVICE}" --rm -v ${PWD}:${PWD}:ro ecvl-conda-test bash ${PWD}/test_ecvl.sh

test-eddl-cloud: eddl-conda-test-cloud
	docker run --gpus "device=${DEVICE}" --rm -v ${PWD}:${PWD}:ro eddl-conda-test-cloud bash ${PWD}/test_eddl.sh

test-ecvl-cloud: ecvl-conda-test-cloud
	docker run --gpus "device=${DEVICE}" --rm -v ${PWD}:${PWD}:ro ecvl-conda-test-cloud bash ${PWD}/test_ecvl.sh

test-pyeddl: pyeddl-conda-test
	docker run --gpus "device=${DEVICE}" --rm -v ${PWD}:${PWD}:ro pyeddl-conda-test bash ${PWD}/test_pyeddl.sh

test-pyecvl: pyecvl-conda-test
	docker run --gpus "device=${DEVICE}" --rm -v ${PWD}:${PWD}:ro pyecvl-conda-test bash ${PWD}/test_pyecvl.sh

test-pyeddl-cloud: pyeddl-conda-test-cloud
	docker run --gpus "device=${DEVICE}" --rm -v ${PWD}:${PWD}:ro pyeddl-conda-test-cloud bash ${PWD}/test_pyeddl.sh

test-pyecvl-cloud: pyecvl-conda-test-cloud
	docker run --gpus "device=${DEVICE}" --rm -v ${PWD}:${PWD}:ro pyecvl-conda-test-cloud bash ${PWD}/test_pyecvl.sh

.PHONY: eddl-conda eddl-conda-test pyeddl-conda pyeddl-conda-test test-eddl test-pyeddl test-eddl-cloud test-pyeddl-cloud

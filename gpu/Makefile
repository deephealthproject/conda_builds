SHELL := /bin/bash
DEVICE := 0

# base images
conda-base: ../Dockerfile.gpu-base
	docker build -t conda-gpu-base -f $< .

conda-upload: ../Dockerfile.upload
	docker build -t conda-upload -f $< .

# eddl
eddl-conda: Dockerfile.eddl conda-base
	docker build -t eddl-conda-gpu -f $< .

eddl-conda-test: Dockerfile.eddl-test eddl-conda
	docker build -t eddl-conda-gpu-test -f $< ..

test-eddl: test_eddl.sh eddl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro eddl-conda-gpu-test bash ${PWD}/$<

upload-eddl: eddl-conda conda-upload
	bash ../upload.sh eddl gpu

test-eddl-cloud: test_eddl.sh eddl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro eddl-conda-gpu-test bash ${PWD}/$< cloud


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

test-ecvl: ecvl-conda-test
	docker run --gpus "device=${DEVICE}" --rm -v ${PWD}:${PWD}:ro ecvl-conda-test bash ${PWD}/test_ecvl.sh

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

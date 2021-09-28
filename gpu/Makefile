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

# ecvl
ecvl-conda: Dockerfile.ecvl conda-base
	docker build -t ecvl-conda-gpu -f $< .

ecvl-conda-test: Dockerfile.ecvl-test ecvl-conda
	docker build -t ecvl-conda-gpu-test -f $< ..

test-ecvl: test_ecvl.sh ecvl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro ecvl-conda-gpu-test bash ${PWD}/$

upload-ecvl: ecvl-conda conda-upload
	bash ../upload.sh ecvl gpu

test-ecvl-cloud: test_ecvl.sh ecvl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro ecvl-conda-gpu-test bash ${PWD}/$< cloud

# pyeddl
pyeddl-conda: Dockerfile.pyeddl conda-base
	docker build -t pyeddl-conda-gpu -f $< .

pyeddl-conda-test: Dockerfile.pyeddl-test pyeddl-conda
	docker build -t pyeddl-conda-gpu-test -f $< ..

test-pyeddl: test_pyeddl.sh pyeddl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro pyeddl-conda-gpu-test bash ${PWD}/$<

upload-pyeddl: pyeddl-conda conda-upload
	bash ../upload.sh pyeddl gpu

test-pyeddl-cloud: test_pyeddl.sh pyeddl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro pyeddl-conda-gpu-test bash ${PWD}/$< cloud


pyecvl-conda: Dockerfile.pyecvl ecvl-conda-test
	docker build -t pyecvl-conda -f Dockerfile.pyecvl .

pyecvl-conda-test: Dockerfile.pyecvl-test pyecvl-conda
	${SHELL} add_pyecvl_to_repo.sh
	docker build -t pyecvl-conda-test -f Dockerfile.pyecvl-test .

pyecvl-conda-test-cloud: Dockerfile.pyecvl-test-cloud
	docker build -t pyecvl-conda-test-cloud -f Dockerfile.pyecvl-test-cloud .

test-pyecvl: pyecvl-conda-test
	docker run --gpus "device=${DEVICE}" --rm -v ${PWD}:${PWD}:ro pyecvl-conda-test bash ${PWD}/test_pyecvl.sh

test-pyecvl-cloud: pyecvl-conda-test-cloud
	docker run --gpus "device=${DEVICE}" --rm -v ${PWD}:${PWD}:ro pyecvl-conda-test-cloud bash ${PWD}/test_pyecvl.sh

.PHONY: eddl-conda eddl-conda-test pyeddl-conda pyeddl-conda-test test-eddl test-pyeddl test-eddl-cloud test-pyeddl-cloud

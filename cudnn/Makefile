SHELL := /bin/bash
DEVICE := 0

.PHONY: conda-base conda-upload eddl-conda eddl-conda-test test-eddl upload-eddl test-eddl-cloud ecvl-conda ecvl-conda-test test-ecvl upload-ecvl test-ecvl-cloud pyeddl-conda pyeddl-conda-test test-pyeddl upload-pyeddl test-pyeddl-cloud pyecvl-conda pyecvl-conda-test test-pyecvl upload-pyecvl test-pyecvl-cloud

# base images
conda-base: ../Dockerfile.cudnn-base
	docker build -t conda-cpu-base -f ../Dockerfile.cpu-base .
	docker build -t conda-cudnn-base -f $< .

conda-upload: ../Dockerfile.upload
	docker build -t conda-upload -f $< .

# eddl
eddl-conda: Dockerfile.eddl conda-base
	docker build -t eddl-conda-cudnn -f $< .

eddl-conda-test: Dockerfile.eddl-test eddl-conda
	docker build -t eddl-conda-cudnn-test -f $< ..

test-eddl: test_eddl.sh eddl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro eddl-conda-cudnn-test bash ${PWD}/$<

upload-eddl: eddl-conda conda-upload
	bash ../upload.sh eddl cudnn

test-eddl-cloud: test_eddl.sh eddl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro eddl-conda-cudnn-test bash ${PWD}/$< cloud

# ecvl
ecvl-conda: Dockerfile.ecvl conda-base
	docker build -t ecvl-conda-cudnn -f $< .

ecvl-conda-test: Dockerfile.ecvl-test ecvl-conda
	docker build -t ecvl-conda-cudnn-test -f $< ..

test-ecvl: test_ecvl.sh ecvl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro ecvl-conda-cudnn-test bash ${PWD}/$<

upload-ecvl: ecvl-conda conda-upload
	bash ../upload.sh ecvl cudnn

test-ecvl-cloud: test_ecvl.sh ecvl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro ecvl-conda-cudnn-test bash ${PWD}/$< cloud

# pyeddl
pyeddl-conda: Dockerfile.pyeddl conda-base
	docker build -t pyeddl-conda-cudnn -f $< .

pyeddl-conda-test: Dockerfile.pyeddl-test pyeddl-conda
	docker build -t pyeddl-conda-cudnn-test -f $< ..

test-pyeddl: test_pyeddl.sh pyeddl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro pyeddl-conda-cudnn-test bash ${PWD}/$<

upload-pyeddl: pyeddl-conda conda-upload
	bash ../upload.sh pyeddl cudnn

test-pyeddl-cloud: test_pyeddl.sh pyeddl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro pyeddl-conda-cudnn-test bash ${PWD}/$< cloud

# pyecvl
pyecvl-conda: Dockerfile.pyecvl conda-base
	docker build -t pyecvl-conda-cudnn -t pyecvl-conda -f $< .

pyecvl-conda-test: Dockerfile.pyecvl-test pyecvl-conda
	docker build -t pyecvl-conda-test -t pyecvl-conda-cudnn-test -f $< ..

test-pyecvl: test_pyecvl.sh pyecvl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro pyecvl-conda-cudnn-test bash ${PWD}/$<

upload-pyecvl: pyecvl-conda conda-upload
	bash ../upload.sh pyecvl cudnn

test-pyecvl-cloud: test_pyecvl.sh pyecvl-conda-test
	docker run --rm -e NVIDIA_VISIBLE_DEVICES=${DEVICE} -v ${PWD}:${PWD}:ro pyecvl-conda-cudnn-test bash ${PWD}/$< cloud

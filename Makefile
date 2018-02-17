IMAGE_NAME=nathamanath/mollypictures
VERSION=$(shell cat ./version.txt)
ENVIRONMENT=production
REBAR=${HOME}/.mix/rebar3

release: build docker

run:
	${REBAR} release
	./_build/default/rel/mollypictures/bin/mollypictures console

build:
	${REBAR} as prod release

docker:
	docker build -t ${IMAGE_NAME} .
	docker tag  ${IMAGE_NAME} ${IMAGE_NAME}:latest
	docker tag  ${IMAGE_NAME} ${IMAGE_NAME}:${VERSION}

PHONY: docker build run

.PHONY: build

all: clean lint test

MAJOR_VERSION := 1
MINOR_VERSION := 0
BUILD_VERSION ?= $(USER)
VERSION := $(MAJOR_VERSION).$(MINOR_VERSION).$(BUILD_VERSION)

PACKAGE_PREFIX := github.com/clickandobey/golang-dockerized-webservice
ORGANIZATION := clickandobey
SERVICE_NAME := golang-dockerized-webservice

APP_IMAGE_NAME := ${ORGANIZATION}-${SERVICE_NAME}-app
APP_PORT := 9001
APP_CONTAINER_NAME := ${APP_IMAGE_NAME}

ROOT_DIRECTORY := `pwd`

ifneq ($(DEBUG),)
  INTERACTIVE=--interactive
  DETACH=--env "DETACH=None"
else
  INTERACTIVE=--env "INTERACTIVE=None"
  DETACH=--detach
endif

# Code build Targets

build: run-build

run-build: $(shell find . -name "*.go") $(shell find . -name "go.mod")
	@echo "Building webserver..."
	@go build -o ${ROOT_DIRECTORY}/build/golang-dockerized-webservice
	@echo "Built webserver."
	@touch run-build

# Local App Targets

run-webservice: run-build
	@${ROOT_DIRECTORY}/build/golang-dockerized-webservice

# Docker App Targets

docker-build-app: docker/Dockerfile.app
	@docker build \
		-t ${APP_IMAGE_NAME} \
		-f docker/Dockerfile.app \
		.
	@touch docker-build-app

docker-run-webservice: docker-build-app stop-webservice
	@docker run \
		--rm \
		${DETACH} \
		${INTERACTIVE} \
		--name ${APP_CONTAINER_NAME} \
		-p ${APP_PORT}:9001 \
		${APP_IMAGE_NAME}
	@${ROOT_DIRECTORY}/test/scripts/wait_for_webapp ${APP_PORT}

stop-webservice:
	@docker kill ${APP_CONTAINER_NAME} || true

# Testing

test: unit-test integration-test
test-docker: unit-test-docker integration-test-docker

unit-test:
	@go test ${PACKAGE_PREFIX}/... -cover

unit-test-docker:
	@docker run \
		--rm \
		-v `pwd`:/test \
		golang:1.15-buster \
			/bin/bash -c \
				"cd /test; go test github.com/clickandobey/golang-dockerized-webservice/... -cover"

integration-test: docker-run-webservice
	@echo Implement Me!

integration-test-docker: docker-run-webservice
	@echo Implement Me!

# Linting

lint: lint-markdown lint-go

lint-markdown:
	@echo Linting markdown files...
	@docker run \
		--rm \
		-v `pwd`:/workspace \
		wpengine/mdl \
			/workspace
	@echo Markdown linting complete.

lint-go:
	@echo Linting Go files...
	@docker run \
		--rm \
		-v ${ROOT_DIRECTORY}:/workspace \
		golang:1.15-buster \
			/workspace/scripts/lint /workspace
	@echo Go linting complete

# Utilities

clean:
	@echo Cleaning Make Targets...
	@rm -f run-build
	@rm -f docker-build-app
	@echo Cleaned Make Targets.
	@echo Removing Build Targets...
	@rm -rf ${ROOT_DIRECTORY}/build
	@echo Removed Build Targets.

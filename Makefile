.PHONY: build test

all: clean lint test

MAJOR_VERSION := 1
MINOR_VERSION := 0
BUILD_VERSION ?= $(USER)
VERSION := $(MAJOR_VERSION).$(MINOR_VERSION).$(BUILD_VERSION)

PACKAGE_PREFIX := github.com/clickandobey/golang-dockerized-webservice
ORGANIZATION := clickandobey
SERVICE_NAME := golang-dockerized-webservice

APP_IMAGE_NAME := ${ORGANIZATION}-${SERVICE_NAME}-app
GITHUB_REPO := "docker.pkg.github.com"
APP_REPO_IMAGE_NAME := ${GITHUB_REPO}/${ORGANIZATION}/${SERVICE_NAME}/webservice:${VERSION}
APP_PORT := 9001
APP_CONTAINER_NAME := ${APP_IMAGE_NAME}

TEST_IMAGE_NAME := ${ORGANIZATION}-${SERVICE_NAME}-test
TEST_CONTAINER_NAME := ${TEST_IMAGE_NAME}

ROOT_DIRECTORY := `pwd`
TEST_DIRECTORY := ${ROOT_DIRECTORY}/test
TEST_PYTHON_DIRECTORY := $(TEST_DIRECTORY)/python

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

docker-build-app: $(shell find . -name "*.go") $(shell find . -name "go.mod") docker/Dockerfile.app
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

build-test-docker: docker/Dockerfile.test $(shell find test/python -name "*")
	@docker build \
		-t $(TEST_IMAGE_NAME) \
		-f docker/Dockerfile.test \
		.
	@touch build-test-docker

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

integration-test: stop-webservice docker-run-webservice setup-test-env
	@cd $(TEST_PYTHON_DIRECTORY); \
	pipenv run python -m pytest \
		--durations=10 \
		${TEST_OUTPUT_FLAG} \
		${FAILURE_FLAG} \
		-m 'integration ${TEST_STRING}' \
		.

integration-test-docker: build-test-docker stop-webservice docker-run-webservice
	@docker run \
		--rm \
		${INTERACTIVE} \
		--env "ENVIRONMENT=docker" \
		--name ${TEST_CONTAINER_NAME} \
		--link ${APP_CONTAINER_NAME} \
		${TEST_IMAGE_NAME} \
			--durations=10 \
			-x \
			-s \
			-m 'integration ${TEST_STRING}' \
			${PDB} \
			/test/python

# Release

release: docker-build-app github-docker-login
	@echo Tagging webservice image to ${APP_REPO_IMAGE_NAME}...
	@docker tag ${APP_IMAGE_NAME} ${APP_REPO_IMAGE_NAME}
	@echo Pushing webservice docker image to ${APP_REPO_IMAGE_NAME}...
	@docker push ${APP_REPO_IMAGE_NAME}

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
	@rm -f build-test-docker
	@echo Cleaned Make Targets.
	@echo Removing Build Targets...
	@rm -rf ${ROOT_DIRECTORY}/build
	@echo Removed Build Targets.

setup-test-env:
	@cd ${TEST_PYTHON_DIRECTORY}; \
	pipenv install --dev

update-python-dependencies:
	@cd ${TEST_PYTHON_DIRECTORY}; \
	pipenv lock

github-docker-login:
	@echo ${GITHUB_TOKEN} | docker login https://${GITHUB_REPO} -u ${GITHUB_USER} --password-stdin
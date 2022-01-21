.EXPORT_ALL_VARIABLES:
_DOCKER_IMAGE=unfor19/iamlive-docker
_DOCKER_TAG=latest
_DOCKER_FULL_TAG=$(_DOCKER_IMAGE):$(_DOCKER_TAG)
_DOCKER_LAMBDA_FULL_TAG=$(_DOCKER_IMAGE):lambda-$(_DOCKER_TAG)
_DOCKER_CONTAINER_NAME=iamlive-docker
_DOCKER_LAMBDA_CONTAINER_NAME=$(_DOCKER_CONTAINER_NAME)-lambda
_CA_DIR=${PWD}/.certs

help:                                 ## Available make commands
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's~:~~' | sed -e 's~##~~'

usage: help         

build:                                ## Build Docker image and compile
	docker build -t "$(_DOCKER_FULL_TAG)" --target app .

build-lambda:                         ## Build Docker image and compile
	docker build -t "$(_DOCKER_LAMBDA_FULL_TAG)" --target lambda .

run:                                  ## Run iamlive container for the first time
	docker run -p 80:10080 \
        -p 443:10080 \
        --name "$(_DOCKER_CONTAINER_NAME)" \
        -it "$(_DOCKER_FULL_TAG)"

genca:                                ## Generate CA cert+key locally
	@./generate_ca.sh

run-ca: genca                         ## Run iamlive-docker container for the first time with pre-generated CA cert+key
	docker run -p 80:10080 \
        -p 443:10080 \
		-v $(_CA_DIR):/home/appuser/.iamlive/ \
        --name "$(_DOCKER_CONTAINER_NAME)" \
        -it "$(_DOCKER_FULL_TAG)"

run-lambda: genca                     ## Run iamlive-docker-lambda container for the first time
	docker run -p 80:10080 \
        -p 443:10080 \
		-v $(_CA_DIR):/root/.iamlive/ \
        --name "$(_DOCKER_LAMBDA_CONTAINER_NAME)" \
        -it "$(_DOCKER_LAMBDA_FULL_TAG)"

copy:                                 ## Copy CA certificates from iamlive-docker container
	docker cp "$(_DOCKER_CONTAINER_NAME):/home/appuser/.iamlive/" ~/

copy-lambda:                          ## Copy CA certificates from iamlive-docker-lambda container
	docker cp "$(_DOCKER_LAMBDA_CONTAINER_NAME):/root/.iamlive/" ~/

start:                                ## Start a stopped iamlive-docker container
	docker start -i "$(_DOCKER_CONTAINER_NAME)"

start-lambda:                         ## Start a stopped iamlive-docker-lambda container
	docker start -i "$(_DOCKER_LAMBDA_CONTAINER_NAME)"

stop:                                 ## Stop iamlive-docker container
	docker stop "$(_DOCKER_CONTAINER_NAME)"

stop-lambda:                          ## Stop iamlive-docker-lambda container
	docker stop "$(_DOCKER_LAMBDA_CONTAINER_NAME)"	

remove:                               ## Remove iamlive-docker-lambda container
	docker rm -f "$(_DOCKER_CONTAINER_NAME)"

remove-lambda:                        ## Remove iamlive-docker-lambda container
	docker rm -f "$(_DOCKER_LAMBDA_CONTAINER_NAME)"

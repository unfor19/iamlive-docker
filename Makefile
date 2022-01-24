.EXPORT_ALL_VARIABLES:
_DOCKER_IMAGE=unfor19/iamlive-docker
_DOCKER_TAG=latest
_DOCKER_FULL_TAG=$(_DOCKER_IMAGE):$(_DOCKER_TAG)
_DOCKER_ECS_INIT_FULL_TAG=$(_DOCKER_IMAGE):ecs-init-$(_DOCKER_TAG)
_DOCKER_CONTAINER_NAME=iamlive-docker
_ALPINECI_FULL_TAG=unfor19/alpine-ci:latest-7437025b
_CA_DIR=${PWD}/.certs

help:                                 ## Available make commands
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's~:~~' | sed -e 's~##~~'

usage: help         

build:                                ## Build Docker image and compile
	docker build -t "$(_DOCKER_FULL_TAG)" --target app .

build-ecs-init:                       ## Build ECS init Docker image and compile
	docker build --file Dockerfile.ecs.init -t "$(_DOCKER_ECS_INIT_FULL_TAG)" --target app .

run:                                  ## Run iamlive container for the first time
	docker run -p 80:10080 \
        -p 443:10080 \
        --name "$(_DOCKER_CONTAINER_NAME)" \
        -it "$(_DOCKER_FULL_TAG)"

run-dev:                              ## Run iamlive and exec into it
	docker run -p 80:10080 \
        -p 443:10080 \
		--entrypoint bash \
        --name "$(_DOCKER_CONTAINER_NAME)" \
        -it "$(_DOCKER_FULL_TAG)"


genca:                                ## Generate CA cert+key locally
	@if [ ! -d "$(_CA_DIR)" ]; then \
		docker run -i --rm -v ${PWD}:/src/ --workdir /src/ --entrypoint ./generate_ca.sh $(_ALPINECI_FULL_TAG); \
	fi

run-ca: genca                         ## Run iamlive-docker container for the first time with pre-generated CA cert+key
	docker run -p 80:10080 \
        -p 443:10080 \
		-v $(_CA_DIR):/home/appuser/.iamlive/ \
        --name "$(_DOCKER_CONTAINER_NAME)" \
        -it "$(_DOCKER_FULL_TAG)"

copy:                                 ## Copy CA certificates from iamlive-docker container
	docker cp "$(_DOCKER_CONTAINER_NAME):/home/appuser/.iamlive/" ~/

start:                                ## Start a stopped iamlive-docker container
	docker start -i "$(_DOCKER_CONTAINER_NAME)"

stop:                                 ## Stop iamlive-docker container
	docker stop "$(_DOCKER_CONTAINER_NAME)"

remove:                               ## Remove iamlive-docker container
	docker rm -f "$(_DOCKER_CONTAINER_NAME)"

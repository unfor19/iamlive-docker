.EXPORT_ALL_VARIABLES:
_DOCKER_IMAGE=unfor19/iamlive-docker
_DOCKER_TAG=latest
_DOCKER_FULL_TAG=$(_DOCKER_IMAGE):$(_DOCKER_TAG)
_DOCKER_CONTAINER_NAME=iamlive-docker

help:                ## Available make commands
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's~:~~' | sed -e 's~##~~'

usage: help         

build:               ## Build Docker image and compile
	docker build -t "$(_DOCKER_FULL_TAG)" .

run:                 ## Run iamlive container for the first time
	docker run -p 80:10080 \
        -p 443:10080 \
        --name iamlive-docker \
        -it "$(_DOCKER_FULL_TAG)" \
        --mode proxy \
        --bind-addr 0.0.0.0:10080 \
        --force-wildcard-resource \
        --output-file "/app/iamlive.log"

copy:
	docker cp "$(_DOCKER_CONTAINER_NAME):/home/appuser/.iamlive/" ~/

stop:                ## Stop iamlive container
	docker stop "$(_DOCKER_CONTAINER_NAME)"

start:               ## Run hot-reload app
	docker start -i "$(_DOCKER_CONTAINER_NAME)"

remove:
	docker rm -f "$(_DOCKER_CONTAINER_NAME)"
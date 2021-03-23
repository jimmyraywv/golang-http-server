.DEFAULT_GOAL := build

##################################
# git
##################################
GIT_URL ?= $(shell git remote get-url --push origin)
GIT_COMMIT ?= $(shell git rev-parse HEAD)
#GIT_SHORT_COMMIT := $(shell git rev-parse --short HEAD)
TIMESTAMP := $(shell date '+%Y-%m-%d_%I:%M:%S%p')

IMAGE_REGISTRY ?= public.ecr.aws/r2l1x4g2
IMAGE_REPO ?= go-http-server
DOCKERFILE ?= Dockerfile
NO_CACHE ?= true
GIT_COMMIT_IN ?=
GIT_URL_IN ?=

ifeq ($(strip $(GIT_COMMIT)),)
GIT_COMMIT := $(GIT_COMMIT_IN)
endif

ifeq ($(strip $(GIT_URL)),)
GIT_URL := $(GIT_URL_IN)
endif

VERSION_HASH := $(shell echo $(GIT_COMMIT)|cut -c 1-10)
# $(info [$(VERSION_HASH)])
VERSION_FROM_FILE ?= $(shell head -n 1 version)
VERSION ?=

ifeq ($(strip $(VERSION_HASH)),)
VERSION := $(VERSION_FROM_FILE)
else
VERSION := $(VERSION_FROM_FILE)-$(VERSION_HASH)
endif

READ_ONLY ?= --read-only
PORT_EXT ?= 8080
PORT_INT ?= 8080
NAME ?= read-only

.PHONY: build push pull meta run

build:	meta
	$(info    [BUILD_CONTAINER_IMAGE])
	docker build -f $(DOCKERFILE) . -t $(IMAGE_REGISTRY)/$(IMAGE_REPO):$(VERSION) --no-cache=$(NO_CACHE)
	$(info	)

push:	meta
	$(info    [PUSH_CONTAINER_IMAGE])
	docker push $(IMAGE_REGISTRY)/$(IMAGE_REPO):$(VERSION)
	$(info	)

pull:	meta
	$(info    [PUSH_CONTAINER_IMAGE])
	docker pull $(IMAGE_REGISTRY)/$(IMAGE_REPO):$(VERSION)
	$(info	)

meta:
	$(info    [METADATA])
	$(info    timestamp: [$(TIMESTAMP)])
	$(info    git commit: [$(GIT_COMMIT)])
	$(info    git URL: [$(GIT_URL)])
	$(info    Container image version: [$(VERSION)])
	$(info	)

run:
	docker run --rm $(READ_ONLY) --name $(NAME) -p $(PORT_EXT):$(PORT_INT) -v vol1:/tmp $(IMAGE_REGISTRY)/$(IMAGE_REPO):$(VERSION)





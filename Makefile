PLATFORM ?= linux/amd64
PROGRESS ?= auto
REVISION ?= $(shell git rev-list -1 HEAD -- Containerfile)
SOURCE_DATE_EPOCH := $(shell git log -1 --format=%ct $(REVISON))
REGISTRY ?= drgrovellc
NAME = radicale
VERSION := latest
SHELL := /bin/bash
BUILD_DIR=out
IMAGE_DIR=$(BUILD_DIR)/image

export SOURCE_DATE_EPOCH
export TZ=UTC
export LANG=C.UTF-8
export LC_ALL=C
export BUILDKIT_MULTI_PLATFORM=1
export DOCKER_BUILDKIT=1

all: \
	image

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(IMAGE_DIR): $(BUILD_DIR)
	mkdir -p $(IMAGE_DIR)

.PHONY: image
image: $(BUILD_DIR)/image/index.json
$(BUILD_DIR)/image/index.json: $(BUILD_DIR)/image Containerfile $(SRCS)
	docker \
		buildx \
		build \
		--ulimit nofile=2048:16384 \
		--tag $(REGISTRY)/$(NAME):$(VERSION) \
		--output \
			name=$(NAME),type=oci,rewrite-timestamp=true,force-compression=true,annotation.org.opencontainers.image.revision=$(REVISION),annotation.org.opencontainers.image.version=$(VERSION),tar=true,dest=- \
		$(EXTRA_ARGS) \
		$(NOCACHE_FLAG) \
		$(CHECK_FLAG) \
		--platform=$(PLATFORM) \
		--progress=$(PROGRESS) \
		-f Containerfile \
		. \
		| tar -C $(IMAGE_DIR) -mx

.PHONY: load-image
load-image: image
	cd out/image
	tar -cf - . | docker load

.PHONY: image-digest
.ONESHELL:
image-digest: image
	@cat $(IMAGE_DIR)/index.json | jq -r '.manifests[].digest | sub ("sha256:";"")'

.PHONY: shell
shell: image load-image image-digest
	$(call run-container,--rm,$(REGISTRY)/$(NAME):$(VERSION),/bin/sh)

.PHONY: verify
verify: all
	@make all BUILD_DIR=out2
	@cmp $(IMAGE_DIR)/index.json out2/image/index.json && echo "Digests match!"

define run-container
	docker run -it \
		$(1) \
		--entrypoint $(3) \
		-v $$HOME/.aws:/home/user/.aws:rw \
		-v $$HOME/.kube:/home/user/.kube:rw \
		$(2)
endef

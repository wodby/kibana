-include env_make

# Accept legacy build arguments during the image revision transition.
BASE_IMAGE_REVISION ?= $(BASE_IMAGE_STABILITY_TAG)
IMAGE_REVISION ?= $(STABILITY_TAG)

KIBANA_VER ?= 7.17.29
KIBANA_VER_MINOR=$(shell echo "${KIBANA_VER}" | grep -oE '^[0-9]+\.[0-9]+')

NODEJS_VER ?= $(shell wget -qO- "https://raw.githubusercontent.com/elastic/kibana/v$(KIBANA_VER)/.node-version")

TAG ?= $(KIBANA_VER_MINOR)

ifneq ($(IMAGE_REVISION),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(IMAGE_REVISION)
    else
        override TAG := $(IMAGE_REVISION)
    endif
endif

ifneq ($(BASE_IMAGE_REVISION),)
    BASE_IMAGE_TAG := $(BASE_IMAGE_TAG)-$(BASE_IMAGE_REVISION)
endif

REPO = wodby/kibana
NAME = kibana-$(KIBANA_VER)

.PHONY: build test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) \
		--build-arg NODEJS_VER=$(NODEJS_VER) \
		--build-arg KIBANA_VER=$(KIBANA_VER) \
		./

test:
	cd ./tests && IMAGE=$(REPO):$(TAG) NAME=$(NAME) ES_VER=$(KIBANA_VER_MINOR) ./run.sh

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) -e DEBUG=1 $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)
	-IMAGE=$(REPO):$(TAG) ES_VER=$(KIBANA_VER_MINOR) docker compose -f tests/compose.yml down -v

release: build push

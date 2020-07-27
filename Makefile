-include env_make

KIBANA_VER ?= 7.8.1
KIBANA_VER_MINOR=$(shell echo "${KIBANA_VER}" | grep -oE '^[0-9]+\.[0-9]+')

NODEJS_VER ?= $(shell wget -qO- "https://raw.githubusercontent.com/elastic/kibana/v$(KIBANA_VER)/.node-version")

TAG ?= $(KIBANA_VER_MINOR)

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

ifneq ($(BASE_IMAGE_STABILITY_TAG),)
    BASE_IMAGE_TAG := $(BASE_IMAGE_TAG)-$(BASE_IMAGE_STABILITY_TAG)
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

release: build push

-include env_make

KIBANA_VER ?= 6.1.2

MINOR_VER=$(shell echo "${KIBANA_VER}" | grep -oE '^[0-9]+\.[0-9]+?')

TAG ?= $(MINOR_VER)

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

REPO = wodby/kibana
NAME = kibana-$(KIBANA_VER)

.PHONY: build test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) --build-arg KIBANA_VER=$(KIBANA_VER) ./

test:
	IMAGE=$(REPO):$(TAG) NAME=$(NAME) ES_VER=$(MINOR_VER) ./test.sh

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

#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

if [[ -n "${TRAVIS}" ]]; then
    sudo sysctl -w vm.max_map_count=262144
fi

docker-compose up -d
docker-compose exec elasticsearch make check-ready wait_seconds=5 max_try=30 -f /usr/local/bin/actions.mk
docker-compose exec kibana make check-ready wait_seconds=5 max_try=30 -f /usr/local/bin/actions.mk
docker-compose down

#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

docker-compose up -d
docker-compose exec -T elasticsearch make check-ready wait_seconds=5 max_try=30 -f /usr/local/bin/actions.mk
docker-compose exec -T kibana make check-ready wait_seconds=5 max_try=30 -f /usr/local/bin/actions.mk
docker-compose down

#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

docker-compose up -d
docker-compose exec elasticsearch make check-ready wait_seconds=5 max_try=12 delay_seconds=20 -f /usr/local/bin/actions.mk
docker-compose exec kibana make check-ready wait_seconds=10 max_try=30 delay_seconds=60 -f /usr/local/bin/actions.mk
docker-compose down

#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
  set -x
fi

if [[ "${1}" == 'make' ]]; then
    gosu kibana "${@}" -f /usr/local/bin/actions.mk
else
    gosu kibana "${@}"
fi
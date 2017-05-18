# Kibana docker container image

[![Build Status](https://travis-ci.org/wodby/kibana.svg?branch=master)](https://travis-ci.org/wodby/kibana)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/kibana.svg)](https://hub.docker.com/r/wodby/kibana)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/kibana.svg)](https://hub.docker.com/r/wodby/kibana)

## Supported tags and respective `Dockerfile` links:

- [`5.4`, `latest` (*5.4/Dockerfile*)](https://github.com/wodby/kibana/tree/master/5.4/Dockerfile)

## Actions

Usage:
```
make COMMAND [params ...]

commands:
    check-ready [host max_try wait_seconds]
 
default params values:
    host localhost
    max_try 1
    wait_seconds 1
```

Examples:

```bash
# Wait for Kibana to start
docker exec -ti [ID] make check-ready max_try=10 wait_seconds=3 -f /usr/local/bin/actions.mk
```

## Using in production

Deploy Kibana container to your own server via [![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby](https://wodby.com).

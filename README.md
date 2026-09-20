# Kibana Docker Container Image

[![Build Status](https://github.com/wodby/kibana/workflows/Build%20docker%20image/badge.svg)](https://github.com/wodby/kibana/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/kibana.svg)](https://hub.docker.com/r/wodby/kibana)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/kibana.svg)](https://hub.docker.com/r/wodby/kibana)

## Docker Images

Use image revision tags such as `wodby/kibana:7-rN` to select a Wodby image revision.
Major and minor tags use the repository release number. Full-version tags such as
`wodby/kibana:7.17.29-r0` start at `r0` for each exact upstream version.
Every published versioned revision tag has a matching annotated Git tag pointing to its release commit.
Existing tags remain available after support for their major or minor version ends.
See [release tags](https://github.com/wodby/kibana/tags) for available revisions and the [image revision policy](https://github.com/wodby/images#image-revisions) for upgrade guidance.
Existing SemVer image tags remain available.

- All images based on Alpine Linux
- Base image: [node](https://hub.docker.com/_/node)
- [GitHub actions builds](https://github.com/wodby/kibana/actions) 
- [Docker Hub](https://hub.docker.com/r/wodby/kibana)

Supported tags and respective `Dockerfile` links:

- `7.17`, `7`, `latest` [_(Dockerfile)_](https://github.com/wodby/kibana/tree/master/Dockerfile)

## Environment Variables

| Variable                     | Default Value               | Description |
|------------------------------|-----------------------------|-------------|
| `KIBANA_SERVER_NAME`         | `kibana`                    |             |
| `KIBANA_SERVER_HOST`         | `0`                         |             |
| `KIBANA_ELASTICSEARCH_HOSTS` | `http://elasticsearch:9200` |             |

## Orchestration Actions

Usage:
```
make COMMAND [params ...]
 
commands:
    check-ready [host max_try wait_seconds delay_seconds]
 
default params values:
    host localhost
    max_try 1
    wait_seconds 1
    delay_seconds 0
```

## Deployment

Deploy Kibana with Elasticsearch to your own server via [![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby](https://wodby.com/stacks/elasticsearch).


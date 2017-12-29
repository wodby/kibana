# Kibana Docker Container Image

[![Build Status](https://travis-ci.org/wodby/kibana.svg?branch=master)](https://travis-ci.org/wodby/kibana)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/kibana.svg)](https://hub.docker.com/r/wodby/kibana)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/kibana.svg)](https://hub.docker.com/r/wodby/kibana)
[![Docker Layers](https://images.microbadger.com/badges/image/wodby/kibana.svg)](https://microbadger.com/images/wodby/kibana)
[![Wodby Slack](http://slack.wodby.com/badge.svg)](http://slack.wodby.com)

## Docker Images

* All images are based on Alpine Linux
* Base image: [wodby/alpine](https://github.com/wodby/alpine)
* [TravisCI builds](https://travis-ci.org/wodby/kibana) 
* [Docker Hub](https://hub.docker.com/r/wodby/kibana)

Supported tags and respective `Dockerfile` links:

* `6`, `6.1`, `latest` [_(Dockerfile)_](https://github.com/wodby/kibana/tree/master/Dockerfile)
* `6.0` [_(Dockerfile)_](https://github.com/wodby/kibana/tree/master/Dockerfile)
* `5`, `5.6` [_(Dockerfile)_](https://github.com/wodby/kibana/tree/master/Dockerfile)
* `5.5` [_(Dockerfile)_](https://github.com/wodby/kibana/tree/master/Dockerfile)
* `5.4` [_(Dockerfile)_](https://github.com/wodby/kibana/tree/master/Dockerfile)

For better reliability we additionally release images with stability tags (`wodby/kibana:6-X.X.X`) which correspond to [git tags](https://github.com/wodby/kibana/releases). We **strongly recommend** using images only with stability tags. 

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

Deploy Kibana with Elasticsearch to your own server via [![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby](https://cloud.wodby.com/stackhub/b4d10a3f-c28f-431f-a6e6-ac0137e27097/overview).

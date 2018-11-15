# SonarQube Scanner

[![Build Status](https://travis-ci.com/Flaconi/docker-sonar-scanner.svg?branch=master)](https://travis-ci.com/Flaconi/docker-sonar-scanner)

[![flaconi/sonar-scanner](https://dockeri.co/image/flaconi/sonar-scanner)](https://hub.docker.com/r/flaconi/sonar-scanner/)

This repository provides the SonarQube Scanner binary for testing against SonarQube or SonarCloud.


## Docker Options

#### Environment variables

none

#### Mount points

Your project needs to be mounted into `/sonar` inside the Docker container.


## Usage

```bash
$ docker run -it --rm -v "mydir:/sonar" flaconi/sonar-scanner [opts]
```


## Building

```bash
# Build locally
$ make build

# Test
$ make test
```

#!/usr/bin/env bash

set -e
set -u
set -o pipefail

IMAGE="${1}"

docker run --rm "${IMAGE}" --version | grep -E 'SonarScanner [.0-9]+'

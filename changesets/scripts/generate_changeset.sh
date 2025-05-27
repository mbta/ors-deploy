#!/usr/bin/env bash

mkdir -p ../tmp
mkdir -p ../files

docker build -t ors-changeset-generator .
docker run -v "$(pwd)/../":/app ors-changeset-generator "$@"


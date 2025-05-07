#!/bin/bash

cached=false
no_clean=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --search-key=*)
      search_key=$(printf '%q' "${1#*=}")
      ;;
    --search-value=*)
      search_value=$(printf '%q' "${1#*=}")
      ;;
    --cached)
      cached=true
      ;;
    esac
  shift
done

mkdir -p ../tmp
mkdir -p ../files

docker build -t ors-changeset-generator .
docker run -v "$(pwd)":/app -v "$(pwd)"/../files:/app/files -v "$(pwd)"/../tmp:/app/tmp ors-changeset-generator "$search_key" "$search_value" "$cached"
  

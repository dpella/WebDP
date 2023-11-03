#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "Usage:"
    echo "  $0 PKG_NAME"
    exit
fi

OPENAPI_GENERATOR_IMAGE=openapitools/openapi-generator-cli:latest-release
OPENAPI_GENERATOR="docker run --rm -v $PWD:/local $OPENAPI_GENERATOR_IMAGE"

PKG_NAME=$1
API_FILE="api/WebDP-1.0.0.yml"
OUT_DIR="stub/python/$PKG_NAME"
TARGET="python-flask"

rm -rf $OUT_DIR
mkdir -p $OUT_DIR

# Generate a python server stub
$OPENAPI_GENERATOR generate \
  -i /local/$API_FILE \
  -o /local/$OUT_DIR \
  -g $TARGET \
  --additional-properties=packageName=$PKG_NAME

#!/bin/bash

set -e

OPENAPI_GENERATOR_IMAGE=openapitools/openapi-generator-cli:latest-release
OPENAPI_GENERATOR="docker run --rm -v $PWD:/local $OPENAPI_GENERATOR_IMAGE"

PKG_NAME=webdp_client
API_FILE="api/WebDP-1.0.0.yml"
OUT_DIR="stub/python/$PKG_NAME"
TARGET="python"

rm -rf $OUT_DIR
mkdir -p $OUT_DIR

# Generate a python client stub
$OPENAPI_GENERATOR generate \
  -i /local/$API_FILE \
  -o /local/$OUT_DIR \
  -g $TARGET \
  --additional-properties=packageName=$PKG_NAME

# Fix permissions
sudo chown vscode:vscode -R $OUT_DIR
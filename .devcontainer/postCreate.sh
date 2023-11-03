#!/bin/bash

echo "*** Pulling openapi-generator Docker image"
docker pull openapitools/openapi-generator-cli:latest-release

echo "*** Installing jupyterlab and matplotlib for demoing"
pip3 install jupyterlab matplotlib

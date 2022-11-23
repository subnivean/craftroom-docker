#!/bin/bash

SCRIPT_PATH=$(dirname $(realpath -s $0))

docker run --rm \
  -v /home/pi/ambientweather-docker/data/:/awdata \
  -v $SCRIPT_PATH/data:/data \
  -v $SCRIPT_PATH/src:/app \
  allinone-py311 ./app.sh


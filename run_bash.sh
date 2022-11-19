#!/bin/bash

SCRIPT_PATH=$(dirname $(realpath -s $0))

docker run --rm -it \
  -v $SCRIPT_PATH/data:/data \
  -v /home/pi/ambientweather-docker/data/:/awdata \
  -v $SCRIPT_PATH/src:/app \
  craftroom /bin/bash --rcfile /bashrc


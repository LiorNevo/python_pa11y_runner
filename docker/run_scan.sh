#! /bin/bash

docker run \
    --rm \
    -v ${PWD}/output:/opt/output \
    -v ${PWD}/input:/opt/input \
    -e URL_FILE=/opt/input/urls.txt \
    --name scanner \
    scanner
#! /bin/bash

docker run \
    --rm \
    -v ${PWD}/output:/opt/output \
    -v ${PWD}:/opt/scanner \
    -e URL_FILE=/opt/scanner/urls.txt \
    -e INPUT_PATH=/opt/scanner/input \
    --name scanner \
    scanner
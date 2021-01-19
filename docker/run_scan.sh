#! /bin/bash

docker run \
    --rm \
    -v ${PWD}/output:/opt/output \
    -v ${PWD}/input:/opt/input \
    -e URL_FILE=/opt/input/urls.txt \
    -e INPUT_PATH=/opt/input \
    -e URL=https://www.mishpatech.co.il \
    --name scanner \
    scanner
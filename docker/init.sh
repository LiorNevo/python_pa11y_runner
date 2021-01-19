#!/bin/bash
set -e

SECONDS=0
COLOR_PINK=35
COLOR_GREEN=32
COLOR_RED=31
COLOR_YELLOW=33
COLOR_BLUE=34

printColor() {
    local COLOR=29
    if [ "$2" != "" ]; then
        COLOR=$2
    fi
    printf "\e[1;${COLOR}m%-6s\e[m" "$1"
    echo
}

trapHandler() {
    SCRIPT_NAME="$0"
    LASTLINE="$1"
    LASTERR="$2"
    printColor "ERROR: in -> ${SCRIPT_NAME}: line ${LASTLINE}: exit status of last command: ${LASTERR}" $COLOR_RED
}

trap '[ $? -eq 0 ] && exit 0 || trapHandler ${LINENO} $?' EXIT

scan_from_urls_file() {
    printColor "Scanning from url file ${URL_FILE}" $COLOR_YELLOW
    while IFS="" read -r p || [ -n "$p" ]; do 
        if [ ! -z "$p" ]; then
            timestamp=$(date -u +%m_%d_%Y)
            url=$(echo $p | awk '{print $1}')
            name=$(echo $p | awk '{print $2}')
            printColor "Scanning $url, saving to ${name}_${timestamp}" $COLOR_GREEN
            pa11y "$url" > /opt/output/${name}_${timestamp} || true
            printColor "Done" $COLOR_PINK
        fi
    done < "$URL_FILE"
}

scan_from_input_path() {
    printColor "Scanning from input path ${1}" $COLOR_YELLOW
    for FILE in ${1}/*.{htm,html}; do
        if [ -f "${FILE}" ]; then
            timestamp=$(date -u +%m_%d_%Y)
            name=$(echo $FILE | sed -e "s/\//_/g" | sed -e "s/\./_/g")
            printColor "Scanning file ${FILE}, saving to ${name}_${timestamp}" $COLOR_GREEN
            pa11y "$FILE" > /opt/output/${name}_${timestamp} || true
            printColor "Done" $COLOR_PINK
        fi
    done
    for DIRECTORY in ${1}/*; do
        if [ -d "${DIRECTORY}" ]; then
            scan_from_input_path ${DIRECTORY}
        fi
    done
}

scan() {
    pushd /opt/scanner
    mkdir -p /opt/output
    if [ ! -z "${URL_FILE}" ]; then
        scan_from_urls_file
    fi
    if [ ! -z "${INPUT_PATH}" ]; then
        scan_from_input_path ${INPUT_PATH}
    fi
}

scan
#!/bin/bash
set -e

SECONDS=0
COLOR_PINK=35
COLOR_GREEN=32
COLOR_RED=31
COLOR_YELLOW=33
COLOR_BLUE=34
FOUND_FILES=false

printColor() {
    local COLOR=29
    if [ "$2" != "" ]; then
        COLOR=$2
    fi
    printf "\e[1;${COLOR}m%-6s\e[m" "${1}"
    echo
}

trapHandler() {
    SCRIPT_NAME="$0"
    LASTLINE="$1"
    LASTERR="$2"
    printColor "ERROR: in -> ${SCRIPT_NAME}: line ${LASTLINE}: exit status of last command: ${LASTERR}" $COLOR_RED
}

trap '[ $? -eq 0 ] && exit 0 || trapHandler ${LINENO} $?' EXIT

execute_scan() {
    printColor "Scanning $1, saving reports to $2.html" $COLOR_GREEN
    pa11y --reporter html "$1" > /opt/output/$2.html || true
    printColor "Scanning $1, saving reports to $2.csv" $COLOR_GREEN
    pa11y --reporter csv "$1" > /opt/output/$2.csv || true
    printColor "Done" $COLOR_PINK
}

scan_from_urls_file() {
    printColor "Scanning from url file ${URL_FILE}" $COLOR_YELLOW
    if [ ! -f "${URL_FILE}" ]; then
        printColor "Could not find file ${URL_FILE}" $COLOR_RED
    else
        while IFS="" read -r p || [ -n "$p" ]; do 
            if [ ! -z "$p" ]; then
                timestamp=$(date -u +%m_%d_%Y)
                url=$(echo $p | awk '{print $1}')
                name=$(echo $p | awk '{print $2}')
                execute_scan $url ${name}_${timestamp}
            fi
        done < "$URL_FILE"
    fi
}

scan_from_input_path() {
    printColor "Scanning from input path ${1}" $COLOR_YELLOW
    for file in ${1}/*.{htm,html}; do
        if [ -f "${file}" ]; then
            timestamp=$(date -u +%m_%d_%Y)
            name=$(echo $file | sed -e "s/\//_/g" | sed -e "s/\./_/g")
            execute_scan $file ${name}_${timestamp}
        fi
    done
    for directory in ${1}/*; do
        if [ -d "${directory}" ]; then
            scan_from_input_path ${directory}
        fi
    done
}

scan() {
    pushd /opt/scanner
    if [ ! -z "${URL_FILE}" ]; then
        scan_from_urls_file
    fi
    scan_from_input_path /opt/input
    if [ "${FOUND_FILES}" != "true" ]; then
        printColor "No files were scanned. See documentation" $COLOR_RED
    fi
}

scan
#!/bin/bash
set -e

SECONDS=0
COLOR_PINK=35
COLOR_GREEN=32
COLOR_RED=31
COLOR_YELLOW=33
COLOR_BLUE=34
URL_FILE="/opt/scanner/urls.txt"

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

scan() {
    pushd /opt/scanner
    mkdir -p /opt/scanner/output
    while IFS="" read -r p || [ -n "$p" ]; do 
        if [ ! -z "$p" ]; then
            timestamp=$(date -u +%m_%d_%Y)
            url=$(echo $p | awk '{print $1}')
            name=$(echo $p | awk '{print $2}')
            printColor "Scanning $url, saving to ${name}_${timestamp}.csv" $COLOR_GREEN
            pa11y "$url" > /opt/scanner/output/${name}_${timestamp}.csv || true
            printColor "Done" $COLOR_PINK
        fi
    done < "$URL_FILE"
}

scan
# /bin/bash
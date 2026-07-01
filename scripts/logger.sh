#!/bin/bash

LOG_FILE="logs/cloudsec.log"

mkdir -p logs

log(){

    LEVEL="$1"
    MESSAGE="$2"

    echo "$(date '+%Y-%m-%d %H:%M:%S') [$LEVEL] $MESSAGE" >> "$LOG_FILE"

}
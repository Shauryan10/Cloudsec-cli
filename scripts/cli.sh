#!/bin/bash

SCAN_MODE="all"
OUTPUT_FORMAT="html"

show_help() {

cat << EOF

CloudSec CLI

Usage:

cloudsec scan
cloudsec scan --linux
cloudsec scan --docker
cloudsec scan --aws
cloudsec scan --k8s

Options

--json
--pdf
--html
--version
--help

EOF

}
while [[ $# -gt 0 ]]
do

case "$1" in

scan)

ACTION="scan"
shift
;;

--linux)

SCAN_MODE="linux"
shift
;;

--docker)

SCAN_MODE="docker"
shift
;;

--aws)

SCAN_MODE="aws"
shift
;;

--k8s)

SCAN_MODE="k8s"
shift
;;

--json)

OUTPUT_FORMAT="json"
shift
;;

--pdf)

OUTPUT_FORMAT="pdf"
shift
;;

--html)

OUTPUT_FORMAT="html"
shift
;;

--help)

show_help
exit 0
;;

--version)

echo "CloudSec v1.0"
exit 0
;;

*)

echo "Unknown option $1"
exit 1
;;

esac

done

export SCAN_MODE
export OUTPUT_FORMAT
export ACTION
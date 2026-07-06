#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

PASS=0
WARN=0

check_cmd() {

    printf "%-25s" "$1"

    if command -v "$2" >/dev/null 2>&1
    then
        echo -e "${GREEN}FOUND${RESET}"
        PASS=$((PASS+1))
    else
        echo -e "${YELLOW}MISSING${RESET}"
        WARN=$((WARN+1))
    fi

}

echo ""
echo "==============================================="
echo "         CloudSec CLI Installer"
echo "==============================================="
echo ""

echo -e "${BLUE}Project:${RESET} $ROOT_DIR"
echo ""

####################################################
# OS CHECK
####################################################

echo "Checking Operating System..."

OS=$(uname)

case "$OS" in
Linux)

echo -e "${GREEN}Linux detected${RESET}"
;;

Darwin)

echo -e "${GREEN}macOS detected${RESET}"
;;

*)

echo -e "${RED}Unsupported Operating System${RESET}"
exit 1
;;

esac

echo ""

####################################################
# CREATE DIRECTORIES
####################################################

echo "Creating directories..."

mkdir -p "$ROOT_DIR/reports"
mkdir -p "$ROOT_DIR/reports/archive"
mkdir -p "$ROOT_DIR/history"
mkdir -p "$ROOT_DIR/logs"

echo -e "${GREEN}Directories ready${RESET}"

echo ""

####################################################
# PERMISSIONS
####################################################

echo "Setting executable permissions..."

chmod +x "$ROOT_DIR/bin/cloudsec"

find "$ROOT_DIR/scripts" -name "*.sh" -exec chmod +x {} \;

echo -e "${GREEN}Permissions updated${RESET}"

echo ""

####################################################
# DEPENDENCIES
####################################################

echo "Checking dependencies..."

echo ""

check_cmd "bash" bash
check_cmd "curl" curl
check_cmd "python3" python3
check_cmd "docker" docker
check_cmd "kubectl" kubectl
check_cmd "aws" aws
check_cmd "jq" jq

echo ""

####################################################
# REPORT
####################################################

echo "==============================================="

echo "Installation Summary"

echo ""

echo "Dependencies Found : $PASS"

echo "Missing Optional   : $WARN"

echo ""

echo "Project Ready."

echo ""

echo "Run CloudSec using"

echo ""

echo "bin/cloudsec"

echo ""

echo "==============================================="
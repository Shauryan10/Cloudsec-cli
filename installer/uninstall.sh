#!/bin/bash

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo ""
echo "CloudSec Uninstaller"
echo ""

read -p "Delete reports, history and logs? (y/n): " CHOICE

if [ "$CHOICE" = "y" ]; then

rm -rf "$ROOT_DIR/reports"

rm -rf "$ROOT_DIR/history"

rm -rf "$ROOT_DIR/logs"

echo "Project data removed."

else

echo "Nothing removed."

fi

echo ""

echo "CloudSec binaries remain untouched."

echo ""
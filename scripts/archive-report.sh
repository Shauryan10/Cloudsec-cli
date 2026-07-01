#!/bin/bash

REPORT_DIR="reports"
ARCHIVE_DIR="$REPORT_DIR/archive"

mkdir -p "$ARCHIVE_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

DEST="$ARCHIVE_DIR/$TIMESTAMP"

mkdir -p "$DEST"

for file in \
    security-report.html \
    security-report.json \
    security-report.pdf \
    security-report.md
do
    if [ -f "$REPORT_DIR/$file" ]; then
        cp "$REPORT_DIR/$file" "$DEST/"
    fi
done

echo "Reports archived to: $DEST"
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

# Fix the CSS relative path in the archived HTML report so it resolves
# correctly from reports/archive/<timestamp>/ (two levels deeper than reports/)
if [ -f "$DEST/security-report.html" ]; then
    sed -i '' 's|href="../templates/style.css"|href="../../templates/style.css"|g' \
        "$DEST/security-report.html"
fi

echo "Reports archived to: $DEST"
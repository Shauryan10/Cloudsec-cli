#!/bin/bash

HISTORY_FILE="history/scan-history.csv"

if [ ! -f "$HISTORY_FILE" ]; then
    exit 0
fi

LINES=$(wc -l < "$HISTORY_FILE")

if [ "$LINES" -lt 2 ]; then
    exit 0
fi

CURRENT=$(tail -1 "$HISTORY_FILE")
PREVIOUS=$(tail -2 "$HISTORY_FILE" | head -1)

CURRENT_RISK=$(echo "$CURRENT" | cut -d',' -f2)
CURRENT_COMP=$(echo "$CURRENT" | cut -d',' -f3)

PREVIOUS_RISK=$(echo "$PREVIOUS" | cut -d',' -f2)
PREVIOUS_COMP=$(echo "$PREVIOUS" | cut -d',' -f3)

echo ""
echo "=============================="
echo " Previous Scan Comparison"
echo "=============================="

echo "Previous Risk Score : $PREVIOUS_RISK"
echo "Current Risk Score  : $CURRENT_RISK"

if [ "$CURRENT_RISK" -lt "$PREVIOUS_RISK" ]; then
    echo "Risk Trend          : IMPROVED ✅"
elif [ "$CURRENT_RISK" -gt "$PREVIOUS_RISK" ]; then
    echo "Risk Trend          : WORSENED ❌"
else
    echo "Risk Trend          : NO CHANGE"
fi

echo ""

echo "Previous Compliance : $PREVIOUS_COMP%"
echo "Current Compliance  : $CURRENT_COMP%"

if [ "$CURRENT_COMP" -gt "$PREVIOUS_COMP" ]; then
    echo "Compliance Trend    : IMPROVED ✅"
elif [ "$CURRENT_COMP" -lt "$PREVIOUS_COMP" ]; then
    echo "Compliance Trend    : DECREASED ❌"
else
    echo "Compliance Trend    : NO CHANGE"
fi
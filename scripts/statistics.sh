#!/bin/bash

HISTORY_FILE="history/scan-history.csv"

if [ ! -f "$HISTORY_FILE" ]; then
    exit 0
fi

TOTAL_SCANS=$(wc -l < "$HISTORY_FILE")

if [ "$TOTAL_SCANS" -eq 0 ]; then
    exit 0
fi

AVG_RISK=$(awk -F',' '
{
sum+=$2
}
END{
if(NR>0)
printf "%.0f",sum/NR
}' "$HISTORY_FILE")

AVG_COMP=$(awk -F',' '
{
sum+=$3
}
END{
if(NR>0)
printf "%.0f",sum/NR
}' "$HISTORY_FILE")

MAX_RISK=$(awk -F',' '
BEGIN{max=0}
{
if($2>max) max=$2
}
END{
print max
}' "$HISTORY_FILE")

MIN_RISK=$(awk -F',' '
NR==1{
min=$2
}
{
if($2<min) min=$2
}
END{
print min
}' "$HISTORY_FILE")

echo ""
echo "=============================="
echo " CloudSec Statistics"
echo "=============================="

echo "Total Scans        : $TOTAL_SCANS"
echo "Average Risk Score : $AVG_RISK"
echo "Highest Risk Score : $MAX_RISK"
echo "Lowest Risk Score  : $MIN_RISK"
echo "Average Compliance : ${AVG_COMP}%"
echo ""
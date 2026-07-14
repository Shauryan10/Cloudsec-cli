#!/bin/bash

BUCKET_NAME="cloudsec-cli-reports"

REPORT_DIR="reports"

TIMESTAMP=$(date +"%Y/%m/%d/%H-%M-%S")



PREFIX="$TIMESTAMP"

echo "Uploading reports to S3..."

aws s3 cp "$REPORT_DIR" \
"s3://$BUCKET_NAME/$PREFIX/" \
--recursive

if [ $? -eq 0 ]; then

echo ""
echo "==========================================="
echo " Reports uploaded successfully!"
echo "==========================================="

echo "s3://$BUCKET_NAME/$PREFIX/"

else

echo ""

echo "S3 Upload Failed"

fi
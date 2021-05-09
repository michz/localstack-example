#!/usr/bin/env bash

QUEUE_NAME="test1"
BUCKET_NAME="test1"

AWS_DEFAULT_REGION=us-west-2
AWS="aws --region=$AWS_DEFAULT_REGION --endpoint-url=http://localhost:4566"

QUEUE_URL="http://localhost:4566/000000000000/$QUEUE_NAME"

$AWS sqs create-queue --queue-name $QUEUE_NAME
$AWS s3api create-bucket --bucket $BUCKET_NAME
$AWS s3api put-bucket-notification-configuration \
    --bucket $BUCKET_NAME \
    --notification-configuration file://notification.json


echo "\

# Test with:
alias aws='aws --endpoint-url=http://localhost:4566'
aws s3 cp test.txt s3://test1/test/test.txt
aws sqs receive-message --queue-url http://localhost:4566/000000000000/$QUEUE_NAME
aws sqs delete-message --queue-url http://localhost:4566/000000000000/$QUEUE_NAME --receipt-handle COPY_FROM_COMMAND_ABOVE
"


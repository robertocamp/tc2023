#!/bin/bash

# Set variables for bucket name and file name
BUCKET="brahma-dev02"
IMAGE="brahma01.png"
REGION="us-east-2"

# Create the S3 bucket
aws s3api create-bucket --bucket "${BUCKET}" --region "${REGION}" --create-bucket-configuration LocationConstraint=${REGION}

# create a dirt-simple index file
echo "This is my static web site." > index.html

# copy the index file to the bucket
aws s3 cp index.html s3://$BUCKET


# Copy the local image file to the S3 bucket
aws s3 cp "$IMAGE" "s3://$BUCKET/"


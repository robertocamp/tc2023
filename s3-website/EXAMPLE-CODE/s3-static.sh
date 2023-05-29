#!/bin/bash

BUCKET="brahma-dev02"
REGION="us-east-2"
FILE="index.html"
IMAGE="brahma01.png"


aws s3api create-bucket --bucket "${BUCKET}" --region "${REGION}" --create-bucket-configuration LocationConstraint=${REGION}
aws s3 cp "$FILE" "s3://$BUCKET/"
aws s3 cp "$IMAGE" "s3://$$BUCKET/" 


aws s3api put-public-access-block --bucket "${BUCKET}" --public-access-block-configuration "BlockPublicPolicy=false" # 2
aws s3api put-bucket-policy --bucket "${BUCKET}" --policy '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::'"${BUCKET}"'/*"
 
            ]
        }
    ]
}' # 3


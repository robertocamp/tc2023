#!/bin/bash

BUCKET="tc2023-qslr-static"
REGION="us-east-2"
#aws s3api create-bucket --bucket "${BUCKET}" --region $REGION > /dev/null # 1
aws s3api create-bucket --bucket "${BUCKET}" --region "${REGION}" --create-bucket-configuration LocationConstraint=${REGION}
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


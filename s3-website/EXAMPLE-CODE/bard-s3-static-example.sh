#!/bin/bash

# Create the S3 bucket
aws s3 create-bucket --bucket my-bucket

# Create the index.html file
echo "This is my static web site." > index.html

# Upload the index.html file to the S3 bucket
aws s3 cp index.html s3://my-bucket

# Set the bucket policy to allow public access
aws s3api put-bucket-policy --bucket my-bucket --policy '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-bucket/*"
    }
  ]
}'

# Open the web browser to the S3 bucket URL
open http://my-bucket.s3-website-us-east-1.amazonaws.com/


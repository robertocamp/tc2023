#!/bin/bash

# Set variables for bucket name and file name
bucket_name="your-bucket-name"
file_name="/path/to/local/file"

# Create the S3 bucket
aws s3api create-bucket --bucket "$bucket_name" --region your-region

# Copy the local file to the S3 bucket
aws s3 cp "$file_name" "s3://$bucket_name/"

echo "File copied to S3 bucket successfully!"

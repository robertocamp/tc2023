#!/bin/bash

# Set the bucket name as a shell variable
bucket_name="my-bucket"

# Define the policy document with the bucket ARN using variable substitution
policy_document=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowGetObject",
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::$bucket_name/*"
    }
  ]
}
EOF
)

# Display the policy document
echo "$policy_document"

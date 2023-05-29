#!/bin/bash

# Set variables for bucket name and file name
bucket_name="your-bucket-name"
file_name="/path/to/local/image.png"

# Create the S3 bucket
aws s3api create-bucket --bucket "$bucket_name" --region your-region

# Copy the local image file to the S3 bucket
aws s3 cp "$file_name" "s3://$bucket_name/"

# Configure bucket for static website hosting
aws s3 website "s3://$bucket_name" --index-document index.html --error-document error.html

# Create an index.html file with image display code
cat <<EOF > index.html
<html>
  <body>
    <img src="image.png" alt="My Image">
  </body>
</html>
EOF

# Copy the index.html file to the S3 bucket
aws s3 cp index.html "s3://$bucket_name/"

echo "Static website with image created successfully!"

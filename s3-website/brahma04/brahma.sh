#!/bin/bash

bucket_name='brahmabar.com'
subdomain_bucket='www.brahmabar.com'
website_directory='./website/'

region='us-east-2'

# no need for profile designation at this point
#profile='default'

# 1. Create a new bucket with a unique name
aws s3 mb \
  --region $region \
  --region us-east-2 "s3://$bucket_name" 


# 1. Create a new bucket with the subdomain name
aws s3 mb \
  --region $region \
  --region us-east-2 "s3://$subdomain_bucket" 


# 2. Enable public access to the bucket
aws s3api put-public-access-block \
  --region $region \
  --bucket $bucket_name \
  --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

# 3. Update the bucket policy for public read access:
aws s3api put-bucket-policy \
  --region $region \
  --bucket $bucket_name \
  --policy "{
  \"Version\": \"2012-10-17\",
  \"Statement\": [
      {
          \"Sid\": \"brahma-dev03\",
          \"Effect\": \"Allow\",
          \"Principal\": \"*\",
          \"Action\": \"s3:GetObject\",
          \"Resource\": \"arn:aws:s3:::$bucket_name/*\"
      }
  ]
}"

# 4. Enable the s3 bucket to host an `index` and `error` html page
aws s3 website "s3://$bucket_name" \
  --region $region \
  --index-document index.html \
  --error-document index.html

# # 5. Upload you website
aws s3 sync \
  --region $region \
  $website_directory "s3://$bucket_name/"
# excercies
1.1
- use AWS CLI
- `aws sts get-caller-identity`
-  cd ~/.aws
- `cat credentials`
  + shows your aws_access_key_id and aws_secret_access_key
- `cat config`
  +  shows region and any additional parameters
- **server-side filter:**
  - `aws ec2 describe-instances --filters Name=instance-type,Values=t3.medium`
-  **client-side filter**
  + The AWS CLI provides built-in JSON-based client-side filtering capabilities with the --query parameter
  + start with a an instance-type that is not configured:
    - `aws ec2 describe-instances --filters Name=instance-type,Values=t3.micro`
    - returns:  `"Reservations": []`
    - this tells you that you can build your client-side query once the "Reservations" array contains data by giving the query a valid instance type

  + in a simple case where there is only one EC2 instance: *equivalent commands*
    - `aws ec2 describe-instances --filters Name=instance-type,Values=t3.medium --query 'Reservations[*]'`
    - `aws ec2 describe-instances --filters Name=instance-type,Values=t3.medium --query 'Reservations[0]'`
    - `aws ec2 describe-instances --filters Name=instance-type,Values=t3.medium --query 'Reservations[0].Instances'`
    - `aws ec2 describe-instances --filters Name=instance-type,Values=t3.medium --query 'Reservations[0].Instances[0].InstanceType'`
    - *in this case knowing the index # is crucial and may not always be easy to obtain*
1.2 **PRICING**
> Let's say I need to run two always-on f1.2xlarge instances (which come with instance storage and won't require any EBS volumes). To meet seasonal demand, I can expect to require as many as four more instances for a total of 100 hours through the course of a single year.  How should I pay for this deployment?

- The Simple Monthly Calculator has been retired:
  * https://aws.amazon.com/blogs/aws-cloud-financial-management/la-time-to-say-goodbye-to-the-simple-monthly-calculator/
  * AWS recommends you use the AWS Pricing Calculator to explore pricing of AWS services and estimate costs for your architecture needs.
- Amazon EC2 upfront cost (Upfront): 4,292.40 USD
- add additional servers for seasonal load: 4,448.78 USD
1.3 **create and launch an AMI based on an existing  instance storage volume**
- To edit your instance's user data you first need to stop your instance.
- edit user data to install an Apache server
- **Please note that the user data script is executed only once when the instance is launched for the first time.** If you want to apply changes to an already running instance, you'll need to execute the script manually.
- troubleshooting user-data scripts:
  + The cloud-init output log file captures console output
  + To view the log file, connect to the instance and open ``
  + `sudo yum search "find"`
  + `cat /var/log/cloud-init-output.log`
  + `sudo httpd -v`
  + `sudo chkconfig httpd status`
  + `sudo tee /var/www/html/index.html <<< '<html><center><body bgcolor="black" text="#39ff14" style="font-family: Arial"><h1>Load Balancer Demo</h1><h3>Availability Zone: '`
  + `echo '<html><center><body bgcolor="black" text="#39ff14" style="font-family: Arial"><h1>Load Balancer Demo</h1><h3>Availability Zone: ' | sudo tee /var/www/html/index.html`

1.4 **deploy ec2 instance from CLI**

1.5 **create new s3 bucket and upload file**
- s3://tc2023
- aws s3 ls s3://mybucketname

1.6 **generate and use a pre-signed URL**
- if you want to provide temporary access to an object that's otherwise private, you can generate a pre-signed URL
- you can build pre-signed URL access into your code to provide object access programmatically
- upload file:
  + `aws s3 cp learn-go-with-tests.pdf s3://tc2023`
- create Presigned URL
  + `aws s3 presign s3://tc2023/learn-go-with-tests.pdf --expires-in 600`

1.7 **static web site hoste in S3**
- https://docs.aws.amazon.com/cli/latest/reference/s3api/create-bucket.html#examples
- updates to AWS s3 bucket access:
  + https://www.puppeteers.net/blog/how-to-disable-s3-bucket-acls/
  + Amazon changed default settings for newly created buckets. 
  + The ACL on buckets was considered as wrong practice.
  + To discourage using them the option *BucketOwnerEnforced* started to be the default one.
- `aws s3api create-bucket --bucket tc2023-qslr-test --region us-east-2 --create-bucket-configuration LocationConstraint=us-east-2`
- USE SCRIPT: files/s3-static.sh
- `aws s3 cp ~/Downloads/index.html  s3://tc2023-qslr-static`
- `aws s3 cp ~/Downloads/error.html  s3://tc2023-qslr-static`
- aws s3 website s3://tc2023-qslr-static --index-document index.html --error-document error.html

1.8 **calculate the total monthly costs for your data**
- https://calculator.aws/#/?key=new


1.9 **create VPC,subnet, ENI, Internet Gateway**
- `aws ec2 create-vpc --cidr-block 10.100.0.0/16`
- `aws ec2 create-subnet --vpc-id vpc-00ca1f9d4ade79810 --cidr-block 10.100.0.0/24 --availability-zone us-east-2a`
- an ENI can exist independently from an instnace
- you can create an ENI an then attach it to an instance later
- `aws ec2 create-internet-gateway`
- `aws ec2 attach-internet-gateway --internet-gateway-id igw-0a859e2fd15a7fe4f --vpc-id vpc-00ca1f9d4ade79810`
- retrieve main route table from this VPC:
  + `aws ec2 describe-route-tables --filters Name=vpc-id,Values=vpc-00ca1f9d4ade79810`
- assign default route in the main route table of the vpc
  + `aws ec2 create-route --route-table rtb-0825c43d874005ca5 --destination-cidr-block "0.0.0.0/0" --gateway-id igw-0a859e2fd15a7fe4f`

2.0 **create a custom security group for the new vpc**
- each vpc has a default security group that you cannot delete
- `aws ec2 create-security-group --group-name "web-ssh" --description "web and ssh traffic" --vpc-id vpc-00ca1f9d4ade79810`
- add three SG rules fo SSH, HTTP and HTTPS access from any IP addr
aws ec2 authorize-security-group-ingress --group-id sg-09a66676a126c9889 --protocol "tcp" --cidr "0.0.0.0/0" --port "22"

aws ec2 authorize-security-group-ingress --group-id sg-09a66676a126c9889 --protocol "tcp" --cidr "0.0.0.0/0" --port "80"

aws ec2 authorize-security-group-ingress --group-id sg-09a66676a126c9889 --protocol "tcp" --cidr "0.0.0.0/0" --port "443"

2.1 **create and use an elastic ip address**
- `aws ec2 allocate-address`
- associate the IP to the elastic network interface you created earlier:
  + `aws ec2 associate-address --allocation-id eipalloc-0a69dafd39071983f --network-interface-id eni-0838c06674aabdcc9`
- verify the association:  `aws ec2 describe-network-interfaces --network-interface-ids eni-0838c06674aabdcc9`

2.1 **create Transit Gateway**
- `aws ec2 create-vpc --cidr-block 10.200.0.0/16`
- `aws ec2 create-subnet --vpc-id vpc-0eee55e7b865fbbb0 --cidr-block 10.200.0.0/24 --availability-zone us-east-2b`
- `aws ec2 create-transit-gateway`
- `aws ec2 describe-route-tables --filters Name=vpc-id,Values=vpc-0eee55e7b865fbbb0`
- attach the transit gateway to the VPC subnets:
  + `aws ec2 create-transit-gateway-vpc-attachment --transit-gateway-id tgw-0ef467e501f85f1f3 --vpc-id vpc-00ca1f9d4ade79810 --subnet-ids subnet-09c38cbba1004b0f1`
  + `aws ec2 create-transit-gateway-vpc-attachment --transit-gateway-id tgw-0ef467e501f85f1f3 --vpc-id vpc-0eee55e7b865fbbb0 --subnet-ids subnet-0e591d22f3ef319bc`
- search the default transit gateway route table:
  + `aws ec2 search-transit-gateway-routes --transit-gateway-route-table-id tgw-rtb-00f0c55740502203b --filters "Name=type,Values=static,propagated"`
  + the transit gateway is now configured to pass traffic between the subnets
- to use the transit gateway, add routing in each subnet's route table
  + `aws ec2 create-route --route-table-id rtb-0825c43d874005ca5 --destination-cidr-block "10.200.0.0/24" --transit-gateway-id tgw-0ef467e501f85f1f3`
  + `aws ec2 create-route --route-table-id rtb-01bf748f7f88bd852 --destination-cidr-block "10.100.0.0/24" --transit-gateway-id tgw-0ef467e501f85f1f3`
- `aws ec2 describe-route-tables --filters Name=association.subnet-id,Values=subnet-09c38cbba1004b0f1`
- verify routes:
  + aws ec2 describe-route-tables --filters Name=route.transit-gateway-id,Values=tgw-0ef467e501f85f1f3

2.2 **blackhole routes**
- aws ec2 create-transit-gateway-route --destination-cidr-block 10.200.100.64/29 --transit-gateway-route-table-id tgw-rtb-00f0c55740502203b --blackhole
2.3 **delee the infrastructure to avoid charges**
- don't leave these resources configured overnight!
  + `aws ec2 search-transit-gateway-routes --transit-gateway-route-table-id tgw-rtb-00f0c55740502203b --filters "Name=type, Values=static,propagated"`
  + `aws ec2 delete-transit-gateway-vpc-attachment --transit-gateway-attachment-id tgw-attach-0aff88c45e968a347`
  + `aws ec2 delete-transit-gateway-vpc-attachment --transit-gateway-attachment-id tgw-attach-09d2254ededa3a61c`
  + `aws ec2 delete-transit-gateway --transit-gateway-id tgw-0ef467e501f85f1f3`
  + `aws ec2 disassociate-address --public-ip 52.15.45.99`
  + `aws ec2 describe-addresses --public-ips 52.15.45.99`
  + `aws ec2 release-address --allocation-id eipalloc-0a69dafd39071983f`
  + `aws ec2 describe-internet-gateways --internet-gateway-ids igw-0a859e2fd15a7fe4f`
  + `aws ec2 detach-internet-gateway --internet-gateway-id igw-0a859e2fd15a7fe4f --vpc-id vpc-00ca1f9d4ade79810`
  + `aws ec2 delete-internet-gateway --internet-gateway-id igw-0a859e2fd15a7fe4f`
  + `aws ec2 describe-subnets --subnet-ids subnet-09c38cbba1004b0f1`
  + aws ec2 disassociate-network-acl --association-id aclassoc-074252cb916549086
  + aws ec2 describe-network-interfaces --network-interface-ids eni-0838c06674aabdcc9
  + `aws ec2 delete-network-interface --network-interface-id eni-0838c06674aabdcc9`

  +  aws ec2 delete-subnet --subnet-id subnet-09c38cbba1004b0f1

2.4 **create dynamoDB table using Provisioned Mode**

- create a table named Authors with a `partition key` named LastName and `sort key` named FirstName. Both keys should use the string data type. Provision the table wtih a WCU and RCU of 1
  + In AWS DynamoDB, "WCU" stands for Write Capacity Unit
  + "RCU" stands for Read Capacity Unit.
  + *These units are used to measure the provisioned throughput capacity of a DynamoDB table*
  + When you create a DynamoDB table, you provision the desired number of WCUs and RCUs based on your application's expected read and write workloads.
  + *The provisioned capacity ensures that your application can handle the anticipated read and write traffic with low latency*
  + The billing for DynamoDB is based on the provisioned capacity in terms of WCUs and RCUs, as well as any additional features or services you use within DynamoDB.


```
aws dynamodb create-table \
  --table-name Authors \
  --attribute-definitions \
    AttributeName=LastName,AttributeType=S \
    AttributeName=FirstName,AttributeType=S \
  --key-schema \
    AttributeName=LastName,KeyType=HASH \
    AttributeName=FirstName,KeyType=RANGE \
  --provisioned-throughput \
    ReadCapacityUnits=1,WriteCapacityUnits=1
```

2.5 **User Access and IAM policies**
- To determine which IAM policies are attached to a specific user account:
  + `aws iam list-attached-user-policies --user-name <user-name>`
- list the names of policies directly managed by the user:
  + aws iam list-user-policies --user-name <user-name>
- To view the JSON document of a specific IAM policy using the AWS CLI:
  + aws iam get-policy-version --policy-arn arn:aws:iam::aws:policy/job-function/Billing --version-id v1
- determine which IAM roles a specific user has access to and filter the results based on the user's ARN:
  + `aws iam list-roles --query "Roles[?contains(AssumeRolePolicyDocument.Statement[].Principal.AWS, 'user/<user-name>')]"`
- to determine which IAM groups a specific user is a member of:
  + `aws iam list-groups-for-user --user-name <user-name>`
- AWS recommends attaching IAM policies to groups then adding users to groups
- it is possiblet to attach IAM policies directly to users
- when creating a new bucket, the preferred security posture is:
  + `All objects in this bucket are owned by this account. Access to this bucket and its objects is specified using only policies.`
- bucket URL:  s3://tc2023-demo

2.6 **configure a user account that has its own access key and separate AWS CLI profile**
- `aws configure --profile tc2023-temp`

2.7 **Deliver CloudTrail Logs to CloudWatch Logs**
- CloudTrail must assume an IAM role that will give it permissions to stream logs to CloudWatch logs
- CloudTrail can create this log for you

2.8 ***R53 Hosted Zone**
= You pay an annual charge for each domain name registered via or transferred into Route 53.
- You pay a monthly charge for each hosted zone managed with Route 53
- You incur charges for every DNS query answered by the Amazon Route 53 service, except for queries to Alias A records that are mapped to Elastic Load Balancing instances, CloudFront distributions, AWS Elastic Beanstalk environments, API Gateways, VPC endpoints, or Amazon S3 website buckets, which are provided at no additional charge
- use AWS Pricing Calculator to calculate yearly costs of hosting a domain on AWS
- with the exception of Route 53 Resolver, all Route 53 resources are global and only need to be accounted for in one region when estimating costs across multiple AWS regions
  + 
- list all the Route 53 hosted zones configured in your AWS account:  `aws route53 list-hosted-zones`
- retrieve the hosted zone IDs,:  `aws route53 list-hosted-zones --query 'HostedZones[].Id'`
- **testing the hosted zone with a test record**
  + Test records to simulate the values that Route 53 returns in response to DNS queries. 
  + This tool displays the standard values that Route 53 provides based on the settings in the hosted zone. 
  + The tool doesn’t send actual DNS queries.
- list all R53 Health Checks: `aws route53 list-health-checks`
- **static S3 web site for routing policy exercise**
  + note: *Amazon S3 does not support HTTPS access to the website. If you want to use HTTPS, you can use Amazon CloudFront to serve a static website hosted on Amazon S3*
  + Amazon S3 now applies server-side encryption with Amazon S3 managed keys (SSE-S3) as the base level of encryption for every bucket in Amazon S3
  + Starting January 5, 2023, all new object uploads to Amazon S3 are automatically encrypted at no additional cost and with no impact on performance
- You can configure an Amazon S3 bucket to function like a website. 
- http://brahma-dev02.s3-website.us-east-2.amazonaws.com
- **By default, Amazon S3 blocks public access to your account and buckets**
- Add a bucket policy that makes your bucket content publicly available:

2.9 **Cloud Formation Template to Serve Static Content with Registered Domain**
- Configuring a static website using a custom domain registered with Route 53
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/website-hosting-custom-domain-walkthrough.html
- After you complete this walkthrough, *you can optionally use Amazon CloudFront* to improve the performance of your website
- http://brahmabar.com.s3-website.us-east-2.amazonaws.com
- After you configure your root domain bucket for website hosting, you can configure your subdomain bucket to redirect all requests to the domain
- **create the R53 alias records** that you add to the hosted zone for your domain maps example.com and www.example.com. 
  + Instead of using IP addresses, the alias records use the Amazon S3 website endpoints.
  + you create the alias records for your domain,eg brahmabar.com and www.brahmabar.com. 
  + Instead of using IP addresses, the alias records use the Amazon S3 website endpoints. 
  + Amazon Route 53 maintains a mapping between the alias records and the IP addresses where the Amazon S3 buckets reside. 

3.0 **secure static website: Cloud Formation, CloudFront and S3**
- https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/getting-started-secure-static-website-cloudformation-template.html
- https://github.com/aws-samples/amazon-cloudfront-secure-static-site
- what is a **change set** 
  + A change set is a preview of how this stack will be configured before creating the stack. 
  + This allows you to examine various configurations before executing the change set
  + *does a change set produce a document that can be shared or reviewed offline?*
  + when looking at a created Change Set, there will be a "root change set" page that lists the component changes involved with your stack
  + for each component change, you can see a JSON document containing the actual changes that will be made
  + the Change Set can be deployed from the change set page by clicking on "Execute Change Set"

3.1 **Launch Templates and SSM**
- https://docs.aws.amazon.com/systems-manager/latest/userguide/ami-preinstalled-agent.html
- AWS Systems Manager Agent (SSM Agent) is preinstalled on some Amazon Machine Images (AMIs) provided by AWS
- when SSM is not pre-installed in the AMI image, it can be installed via a **User Data** script:
```
#!/bin/bash
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl start amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent
```
- delete a launch template via CLI:
  + `aws ec2 delete-launch-template --launch-template-id lt-0b1275c55a7594fb5 --region us-east-2`


 ## links



https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-filter.html#cli-usage-filter-server-side
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/find-software.html
https://docs.aws.amazon.com/AmazonS3/latest/userguide/HostingWebsiteOnS3Setup.html
https://docs.aws.amazon.com/AmazonS3/latest/userguide/HostingWebsiteOnS3Setup.html
https://docs.aws.amazon.com/AmazonS3/latest/userguide/website-hosting-custom-domain-walkthrough.html
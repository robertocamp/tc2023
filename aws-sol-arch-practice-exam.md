## Q1
> A company's **website** receives 50,000 requests each second. The company wants to use multiple applications to analyze the navigation patterns of the website users so that the experience can be personalized.
- *Which AWS service or feature should a solutions architect use to collect page clicks for the website and process them sequentially for each user?*
    + **Kinesis Data Streams**
- Correct. Kinesis Data Streams is designed to handle streaming and clickstream data. It is built for high-volume, real-time clickstream analytics.
For more information about Amazon Kinesis use cases, see Amazon Kinesis.
For more information about Kinesis Data Streams, see What Is Amazon Kinesis Data Streams? 
- https://aws.amazon.com/kinesis/#:~:text=Build%20video%20analytics%20applications,machine%20learning%2C%20and%20other%20analytics

## Q2
> A company's website receives 50,000 requests each second. The company wants to use multiple applications to analyze the navigation patterns of the website users so that the experience can be personalized.

- Which AWS service or feature should a solutions architect use to collect page clicks for the website and process them sequentially for each user?
 >  Amazon S3 is a reliable and inexpensive service to store data, but it is not the most secure choice for storing credentials. Parameter Store is a better option for storing credentials.
 - https://docs.aws.amazon.com/AmazonS3/latest/userguide/getting-started-next-steps.html
 - **Parameter Store** provides secure, hierarchical storage for configuration data management and secrets management. You can store data such as passwords, database strings, Amazon Machine Image (AMI) IDs, and license codes as parameter values. You can store values as plaintext or encrypted data. You can reference Systems Manager parameters in your scripts, commands, Systems Manager documents, and configuration and automation workflows by using the unique name that you specified when you created the parameter.
 - https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html
 - You cannot attach EBS volumes to Lambda functions. Even if you could attach EBS volumes to Lambda functions, Parameter Store is a better option for storing credentials.
 - https://docs.aws.amazon.com/lambda/latest/dg/welcome.html
 - **You can** mount an EFS file system to a Lambda function, but a file system is not the most secure option to store credentials. Parameter Store offers features such as change notification, tag-based access, and data validation.
 - https://docs.aws.amazon.com/efs/latest/ug/how-it-works.html

## Q3
 > A company runs a website on Amazon EC2 instances behind an ELB Application Load Balancer. Amazon Route 53 is used for the DNS. The company wants to set up a backup website with a message including a phone number and email address that users can reach if the primary website is down.

- *How should the company deploy this solution?*

> Because the backup website uses static data, Amazon S3 is an ideal solution. Additionally, a Route 53 failover policy will direct users to the S3 hosted website only if the primary ELB based endpoint is unavailable.
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html
- Latency-based routing for Route 53 is not suitable for failover purposes. If you select latency-based routing, then you will direct some customers who are physically near the backup website to Amazon S3 even if the primary website is operational.
- https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html
- **The scope of an ELB is the Region within which you create the ELB.** 
- Additionally, you can register instances as targets by using the respective instance IDs of the targets only within the VPC that you specified for the target group.
- https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/how-elastic-load-balancing-works.html
- https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-register-targets.html#register-instances
- Server-side redirects will fail if the primary website that the company hosts on Amazon EC2 is unavailable.

## Q4
> A company wants to measure the effectiveness of its recent marketing campaigns. The company performs batch processing on .csv files of sales data and stores the results in an Amazon S3 bucket once every hour. The S3 bucket contains petabytes of objects. The company runs one-time queries in Amazon Athena to determine which products are most popular on a particular date for a particular region. Queries sometimes fail or take longer than expected to finish running.

- *Which actions should a solutions architect take to improve the query performance and reliability? (Select TWO.)*
  + partition the data by date and region in Amazon S3
  + Use an AWS Glue extract, transform and load (ETL) process to convert the .csv files into Apache Parquet format

> Partitions divide your table into parts and keep the related data together based on column values such as date, country, or Region. Partitions act as virtual columns. You define partitions when you create the table. Partitions can help reduce the amount of data that Athena scans each query, which improves performance. You can create filters based on the partitions to reduce the amount of data that Athena scans each query.
- https://aws.amazon.com/blogs/big-data/top-10-performance-tuning-tips-for-amazon-athena/
- https://docs.aws.amazon.com/athena/latest/ug/partitions.html

> A file size below 128 MB can be problematic when you use Athena. If your files are too small (generally less than 128 MB), the runtime engine might spend additional time to open S3 files, list directories, get object metadata, set up data transfer, read file headers, read compression dictionaries, and so on.

> If you cannot split your files, and if the files are too large, then the query processing waits until a single reader finishes reading the entire file. This situation can reduce parallelism.

> Kinesis Data Analytics is a tool that transforms and analyzes streaming data in real time. You cannot use this tool to query specific data.

## Q5
A company hosts its website on AWS. To address the highly variable demand, the company has implemented Amazon EC2 Auto Scaling. Management is concerned that the company is over-provisioning its infrastructure, especially at the front end of the three-tier application. A solutions architect needs to ensure costs are optimized without impacting performance.

- *What should the solutions architect do to accomplish this?*
    + A **target tracking** scaling policy creates and manages the Amazon CloudWatch alarms that invoke the scaling policy. A target tracking scaling policy also calculates the scaling adjustment based on the metric and the target value.

- https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-scaling-target-tracking.html

- Reserved Instances require a 1 or 3 year commitment, whereas the company wants to automatically handle variable demand.

- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-reserved-instances.html

- You must manually initiate and deactivate suspend and resume processes. If you suspend launch or terminate process types, then an Auto Scaling group will not scale out for alarms.

- https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-suspend-resume-processes.html

## Q6
> A company has implemented one of its microservices on AWS Lambda that accesses an Amazon DynamoDB table named "Books". A solutions architect is designing an IAM policy to be attached to the Lambda function's IAM role giving it access to put, update, and delete items in the "Books" table. The IAM policy must prevent the function from performing any other actions on the "Books" table and any other table.

- *Which IAM policy would fulfill these needs and provide the LEAST privileged access?*

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DescribeQueryScanBooksTable",
            "Effect": "Allow",
            "Action": [
                "dynamodb:DescribeTable",
                "dynamodb:Query",
                "dynamodb:Scan"
            ],
            "Resource": "arn:aws:dynamodb:us-west-2:account-id:table/Books"
        }
    ]
}
```
- https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/using-identity-based-policies.html#access-policy-examples-for-sdk-cli.example3
- https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_evaluation-logic.html

## Q7
> A solutions architect at an ecommerce company wants to store application log data using Amazon S3. The solutions architect is unsure how frequently the logs will be accessed or which logs will be accessed the most. The company wants to keep costs as low as possible by using the appropriate S3 storage class.

- *Which S3 storage class should be implemented to meet these requirements?*
- Correct. **S3 Intelligent-Tiering provides automatic cost savings for data with unknown or variable access patterns without retrieval fees**, performance impact, or operational overhead by automatically moving data to the most cost-effective access tier based on access frequency.
- S3 Intelligent-Tiering monitors access patterns and moves objects that have not been accessed for 30 consecutive days to the Infrequent Access tier. After 90 days without access, S3 Intelligent-Tiering moves the data to the Archive Instant Access tier. For data that does not require immediate retrieval, you can set up S3 Intelligent-Tiering to monitor and automatically move objects that have not been accessed for 180 days or more to the Deep Archive Access tier to achieve up to 95% in storage cost savings.
- https://aws.amazon.com/s3/storage-classes/
- **S3 Standard-IA charges for retrieval**. This storage class is not the most cost-effective choice for data that has unknown or variable access patterns. S3 Standard-IA is best suited for long-term storage of data that you access infrequently.
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html#sc-infreq-data-access
- **S3 One Zone-IA charges for retrieval**. This storage class is not the most cost-effective choice for data that has unknown or variable access patterns. 
- *S3 One Zone-IA is best suited for infrequently accessed data that does not require the availability and resilience of S3 Standard or S3 Standard-IA, such as secondary backup copies of on-premises data or easily re-creatable data.*
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html#sc-infreq-data-access

## Q8 
> A company wants to build an **immutable infrastructure** for its software applications. The company wants to **test the software applications before sending traffic to them**. The company seeks an efficient solution that limits the effects of application bugs.

- *Which combination of steps should a solutions architect recommend? (Select TWO.)*
    + **Apply the Amazon Route 53 weighted routing** to test the staging environment and gradually increase the traffic as the tests pass*
    + then use **AWS Cloud Formation** with a parameter set to the staging value in a separate environment other than the Production environment*
- The company could use a separate environment to test changes before the company deploys changes to production
- **Route 53 weighted routing** gives you the ability to send a percentage of traffic to multiple resources. You can use a blue/green deployment strategy to deploy software applications predictably and to quickly roll back deployments if tests fail.
- **INCORRECT** Route 53 failover routing provides disaster recovery by routing traffic to a healthy resource. If the resource becomes unhealthy, Route 53 will route traffic to another healthy resource.
- *A snapshot deletion policy does not support all resources and may not retain all required resources*
- https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-weighted.html
- https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/best-practices.html#reuse
- https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-deletionpolicy.html#aws-attribute-deletionpolicy-options

## Q9
> A solutions architect is designing a new workload in which an **AWS Lambda function** will access an **Amazon DynamoDB table**.

What is the MOST secure means of granting the Lambda function access to the DynamoDB table?
    + **create an IAM Role** with the necessary permissions to access the DynamoDB table.  
    + **Assign the role to the LAMBDA function**
- An IAM role is an IAM entity that defines a set of permissions for making AWS service requests. 
- *IAM roles are not associated with a specific user or group* 
- Instead, trusted entities such as IAM users, applications, or AWS services assume roles.
- DynamoDB has no concept of user names or passwords
- *You can grant access to the Lambda function by using an IAM role*
- The use of static keys in code makes it possible to compromise access to the environment
- This solution is not a secure way for the Lambda function to access DynamoDB

## Q10
> A solutions architect is designing a database solution that must support a high rate of random disk reads and writes. It must provide consistent performance, and requires long-term persistence.

- *Which storage solution meets these requirements?*
    + Amazon Elastic Block Store (Amazon EBS) Provisioned IOPS volume
- Provisioned IOPS volumes support a high rate of random disk reads and writes
- Provisioned IOPS volumes handle I/O intensive workloads  (*particularly database workloads*) that are sensitive to storage perfomance and consistency
- provisioned IOPS volumes use a consistent IOPS rate that delivers the provisioned performance 99.9% of the time
- General Purpose volumes do not provide the consistent performance that is required for a high rate of random disk reads and writes
- *Magnetic volumes are better suited for workloads in which data is accessed infrequently*
    + this solution requires high rates of random disk reads and writes.
- EC2 instance stores offer high performance. 
    + *However, they are temporary (ephemeral) and do not provide the long-term persistence that the scenario requires*
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html#solid-state-drives
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html#EBSVolumeTypes_standard
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html

## Q11
> A company is using AWS Site-to-Site VPN connections for secure connectivity to its AWS Cloud resources from on-premises locations. Due to an increase in traffic across the VPN connections to the Amazon EC2 instances, users are experiencing slower VPN connectivity. The network team reports that the internet connection used for the VPN has additional unused throughput.

- *Which solution will improve the VPN throughput?*
    + Use a **Transit Gateway** with equal cost multi-path routing and add additional VPN tunnels
- *The maximum throughput of a Site-to-Site VPN connection is 1.25 Gbps*
- If you need higher throughput, you could use equal cost multipath (ECMP) routing
- ECMP routing is available for VPN connections that are attached to a transit gateway
- With ECMP routing, you can aggregate multiple VPN connections to achieve a higher effective throughput
- Additional customer gateways could eliminate a single point of failure. 
    + However, this solution still would have the limitation of the 1.25 Gbps quota for Site-to-Site VPN.
- Equal cost multipath (ECMP) routing is **not supported** for Site-to-Site VPN connections on a **virtual private gateway** 
    + *ECMP routing is supported for Site-to-Site VPN connections on a transit gateway*
- You use a Site-to-Site VPN connection to connect your remote network to a VPC
- **Each Site-to-Site VPN connection has two tunnels**
- *each tunnel uses a unique virtual private gateway public IP address*
    + *You cannot configure additional tunnels over one connection*
- https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNRoutingTypes.html

> A media company has an application that **tracks user clicks** on its websites and performs **analytics** to provide **near-real-time** recommendations. The application has a fleet of Amazon **EC2 instances that receive data** from the websites and send the data to an **Amazon RDS DB instance** for long-term retention. Another **fleet of EC2 instances** hosts the portion of the application that is **continuously checking changes** in the database and running **SQL** queries to provide recommendations.

Management has requested a **redesign** to decouple the infrastructure. The solution must ensure that data analysts are writing SQL to analyze the new data only. No data can be lost during the deployment.

- *What should a solutions architect recommend to meet these requirements and to provide the FASTEST access to the user activity?*

    + use **Amazon Kinesis Data Streams** to capture the data from the websites
    + use Kinesis Data Analytics to query the data
    + use Kinesis Firehouse to persist the data on Amazon S3
- *This solution offers queries of the data before the data is sent to persistent storage*
- The use of Kinesis Data Firehose to persist the data to Amazon S3 meets the requirements
    + However, try to avoid having access the data only after Kinesis Data Firehose has written it to Amazon S3.
    + A faster solution is to read the data before it is written to the database
- Kinesis Data Firehose retains the records for a default time of 24 hours if a replay is needed
- Amazon SNS does not durably store messages.
    + If there were a problem with running the Lambda function, the data would be lost
    + A faster solution is to read the data before it is written to the database
- https://docs.aws.amazon.com/firehose/latest/dev/what-is-this-service.html

## Q13
> A company is developing a data lake solution in Amazon S3 to analyze large-scale datasets. The solution makes infrequent SQL queries only. In addition, the company wants to minimize infrastructure costs.

- *Which AWS service should be used to meet these requirements?*
    + With **Amazon Athena** you can run SQL queries direclty against the data that is stored in Amazon S3 without provisioning any infrastructure
    + **Athena is serverless**
    + there is no infrastructure to manage and you pay only for thet queries that you run
    + this is a cost-effective solution because the company needs to perform queries only periodically
- Redshift Spectrum can perform interfactive SQL queries against data in Amazon S3, but an Amazon Redshift cluster must be running
    + In addition to the charges for Redshift Spectrum, the company also would incur charges for the Amazon Redshift cluster that is used to query data with Redshift Spectrum
- You **can** import data from Amazon S3 into a table that belongs to an Amazon RDS for PostgreSQL DB instance to perform interactive SQL queries.
    + However, this process would require a DB instance to be running and does not qualify as a "cost-effective" solution
- Similarly, you **can** import data from Amazon S3 into a table that belongs to an Amazon Aurora DB instance to perform interactive SQL queries.  
    + However, this process would require an AuroraDB instance to be running. Therefore, this solution is not the most cost-effective option
- https://aws.amazon.com/redshift/pricing/
- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/PostgreSQL.Procedural.Importing.html#USER_PostgreSQL.S3Import

## Q14
> A company runs an online media site, hosted on-premises. An employee posted a product review that contained videos and pictures. The review went viral, and the company needs to handle the resulting spike in website traffic.

- *What action would provide an immediate solution?*
    + serve the images and videos using an **Amazon CloudFront** distribution using the news site as the origin
    + The review contains videos and pictures, so the company can reduce the load by offloading the content serving from the servers to a content delivery network (CDN) such as CloudFront
- Lambda functions **can** automatically scale to meet demand and handle sudden increases in traffic
- However, a website redesign takes additional time. This solution is not immediate
- The addition of EC2 instances to serve traffic could possibly handle the sudden traffic increases, but the Route 53 failover routing policy would not be the correct type of policy.
- https://docs.aws.amazon.com/lambda/index.html
- https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html
- You typically would use a cache (eg Amazon Elasticache) for database data that is small in size (kilobytes) to reduce latency times.
    + In this case, the data is videos and pictures (large sizes of megabytes or gigabytes or more)
    + This scenario is not ideal for ElastiCache for Redis.

## Q15

> A solutions architect is redesigning a monolithic application to be a loosely coupled application composed of two microservices: Microservice A and Microservice B.

Microservice A places messages in a main Amazon Simple Queue Service (Amazon SQS) queue for Microservice B to consume. When Microservice B fails to process a message after four retries, the message needs to be removed from the queue and stored for further investigation.

- *What should the solutions architect do to meet these requirements?*

    + Create an SQS dead-letter queue
    + configure the main SQS queue to deliver messages to the dead-leter queue *after the message has been received four times*
- This solution uses a *redrive policy on the main SQS queue* to send messages to a **dead-letter queue** after consumption fails a certain number of times
- Microservice A must know whether Microservice B has failed to consume a message. 
- Additionally, the message must be removed from the original SQS queue.
- **It is not possible to configure a queue to retrieve failed messages from another queue**
- https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html#sqs-dead-letter-queues-how-they-work

## Q16
> A company is planning to use a third-party service for application analytics. A solutions architect sets up a VPC peering connection between the company's VPC on AWS and the third-party analytics provider's VPC on AWS.

- *Which additional step should the solutions architect take so that network traffic can flow between the two VPCs?*
    + **configure the route tables for both VPCs**
- A route table contains a set of rules, known as routes.
- These routes determine where to direct network traffic from your subnet or gateway
- Routes give you control of whether network traffic is routed over the peering connection
- For each AWS VPC, multiple peering connections are allowed.
- the default quota for the number of peering connections to a VPC is 50, and the maximum quota is 125
- **An internet gateway is not required for VPC peering**

- https://docs.aws.amazon.com/vpc/latest/peering/vpc-peering-basics.html
- https://docs.aws.amazon.com/vpc/latest/peering/vpc-peering-routing.html

## Q17
> A company is planning to use Amazon S3 to store images uploaded by its users. The images must be encrypted at rest in Amazon S3. The company does not want to spend time managing and rotating the keys, but it does want to control who can access those keys.

- *What should a solutions architect use to accomplish this?*
    + **Server-Side Encryption with AWS KMS-Managed-Keys (SSE-KMS)**
- SSE-KMS uses AWS Key Management Service (AWS KMS) to create, manage, rotate, and control access to encryption keys
- A solution that stores the encryption keys in an S3 bucket would require *the customer* to rotate and manage access to the keys
- **SSE-S3 does not require the customer to manage the encryption keys**
    + However, SSE-S3 does not provide a way to control access to the encryption keys
- **SSE-C requires the customer to manage the encryption keys**
    + In this scenario, the customer does not want to manage the keys. 
    + Amazon S3 does not store, rotate, or manage access to the encryption keys
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerSideEncryptionCustomerKeys.html
- https://docs.aws.amazon.com/kms/latest/developerguide/overview.html

## Q18
> A company designs a **mobile app** for its customers to upload photos to a website. The app needs a secure login with **multi-factor authentication (MFA)**. The company wants to **limit the initial build time** and the maintenance of the solution.

- *Which solution should a solutions architect recommend to meet these requirements?*
    + use **Amazon Cognito Identity with SMS-based MFA**
- Amazon Cognito user pools are user directories that provide sign-up and sign-in options for web users and mobile app users
- You can add MFA to Amazon Cognito user pools for secondary validation
- The process of editing IAM policies for each user is time-consuming and ongoing work as new users start to use the mobile app
- Moreover, the company wants to limit the initial build time
- Creation and management of IAM users would be a high-maintenance solution
- When you design a public application that has a growing number of users, it is best practice to federate. 
- However, *Active Directory does not provide the sign-up feature of Amazon Cognito*
- Although API Gateway supports **in-transit** and **at-rest** SSE for secure upload of photos, this solution does not address the need for MFA --*the question is about secured login and MFA*

- https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-scenarios.html
- https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-mfa-sms-text-message.html
- https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_create.html
- https://docs.aws.amazon.com/cognito/latest/developerguide/signing-up-users-in-your-app.html
- https://docs.aws.amazon.com/apigateway/latest/developerguide/data-protection-encryption.html

## Q19
> A restaurant reservation application needs to access a waiting list. When a customer tries to reserve a table, and none are available, the customer application will put the user on the waiting list, and the application will notify the customer when a table becomes free. The waiting list must preserve the order in which customers were added to the waiting list.

- *Which service should the solutions architect recommend to store this waiting list?*
    + a **FIFO queue** in Amazon Simple Queue Service (**Amazon SQS**)
- *Amazon SQS creates messages that exist in the queue until they are removed*
- A message would be created when a table is requested
- The message would be removed when the table becomes available
- FIFO queues respect the order in which items enter the queue
- This solution would ensure that the person who has waited the longest for a table receives the next available table
- Amazon SNS is a notification service. 
    + Notifications are immediate and are suitable for some needs
    + For this scenario, a queuing service is preferable because the queue message can be maintained until a table is available
- Lambda functions time out in 15 minutes, so they would not work for this application
- The Lambda function also bills for the time that the function is active and waiting for a table to become available
- A **standard queue** would hold the message and retain it until a table becomes available. 
- However, this solution has *no mechanism to make sure that the person who has waited the longest for a table receives the next available table*
- **Standard queues do not respect the order in which items enter the queue**
- https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/welcome.html
- https://docs.amazonaws.cn/en_us/sns/latest/dg/welcome.html
- https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/standard-queues.html


## Q20
> A company stops a cluster of Amazon EC2 instances over a weekend. The costs decrease, but they do not drop to zero.

- *Which resources could still be generating costs? (Select TWO.)*
    + Elastic IP addresses 
    + Elastic Block Store Volumes (Amazon EBS)
- To ensure efficient use of Elastic IP addresses, AWS imposes a small hourly charge if an Elastic IP address is not associated with a running instance, or if an Elastic IP address is associated with a stopped instance or an unattached network interface
- For this reason, if an EC2 instance is in a stopped state but still has an associated Elastic IP address, the EC2 instance still will incur charges
- EBS volumes can be provisioned, managed, and billed separately from EC2 instances
- If you stop or terminate an EC2 instance, any EBS volumes that are in use can be retained as persistent storage beyond the lifecycle of the EC2 instance
- Amazon EBS incurs costs for the amount of storage that is provisioned to your account (measured in gigabyte-months)
- EC2 instances accrue charges only while they are running, but EBS volumes that are provisioned in the account to instances continue to accrue charges even when the volumes are not in use
- There is no additional charge for AWS Auto Scaling
- You pay only for the AWS resources that you need to run your applications, as well as Amazon CloudWatch monitoring fees
- Therefore, you will not incur charges for AWS Auto Scaling, but you might incur charges for other resources that are used in the AWS Auto Scaling process
- AWS imposes charges for each EC2 instance's data in and data out at corresponding data transfer rates. 
    + Additionally, data transfers between AWS services in different AWS Regions incur charges at standard inter-Region data transfer rates
    + However, stopped EC2 instances cannot accept or send network traffic
    - Therefore, stopped EC2 instances cannot generate data transfer out
    + This option could not be the cause of the charges.
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-lifecycle.html
- https://aws.amazon.com/ec2/pricing/

## Q21
> A company currently operates a web application backed by an Amazon RDS MySQL database. It has automated backups that run daily and are not encrypted. A security audit requires future backups to be encrypted and the unencrypted backups to be destroyed. The company will make at least one encrypted backup before destroying the old backups.

- *What should be done to set up encryption for future backups?*
    + create a snapshot of the database
    + copy the snapshot to an *encrypted snapshot*
    + *restore the database* from the encrypted snapshot
- You cannot create an encrypted snapshot of an unencrypted DB instance
- However, *you can encrypt a copy of the unencrypted snapshot* and restore the snapshot to a new DB instance
- **It is not possible** to create an encrypted backup of an unencrypted DB instance.
- **It is not possible** to create an encrypted read replica of an unencrypted DB instance.
- Although RDS uses S3 for backups, *users do not have access to the S3 bucket that stores Amazon RDS automated backups*. 
    + Therefore, users can not turn on encryption for this bucket
- https://aws.amazon.com/rds/features/backup/
- https://aws.amazon.com/rds/features/backup/

## Q22
> A company's legacy application is currently relying on a single-instance Amazon RDS MySQL database without encryption. Due to new compliance requirements, all existing and new data in this database must be encrypted.

- *How should this be accomplished?*
    + take a snapshot of the RDS instance
    + create an encrypted copy of the snapshot
    + restore the RDS instance from the encrypted snapshot
- **Amazon RDS MySQL database instances support encryption**
- Additionally, *Amazon S3 might not always be a viable replacement for Amazon RDS*
- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.Encryption.html
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html
- *It is not possible to create an encrypted standby DB instance from an unencrypted primary DB instance*
- *It is not possible to create an encrypted read replica of an unencrypted DB instance or an unencrypted read replica of an encrypted DB instance*

## Q23
> A company is using **Amazon DynamoDB** with provisioned throughput for the inventory database tier of its ecommerce website. During flash sales, customers experience periods of time when **the database cannot handle the high number of transactions** taking place. This causes the company to lose transactions. During normal periods, the database performs appropriately.

- *Which solution solves the performance problem the company faces?*
    + switch DynamoDB to **on-demand mode** during flash sales
- DAX improves *read performance for repetitive queries*. **DAX does not help one-time queries or improve write performance**
- If the company records purchases as *Kinesis messages* and then processes the messages with DynamoDB, the writes could be out of sync with the reads
- similarly, if the company records purchases as *SQS messages* and then processes the messages with DynamoDB, the writes could be out of sync with the reads
- https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.ReadWriteCapacityMode.html

## Q24
> A company needs to implement a relational database with a multi-Region disaster recovery Recovery Point Objective (RPO) of 1 second and an Recovery Time Objective (RTO) of 1 minute.

- *Which AWS solution can achieve this?*
    + implement the **Aurora Global Database**
- Amazon Aurora  provides your application with an effective RPO of 1 second and an RTO of less than 1 minute
- Amazon DynamoDB is a non-relational database
- Multi-AZ deployments do not necessarily meet the requirements for a multi-Region disaster recovery solution
- Amazon RDS for MySQL with x-Region snapshot copy does not meet the requirements of recovery Recovery Point Objective (RPO) of 1 second and an Recovery Time Objective (RTO) of 1 minute
- https://aws.amazon.com/dynamodb/global-tables/
- https://aws.amazon.com/rds/features/multi-az/

## Q25
> A solutions architect is responsible for a new **highly available three-tier architecture on AWS**. An Application Load Balancer distributes traffic to two different Availability Zones with an auto scaling group that consists of Amazon EC2 instances and a Multi-AZ Amazon RDS DB instance. The solutions architect must recommend a **multi-Region recovery plan** with a recovery time objective (RTO) of 30 minutes. Because of budget constraints, the solutions architect cannot recommend a plan that replicates the entire architecture. **The recovery plan should not use the secondary Region unless necessary**.

- *Which disaster recovery strategy will meet these requirements?*
    + **Amazon Pilot Light**
- A *backup and restore strategy* can meet the cost objectives, but this strategy would not meet the RTO requirement
- A *multi-site active/active* strategy would conflict with the budget constraints. Although a **multi-site active/active strategy would provide a low RTO**
- A warm standby strategy might be an alternative to a pilot light strategy. However, the solutions architect in this scenario must not use the secondary Region unless necessary
    + *This strategy would keep resources in the secondary Region that would not be used, which would increase costs unnecessarily*

- https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-options-in-the-cloud.html

## Q26
> A company has a three-tier web application on AWS for **document storage** and retrieval. The application stores documents on a shared NFS volume and references documents by using a Multi-AZ deployment of an Amazon RDS for MySQL DB instance. *The document metadata is consulted regularly*. The documents are *not accessed more than one time a year*, but they must remain **immediately available**. A solutions architect needs to optimize the workload and implement application modifications.

- *Which solution will meet these requirements MOST cost-effectively?*
    + use an **Amazon S3 bucket** with the *S3 Standard-Infrequent Access* ("S3 Standard-IA") storage class for document storage
    + use an **Amazon DynamoDB** table to keep document metadata
- The stored documents need to be resilient for long-term use
- Therefore, the company should use a Multi-AZ S3 bucket
- Because the company does not typically access the documents more than once a year, the company can use the S3 Standard-IA storage tier
- **DynamoDB** is a *more cost-effective managed service* to store and retrieve the document metadata than Amazon RDS
- DynamoDB would have additional benefits, such as *reduced management overhead* compared to a MySQL database
- Amazon EFS shared volumes woudl require no changes to the application
    + however, Amazon S3 buckets are more cost-effective
    + the company could modify the application to use S3 buckets for backend storage
- https://aws.amazon.com/s3/storage-classes/
- https://aws.amazon.com/dynamodb/pricing/provisioned/

## Q27
> A solutions architect finds that an Amazon Aurora cluster with On-Demand Instance pricing is being underutilized for a blog application. The application is used only for a few minutes several times each day for reads.

- *What should a solutions architect do to optimize utilization MOST cost-effectively?*
    + convert the original Aurora database to **Amazon Aurora Serverless**
- If you use Aurora Serverless, you pay for only the database resources that you consume on a per-second basis
-  Aurora Auto Scaling with On-Demand Instance pricing will **incur a charge for a minimum of 10 minutes**
    + If your application runs for less than 10 minutes, *you will still pay the minimum charge*
- Aurora parallel queries optimize and speed up a query and maintain high throughput for your workload
- This solution is not cost-effective because this solution will always run an instance, even when there is no application activity
- with Amazon global databases, Aurora will create another cluster in each additional Region
    + *The cost will increase* because each additional Region will incur a cost

- https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.html#aurora-serverless.use-cases

## Q28
> A company runs an application on three very large Amazon EC2 instances in a single Availability Zone in the us-east-1 Region. Multiple 16 TB Amazon Elastic Block Store (Amazon EBS) volumes are attached to each EC2 instance. The operations team uses an AWS Lambda script triggered by a schedule-based Amazon EventBridge (Amazon CloudWatch Events) rule to stop the instances on evenings and weekends, and start the instances on weekday mornings.

Before deploying the solution, the company used the public AWS pricing documentation to estimate the overall costs of running this data warehouse solution 5 days a week for 10 hours a day. When looking at monthly Cost Explorer charges for this new account, the overall charges are higher than the estimate.

- *What is the MOST likely cost factor that the company overlooked?*
    + AWS charges you for the storage of any **EBS volumes** that are attached to the instance.
- if an application on three very large EC2 instances in a single Availability Zone, *no data transfer charges will occur*
- *The us-east-1 Region is not one of the Regions where compute and storage costs are higher*
- Although Lambda has associated fees, the total Lambda cost to run a small number of scheduled jobs is small
- https://aws.amazon.com/ec2/pricing/on-demand/
- https://aws.amazon.com/ebs/pricing/
- https://aws.amazon.com/lambda/pricing/

## Q29
> A company wants to create an audio version of its product manual. The product manual contains custom product names and abbreviations. The product manual is divided into sections.

- *Which solution will meet these requirements with the LEAST operational overhead?*
    + use **Amazon Polly**
    + **Build custom lexicons** for the product names and abbreviations
    + use the **StartSpeechSynthesisTask API** operaton for each section of the product manual
- Although the company could build a custom SSML for the product names and abbreviations and then use the StartDocumentTextDetection API operation for each section of the product manual, this solution would require the company to *manually edit every SSML tag for custom pronunciation*
- *Amazon Textract* is a machine learning (ML) service that automatically extracts text, handwriting, and data from scanned documents; it is not used in speech-recognition applications
- https://docs.aws.amazon.com/polly/latest/dg/what-is.html
- https://docs.aws.amazon.com/polly/latest/dg/managing-lexicons.html
- https://docs.aws.amazon.com/polly/latest/dg/ssml.html

## Q30
> A company is performing an **AWS Well-Architected Framework** review of an existing workload deployed on AWS. The review identified a public-facing website running on the same Amazon EC2 instance as a **Microsoft Active Directory domain controller** that was installed recently to support other AWS services. A solutions architect needs to recommend a new design that would improve the security of the architecture and minimize the administrative demand on IT staff.

- *What should the solutions architect recommend?*
    + use the **AWS Managed Microsoft AD** to create a managed Active Directory
    + uninstall the Active Directory on current EC2 instance
- The current architecture introduces a security risk by *hosting both the Active Directory and the public-facing website on the same EC2 instance*
- 
- AWS Managed Microsoft AD is powered by an actual Microsoft Windows Server Active Directory that AWS manages in the AWS Cloud
- This configuration reduces administrative overhead and is secure
- Additionally, you can mitigate security risks by uninstalling Active Directory from the current server so the Active Directory and the website are not on the same server
- security groups permit *only allow rule* statements, not deny

## Q31
> A company has a **well-architected application** that streams audio data by using UDP in the AWS Cloud. The company hosts the application in the **eu-central-1 Region**. The company plans to offer services to North American users. A solutions architect must **improve application network performance** for the North American users.

- *Which of the following is the MOST cost-effective solution?*
    + create an **AWS Global Accelerator** standard accelerator with an endpoint group in the eu-central-1
- Global Accelerator *improves TCP and UDP network performance* for users around the world, even if a company hosts an application in *only one Region*
- Global Accelerator routes application traffic to the nearest Global Accelerator edge location
- Application traffic travels over the well-monitored, congestion-free, and redundant AWS global network to the endpoint
- Global Accelerator optimizes the network path by maximizing the time that traffic is on the AWS network
- Amazon CloudFront is a caching service that you can use to store *static and dynamic web content that uses TCP*
- Latency-based R53 routing policies improve network performance only when resources exist in multiple Regions
- with a single-Region application all traffic from other Regions would continue to go to the source Region
- https://docs.aws.amazon.com/global-accelerator/latest/dg/work-with-standard-accelerators.html
- https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-latency.html
- https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html

## Q32
> An application running in a private subnet accesses an Amazon DynamoDB table. The data cannot leave the AWS network to meet security requirements.

- *How should this requirement be met?*
    + create a **VPC endpoint** for DynamoDB and configure the endpoint policy
- With an endpoint inside the VPC and routing to that endpoint, *traffic that is destined for DynamoDB would not leave the network*
- **DynamoDB is serverless; it does not reside in a VPC**
    + therefore, there are no network ACLs to configure
- Encryption of the data connection between the application and DynamoDB does not affect how traffic is routed
- **A NAT gateway gives instances in a private subnet the ability to connect to the internet**
- https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/data-protection.html

## Q33
> A solutions architect is designing a **secure cloud-based application** that uses **Amazon EC2 instances within a VPC**. The application uses other supported AWS services within the same Region. The network traffic between the instances and AWS services must remain private and must **not travel across the public internet**.

- *Which service or resource will meet the security requirement with the MOST operational efficiency?*
    + use **VPC endpoints**
- VPC endpoints are virtual devices that make communication possible between services in your VPC and supported AWS services without the need to use the public internet
- A VPC endpoint provides a private path between your VPC and other AWS services
- Although Direct Connect provides a private network connection to AWS and your VPC, *Direct Connect is a networking service between your on-premises facilities and AWS*
- An internet gateway gives resources that are in a **VPC public subnet** (such as EC2 instances) the ability to connect to the internet
- You can use a NAT gateway to provide internet access to instances that are in a **private subnet**
- https://docs.aws.amazon.com/vpc/latest/privatelink/concepts.html
- https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
- https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
- https://aws.amazon.com/directconnect/features/?whats-new-cards.sort-by=item.additionalFields.postDateTime&whats-new-cards.sort-order=desc

## Q34
> A company wants to create an application that will transmit protected health information (PHI) to thousands of service consumers in **different AWS accounts** The application servers will sit in private VPC subnets. The routing for the application must be fault tolerant.

- *What should be done to meet these requirements?*
    + create a **VPC endpoint service** and grant permissions to specific service consumers to create a connection
- With a *VPC endpoint*, you can privately connect your VPC to supported AWS services and VPC endpoint services powered by AWS PrivateLink without requiring an internet gateway, NAT device, VPN connection, or AWS Direct Connect connection
    + Instances in your VPC do not require public IP addresses to communicate with resources in the service
    + Traffic between your VPC and the other service does not leave the Amazon network
- An **Application Load Balancer (ALB)** automatically distributes incoming traffic across multiple targets, such as Amazon EC2 instances, containers, and IP addresses, in one or more Availability Zones
- **An ALB does not route traffic to AWS services in a different account**
- a proxy server could conceivably be used as a gateway between users and the internet, but the solution is neither scalable or fault tolerant
- A **virtual private gateway** gives a VPC *access to and from the internet*
- https://docs.aws.amazon.com/vpn/latest/s2svpn/how_it_works.html#VPNGateway

## Q35
> A company built a food ordering application that **captures user data** and stores it for future analysis. The application's **static front-end** is deployed on an Amazon EC2 instance. The front-end application sends the requests to the **backend application** running on separate EC2 instance. The backend application then stores the data in **Amazon RDS**.

- *What should a solutions architect do to decouple the architecture and make it scalable?*
    + use **Amazon S3** to serve the *static front-end application*
    + the static front-end can send requests to an **Amazon API Gateway** which in turn writes the requests to an **Amazon SQS queue**
    + place the *backend instances* in an **Autoscaling group**
    + scale based on the queue length to process and store the data in Amazon RDS
- A solution that moves the static frontend application to Amazon S3 will decouple the frontend application from the backend application
- This solution will allow for scalability and improve application availability by removing the EC2 instance as a single point of failure
- A serverless managed services like API Gateway and Amazon SQS would also eliminate single points of failure and further decouple the frontend requests from processing operations
- API Gateway is an AWS service that creates, publishes, maintains, monitors, and secures REST, HTTP, and WebSocket APIs at any scale
- Amazon SQS provides a highly available and scalable message queuing service
- The addition of a backend EC2 instance to an EC2 Auto Scaling group will improve backend scalability and remove another single point of failure
- A solution that uses one EC2 instance for the backend application is an example of a tightly coupled architecture.
    +  a single-homed backend solution cannot scale without additional architectural improvements such as an EC2 Auto Scaling group and/or an Elastic Load Balancer
-  Amazon SNS decouples the architecture and is scalable. 
    + However, *messages that are published to the SNS topic are not stored and cannot be re-examined if processing fails*
    + a solution that uses one EC2 instance for the backend application is an example of a tightly coupled architecture
    + This type of solution cannot scale without additional architectural improvements such as an EC2 Auto Scaling group and/or an Elastic Load Balancer.

- https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html
- https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html
- https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/welcome.html
- https://docs.aws.amazon.com/autoscaling/ec2/userguide/get-started-with-ec2-auto-scaling.html
- https://docs.aws.amazon.com/autoscaling/ec2/userguide/autoscaling-load-balancer.html
- https://docs.aws.amazon.com/autoscaling/ec2/userguide/autoscaling-load-balancer.html

## Q36
> A company has an application running as a service in **Amazon Elastic Container Service** (Amazon ECS) using the Amazon **EC2** launch type. The application code makes **AWS API calls** to publish messages to Amazon **Simple Queue Service (Amazon SQS)**.

- *What is the MOST **secure method** of giving the application permission to publish messages to Amazon SQS?*
    + create a **new IAM role** with SQS permissions
    + then **update the task definition** to use this role for the task role setting
- The creation of a new IAM role (based on the minimal Amazon Elastic Container Service Task Role template) ensures that only the containers that are created with this task will receive access to Amazon SQS
- The addition of SQS permissions to the role used by the EC2 host means that all containers (including those of other services) that run on the host would inherit that access
    + *A security compromise could result*
- *creating a new IAM user with SQS permissions would work*, but it is not secure enough because the secrets would be in the task definition
    + *The task definition is viewable by all users who have access to Amazon ECS*
- **Security groups do not control access to managed AWS services such as Amazon SQS**
    + *security groups control incoming traffic to instances and outgoing traffic from instances*
- https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html
- https://docs.aws.amazon.com/autoscaling/ec2/userguide/us-iam-role.html
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html

## Q37
> A database architect is designing an online gaming application that uses a simple, unstructured data format. The database must have the ability to store user information and to track the progress of each user. The database must have the ability to scale to millions of users throughout the week.

- *Which database service will meet these requirements with the LEAST amount of operational support?*
    + **DynamoDB**
- DynamoDB is a fast, flexible *NoSQL database* service for **single-digit millisecond performance at any scale**
- *Neptune is a graph database service* that runs applications that work with highly connected datasets
- Aurora supports relational databases
- Amazon RDS Multi-AZ supports relational databases.

## Q38
> A company is using **Amazon DynamoDB** to stage its product catalog, which is *1 TB in size*. A product entry consists of an average of **100 KB of data**, and the average traffic is about 250 requests each second. A database administrator has provisioned **3,000 read capacity units (RCUs**) of throughput.

However, **some products** are popular among users. **Users are experiencing delays or timeouts because of throttling**. The popularity is expected to continue to increase, but the number of products will stay constant.

- *What should a solutions architect do as a long-term solution to this problem?*
    + use DynamoDB Accelerator (DAX) to maintain the frequently read items
- **DAX provides increased throughput for read-heavy workloads**
- DAX also provides potential cost savings by reducing the need to overprovision RCUs
- This feature is especially beneficial for applications that require repeated reads for popular products
- increasing the provisioned throughput to 6k RUCs would address the immediate situation, but *it would not address the long-term needs that the scenario identifies*
- The storage of the details in Amazon S3 could increase query times because the company would need to query the S3 objects and the DynamoDB table to gather the complete information about a product
- In this scenario, a change of the partition key to distribute data would not work
    + Some products are more popular than other products are, so *the product key and product type are not randomized elements*
- https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html
- https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ProvisionedThroughput.html
- https://aws.amazon.com/dynamodb/dax/
- https://repost.aws/knowledge-center/primary-key-dynamodb-table

## Q39
> An online photo application lets users **upload photos** and perform image editing operations. The application is built on Amazon **EC2 instances** and offers two classes of service: free and paid. Photos submitted by paid users are **processed before** those submitted by free users. Photos are uploaded to **Amazon S3** and the job information is sent to **Amazon SQS**

- *Which configuration should a solutions architect recommend?*
    + use **two SQS standard queues**: one for "free" customers and one for "paid" customers
    + configure the app on EC2 instances to prioritize polling for the "paid" queue over the "free" queue
- Two separate queues are necessary for both free and paid requests
    + *two separate queues are necessary to differentiate between paid and free requests*
    + *Prioritization would occur in the application that runs on the EC2 instances, not in Amazon SQS*
    + **Visibility timeout** is not related to queue prioritization.
- *Prioritization would occur in the application that runs on the EC2 instances*
- polling within SQS is not the correct solution
- https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/standard-queues.html

## Q40
A company has decided to use AWS to achieve **high availability**. The company's architecture consists of an **Application Load Balancer** in front of an **Auto Scaling group** that consists of Amazon **EC2 instances**. The company uses **Amazon CloudWatch metrics** and alarms to monitor the architecture. A solutions architect notices that the company is not able to launch some instances. The solutions architect finds the following message: *EC2 QUOTA EXCEEDED*.

- *How can the solutions architect ensure that the company is able to launch all the EC2 instances successfully?*
    + use **Service Quotas** to request an increase to the number of EC2 instances that the company can launch
- The message "EC2 QUOTA EXCEEDED" means that the company has reached the current limit for a service
- *To launch more resources, the company must use Service Quotas to request a limit increase*
- The Auto Scaling group upper limit is not the cause of the *EC2 QUOTA EXCEEDED* message
- The Auto Scaling group would continue to launch instances until it reached the maximum number of instances available
    + *The message does not mean the Auto Scaling group needs to raise its limit*
- https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-capacity-limits.html

## Q41
> A company has a **web application** that makes requests to a backend API service. The API service runs on **Amazon EC2 instances** accessed behind an **Elastic Load Balancer**.

Most backend API service endpoint calls finish very quickly, but one endpoint that makes calls to create objects in an **external service** takes a long time to complete. These long-running calls are causing client timeouts and increasing overall system latency.

- *What should be done to minimize the system throughput impact of the slow-running endpoint?*
    + use the **Amazon Simple Queue Service (Amazon SQS)** to offload the long-running requests for asynchronous processing by separate workers
- you can move the long-running calls off of the interactive request path so that separate resources can complete them asynchronously
- this solution ensures that your backend API service does not exhaust its incoming connection resources and limit the normal client requests
- increasing the load balancer idle timeout could make the problem even worse
    + clients will potentially wait even longer for responses
- A cache (such as ElastiCache for Redis) will not help here because the long-running call is a mutable operation
    + The long-running call is creating objects in the external service
- changing the size of the EC2 instance to increase memory and compute capacity will also not improve the slow-running endpoint because the processing is happening on the external service


- https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancers.html#connection-idle-timeout

## Q42
> A company is designing a website that will be hosted on Amazon S3.

- *How should users be prevented from linking directly to the assets in the S3 bucket?*
    + create an Amazon CloudFront distribution with an origin access identity (OAI)
    + update the bucket policy to grant permission to the OAI only
- To restrict access to the assets in S3 buckets, you can create an OAI and associate it with the website distribution
- You would configure the S3 bucket permissions so that CloudFront can use the OAI to access the files in the S3 bucket and serve the files to the users
- Afterward, *the users can access the static website files only through CloudFront, not directly from the S3 bucket*
- even with an Amazon R53 record set with an alias pointing to the static website, the users would still have access the objects directly in the S3 bucket
- AWS WAF will block or allow requests based on conditions that you specify, but the WAF's web ACL would not prevent the users from linking directly to the resources in the origin of the S3 bucket
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-policies.html
- https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html
- https://aws.amazon.com/route53/

## Q43
A company is creating a three-tier web application consisting of a **web server**, an **application server**, and a **database** server. The application will track GPS coordinates of packages as they are being delivered. The application will **update the database every 0.5 seconds**.

The tracking will need to be read as fast as possible for users to check the status of their packages. Only a few packages might be tracked on some days, whereas millions of packages might be tracked on other days. Tracking will need to be **searchable** by tracking ID, customer ID, and order ID. **Orders older than 1 month no longer need to be tracked**.

- *What should a solutions architect recommend to accomplish this with minimal total cost of ownership?*
    + use **Amazon DynamoDB with global secondary indexes**
    + activate Auto Scaling for the DynamoDB table and the global secondary indexes
    + turn on TTL for the DynamoDB table
- DynamoDB is the best option because of the high read and write rates
- Global secondary indexes will support scans and queries at a minimal cost
- Auto scaling would be a more efficient way to manage the capacity as demand changes
- Additionally, you can help to minimize storage costs by setting a TTL for items
- **Auto scaling** would be a more cost-effective way to manage the storage capacity as demand changes

- https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/AutoScaling.html
- https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/TTL.html

## Q44
> An application launched on **Amazon EC2** instances needs to **publish** personally identifiable information (PII) about customers using **Amazon Simple Notification Service** (Amazon SNS). The application is launched in **private subnets** within an Amazon VPC.

- *What is the MOST secure way to allow the application to access service endpoints in the same AWS Region?*
    + use **AWS PrivateLink**
- The use of PrivateLink does not require a public IP address on the instances or public access from the instance subnet
- Traffic remains within the Region of the VPC and provides no single point of failure with the VPC endpoint
- PrivateLink is the feature that powers VPC endpoints
- The use of an internet gateway would *require a public IP address* on the application instances
- The use of a NAT gateway would allow application traffic to *travel outside the VPC* and over the internet to reach the service endpoints
- The use of a proxy instance would require the provisioning of an EC2 instance and would introduce a single point of failure in the application architecture
- https://docs.aws.amazon.com/sns/latest/dg/sns-internetwork-traffic-privacy.html
- https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-proxy.html

## Q45
> An application provides a feature that allows users to securely **download private and personal files**. The **web server** is currently overwhelmed with serving files for download. A solutions architect must find a more effective solution to **reduce the web server load and cost**, and must allow users to download **only their own files**.

- *Which solution meets all requirements?*
    + store the files securely on **Amazon S3**
    + have the application generate a **presigned URL** for the user to download
- You can use presigned URLs to share access to your S3 buckets
- When you create a presigned URL, you associate it with a specific action and an expiration date
- Anyone who has access to the URL can perform the action embedded in the URL *as if they were the original signing user*
- Amazon EBS is a high-performance, block-storage service for use with Amazon EC2 for throughput and transaction-intensive workloads at any scale
- The addition of a second set of servers would shift the work to another EC2 instance and would not reduce costs
- *Encryption of the EBS volume would not allow specific users to access only their specific files*
- An **instance store** is ideal for temporary storage of information that changes frequently, such as buffers, caches, scratch data, and other temporary content --*it is not applicable for this use-case*
    + An instance store also is ideal for data that is replicated across a fleet of instances, such as a load-balanced pool of web servers
- **CloudFront** is a content delivery network service that securely delivers data, videos, applications, and APIs globally with low latency and high transfer speeds
- The use of a CloudFront cache alone would not allow users to download only their own files
- You can use *CloudFront signed URLs* to allow users to download only their own files, but signed URLs are not mentioned in this response.
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-presigned-url.html
- https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-overview.html

## Q46
> An application runs on Amazon EC2 instances in multiple Availability Zones behind an Application Load Balancer. The load balancer is in public subnets. The EC2 instances are in private subnets and must not be accessible from the internet. The EC2 instances must call external services on the internet. Each Availability Zone must be able to call the external services, regardless of the status of the other Availability Zones.

- *How should these requirements be met?*
    + create a **NAT gateway** in each Availability Zone
    + update the **route tables for each private subnet** to direct internet-bound traffic to the local NAT gateway
- A NAT gateway is assigned to a **public subnet** and is associated with a single Availability Zone
- This solution ensures that each Availability Zone is independent of the others for internet routing
- Unlike *internet gateways*, which apply to the entire VPC, **NAT gateways must reside within a subnet** and within a single Availability Zone
- in this use-case, the use of a single NAT gateway would result in a single point of failure
- using an Internet gateway with routing from the private subnets would simply turn the private subnets into public subnets and would make the EC2 instances accessible from the internet
- if you want to use *NAT instances* to securely route traffic from private subnets to the internet, you must create NAT instances in *public subnets*
- https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html

## Q47
A solutions architect is designing a solution that involves orchestrating a series of **Amazon Elastic Container Service (Amazon ECS) tasks**. The tasks run on an ECS cluster that uses **Amazon EC2 instances across multiple Availability Zones**. The **output and state data** for all tasks must be stored. The amount of data that each task outputs is approximately 10 MB, and hundreds of tasks can run at a time. **As old outputs are archived and deleted, the storage size will not exceed 1 TB**.

- *Which storage solution should the solutions architect recommend to meet these requirements with the HIGHEST throughput?*
    + ***Elastic File System (EFS) with Provisioned Throughput mode***
- There are two throughput modes to choose from for your EFS file system: 
    * Bursting Throughput mode and 
    * Provisioned Throughput mode
- With Bursting Throughput mode, throughput on Amazon EFS scales as the size of your file system grows
- With Provisioned Throughput mode, you can instantly provision the throughput of your file system (in MiB/s), independent of the amount of data stored
- *With Bursting Throughput mode, the only way to change performance would be to change the size of the file system*
    + This solution provides the highest throughput without changing the size of the file system
- You can attach EBS volumes to ECS cluster instances
- However, you can attach an EBS volume to multiple instances *only if those instances are in the same Availability Zone*
- **DynamoDB has a maximum item size of 400 KB**. The 10 MB output logs would not fit in a single item.
- https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ServiceQuotas.html

## 48
> A solutions architect is **designing a VPC** that requires access to a **remote API** server using IPv6. Resources within the VPC should not be accessed directly from the internet.

- *How should this be achieved?*
    + attach an **engress-only Internet gateway** and update the routing tables

- **NAT gateways do not support IPv6 traffic**
- IPv6 addresses are globally unique
    + Therefore, *they are public by default*. *Egress-only internet gateways prevent the internet from initiating an IPv6 connection with instances*
- https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html

## 49
An administrator wants to apply a resource-based policy to the S3 bucket named "iam-policy-testbucket" to restrict access and to allow accounts to only write objects to the bucket. When the administrator tries to apply the following policy to the "iam-policy-testbucket" bucket, the S3 bucket presents an error.

{
    "Version": "2012-10-17",
    "Id": "Policy1646946718956",
    "Statement": [
        {
            "Sid": "Stmt1646946717210",
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::iam-policy-testbucket/*"
        }
    ]
}

- *How can the administrator correct the policy to resolve the error and successfully apply the policy?*
    + add a `Principal` element to the policy to declare which accounts have access
- **Resource-based policies must include a Principal element in the policy**
- **every IAM policy**, identity-based and resource-based, **requires a resource statement**

## 50
> A company's cloud operations team wants to **standardize resource remediation**. The company wants to provide a standard set of governance evaluations and remediations to all member accounts in its organization in AWS Organizations.

- *Which self-managed AWS service can the company use to meet these requirements with the LEAST amount of operational effort?*
    + implement **AWS Config conformance packs**
- AWS Config conformance packs are collections of AWS Config rules and remediation actions that you can deploy as a single entity in an account and a Region or across an organization in AWS Organizations
- Security Hub is a managed service that provides you with a comprehensive view of your security state in AWS and helps you check your environment against security industry standards and best practices
- CloudTrail records API calls but does not make recommendations or provide remediation
- CloudTrail helps you facilitate governance, compliance, and operational and risk auditing of your AWS account
- Trusted Advisor is an online tool that provides you with real-time guidance to help you provision your resources according to AWS best practices
    + *Trusted Advisor does not provide remediation*
- https://docs.aws.amazon.com/config/latest/developerguide/conformance-packs.html
- https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html

## 51
> A company wants to deploy an additional Amazon Aurora MySQL DB cluster for development purposes. This cluster will be used several times a week for a few minutes upon request to debug production query issues. The company wants to keep overhead low for this resource.

- *Which solution meets the company's requirements MOST cost-effectively?*
    + run the DB instnce on **Aurora Serverless**
- Aurora Serverless is an on-demand, automatically scaling configuration for Aurora
- Aurora Serverless **automatically starts up, shuts down, and scales capacity based on an application's needs**
- It gives you the ability to run your database in the cloud without managing any database capacity
- **Serverless** is the right solution for **unpredictable workloads** or workloads that have **infrequent use**
- **Reserved Instances will reduce cost compared with On-Demand Instances**
- **The DB cluster will be accessed randomly during the day and will not be used all the time 
    + *The pattern is not consistent, so it is not possible to create a schedule for the start and stop actions*
- The company could use a **Lambda function** to stop the DB instances, but this solution includes no mechanism to restart the DB instances
- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_StopInstance.html
- https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.html#aurora-serverless.use-cases
- https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_WorkingWithReservedDBInstances.html

## 52
> A team has an application that detects when **new objects are uploaded into an Amazon S3 bucket**. The uploads invoke an **AWS Lambda** function to write object metadata into an **Amazon DynamoDB** table and an **Amazon RDS for PostgreSQL database**.

- *Which action should the team take to ensure high availability?*
    + enable **multi-AZ for RDS** on the PostgresDB
- **By default, Amazon RDS is deployed to a single Availability Zone**
- **Multi-AZ is the standard option to provide high availability**
    + *In a Multi-AZ setup, RDS DB instances are synchronously replicated in other Availability Zones to provide high availability and failover support*
- A Lambda function **is not** a stateful system that needs specific instructions so that it can be highly available
- **AWS transparently replicates S3 buckets**
- **S3 Standard storage provides 99.999999999% durability and 99.99% availability of objects over a given year**
- DynamoDB automatically spreads the data and traffic for your tables over a sufficient number of servers to handle your throughput and storage requirements while maintaining consistent and fast performance
- in DynamoDB **all of your data is stored on SSDs** and is automatically replicated across multiple AZ in an AW region
    + Dynamodb has built-in high availability and data durability; *it is highly available by default*
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/DataDurability.html
- https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html

## Q53
> During a review of business applications, a solutions architect identifies a critical application with a **relational database** that was built by a business user and is running on the user's desktop. To reduce the risk of a business interruption, the solutions architect wants to **migrate the application** to a **highly available**, **multi-tiered solution** in AWS.

- *What should the solutions architect do to accomplish this with the LEAST amount of disruption to the business?*
    + use **AWS Database Migration Service**
    + migrate the backend database to an Amazon RDS Multi-AZ DB instance
    + migrate the application code to AWS Elastic Beanstalk
- You can use AWS DMS to perform a database migration in the background
- Cutover time is minimal because AWS DMS keeps the database in sync
- **Elastic Beanstalk** and **Amazon RDS** are managed services and can be configured for high availability with a Multi-AZ deployment
- With **Elastic Beanstalk**, you can quickly deploy and manage applications in the AWS Cloud without having to learn about the infrastructure that runs those applications
- Elastic Beanstalk reduces management complexity without restricting choice or control
- You upload your application, and Elastic Beanstalk automatically handles the details of capacity provisioning, load balancing, scaling, and application health monitoring
- **Lambda** is a compute service that gives you the ability to run code without provisioning or managing servers
- Lambda runs your code only when you need it and scales automatically, from a few requests each day to thousands of requests each second
    + However, Lambda functions have a timeout of 15 minutes, so they would not be an ideal platform for database migrations
- creating an image of the user's workstation and imgrating to AWS using VM import would require downtime and would affect users
    + In addition, the application would still need to be decoupled at the database and application layer
- pre-staging EC2 and RDS instances runs the risk that the data might change on the live production instance after the new copy is pre-staged.
- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MySQL.Procedural.Importing.Other.html
- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html
- https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Introduction.html

## 54
> An application team has started using **Amazon EMR** (Elastic Map Reduce) to run **batch jobs**, using **datasets located in Amazon S3**. During the initial testing of the workload, a solutions architect notices that the account is starting to accrue **NAT gateway data processing costs**.

- *How can the team optimize the cost of the workload?*
    + replace the **NAT gateway** with an **S3 VPC endpoint**
- An S3 VPC endpoint is a gateway endpoint that does not incur a charge for traffic to Amazon S3
- If the clusters run in a **private subnet without a NAT gateway** or an alternative method to reach the S3 bucket, the workload will not be able to reach the objects in Amazon S3 and will fail
- A customer gateway is a physical or software appliance that you own or manage in your on-premises network (on your side of an AWS Site-to-Site VPN connection)
    + *A customer gateway is not related to communication between a VPC and an AWS service such as Amazon S3*
- **a network ACL does not block outbound traffic**
    + *A network ACL will not help with the NAT gateway costs*
- https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html#gateway-endpoint-pricing
- https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html

# Q55
> A user is designing a new service that receives location updates from 3,600 rental cars every hour. The cars upload their location to an Amazon S3 bucket. Each location must be checked for distance from the original rental location.

- *Which services will process the updates and automatically scale?*
    + utilise Amazon S3 events and AWS Lambda
- When an object is placed in an S3 bucket, that action needs to **invoke an action** that calculates the distance from the car to the original rental location
- **S3 Event Notifications calls the Lambda function**, and Lambda runs the code to do the calculation
- Kinesis Data Firehose could upload the data to an S3 bucket
    + however in this scneario the data has already been uploaded
    + this scenario requires a service that will perform an action (in this case, a calculation of the distance from the rental car to the original rental location)
    + Kinesis Data Firehouse is not well suited to this
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/EventNotifications.html
- https://aws.amazon.com/blogs/storage/reliable-event-processing-with-amazon-s3-event-notifications/

# Q56
> A company has a **three-tier architecture solution** in which an application writes to a **relational database**. Because of **frequent requests**, the company wants to cache data whenever the application writes data to the database. The company's priority is to **minimize latency** for data retrieval and to ensure that **data in the cache is never stale**.

- *Which caching strategy should the company use to meet these requirements?*
    + deploy Amazon ElastiCache with write-through
- The write-through strategy adds data or updates data that is in the cache whenever the application writes data to the database
- **Data in the cache is never stale** because the data in the cache is updated every time the application writes the data to the database
- **Lazy loading** is a caching strategy that loads data into the cache only when necessary
- If the application writes data to the cache only when there is a cache miss, then data in the cache can become stale
- This result occurs because there are no updates to the cache when data changes in the database
- DAX is an in-memory caching strategy for DynamoDB --it is not applicable to Relational DBs
- **Amazon SQS is not a caching strategy**
    + It is a message queuing service that you can use to decouple and scale microservices, distributed systems, and serverless applications
- https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/welcome.html

# Q57
> A company hosts a popular **web application**. The web application connects to a **database** running in a **private VPC subnet**. The web servers must be accessible only to customers on an SSL connection. The Amazon RDS for MySQL database server must be accessible only from the web servers.

- *How should a solutions architect design a solution to meet the requirements without impacting running applications?*
    + open an HTTPS port on the Security Group for the web servers
    + set the source to 0.0.0.0/0 in the HTTPS rule
    + open the MySQL port on the database security group and attach it to the MySQL instance
    + set the source to the web server security group
- If you leave the database in a private subnet and leave the web server in a public subnet, you restrict internet access to only the application server.
- One security group for each tier enforces least-privilege access
- **Security groups are stateful** --if a path is opened, then the return path is also open
- **Network ACLs are stateless** --responses to allowed inbound traffic are subject to the rules for outbound traffic.
- placing both the web servers and the MySQL server in the same subnet would potentially expose the DB to Internet traffic, a network ACL attached to that subnet were to be misconfigured
- It is not helpful to open a MySQL port for the web servers because the web servers must receive HTTPS traffic
- it is not helpful to open the HTTPS ports for the database servers because the database servers must process traffic on the MySQL port.
- https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html
- https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html
- https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Security.html

# Q58
> An environment has an Auto Scaling group across two Availability Zones referred to as AZ-a and AZ-b. AZ-a has four Amazon EC2 instances, and AZ-b has three EC2 instances. The Auto Scaling group uses a default termination policy. None of the instances are protected from a scale-in event.

- *How will Auto Scaling proceed if there is a scale-in event?*
    + **Auto Scaling selects the Availability Zone with four EC2 instances (ie the most)**, and then continues to evaluate
- **The default termination policy helps ensure that instances are distributed evenly across Availability Zones for high availability**
    + *This action is the starting point of the default termination policy if the Availability Zones have an unequal number of instances and the instances are unprotected*
- According to the default termination policy, Amazon EC2 Auto Scaling first determines **which Availability Zones have the most instances** and then identifies at least one instance that is not protected from scale in.
- According to the default termination policy:
    + Amazon EC2 Auto Scaling first determines which Availability Zones have the most instances
    + and then identifies at least one instance that is not protected from scale in
    + If the Availability Zones have an equal number of instances, Amazon EC2 Auto Scaling checks for the oldest launch configuration
    + After applying all the preceding criteria, if there are multiple unprotected instances to terminate, Amazon EC2 Auto Scaling determines which instances are ***closest to the next billing hour**
    + If there are multiple unprotected instances closest to the next billing hour, Amazon EC2 Auto Scaling terminates one of those instances at random.

# Q59
> **Cost Explorer** is showing charges higher than expected for **Amazon Elastic Block Store** (Amazon EBS) volumes connected to application servers in a production account. A significant portion of the changes from Amazon EBS are from volumes that were created as **Provisioned IOPS SSD (io2)** volume types. **Controlling costs** is the highest priority for this application.

- *Which steps should the user take to analyze and reduce the EBS costs without incurring any application downtime? (Select TWO.)*
    + use **Amazon CloudWatch GetMetricData** action to evaluate the read/write operations and read/write bytes of each volume
    + use the **EC2 ModifyVolume** action to change the volume type of the underutilised io2 volumes go **General Purpose SSD (gp3)**
- The CloudWatch GetMetricData action can show the IOPS and throughput of an io2 volume to help you determine if the io2 volume is a good candidate for modification to a lower-cost volume type
- You can make a change with the EC2 ModifyVolume action without incurring any volume downtime
    1. **use CloudWatch to get metrics on the underutilized io2 volumes**
    2. **Then use ModifyVolume to change from io2 to gp3 to reduce costs**
- **EBS optimization** can increase EBS performance of the instance, but *it will not contribute to cost analysis or cost reduction*
- You cannot use the **EC2 ModifyVolume** action to reduce *the size* of a volume. 
- **ModifyVolume can only expand the size of a volume**
- EBS volume snapshots are managed by AWS and **cannot be migrated to S3 Glacier** (with either instant or flexible retrieval tier)
- Amazon Data Lifecycle Manager (Amazon DLM), not Amazon S3, handles the current EBS snapshot lifecycle
- https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/requesting-ebs-volume-modifications.html

# Q60
> A company is building a **document storage application** on AWS. The application runs on **Amazon EC2** instances in **multiple Availability Zones**. The company requires the document store to be **highly available**. The documents need to be **available to all EC2 instances hosting the application** and returned immediately when requested **multiple times per month**. The lead engineer has configured the application to use Amazon Elastic Block Store (Amazon EBS) to store the documents, but is willing to consider other options to meet the availability requirement.

- *What should a solutions architect recommend?*
    + use **EBS for the EC2 root instance volumes**
    + configure the application to build the **document store on Amazon S3 standard**
- Because Amazon S3 is a Regional service, the document store will be highly available and accessible to EC2 instances across Availability Zones
- The application will return documents immediately upon request
- You can use EBS snapshots to create new volumes in other Availability Zones
    + However, this solution effectively creates different document stores across different Availability Zones
    + using EBS snapshots in other Availability Zones would require overhead to keep the documents synchronized across Availability Zones
- A solution that stores the documents in **S3 Glacier Flexible Retrieval** would make the documents highly available
    + However, S3 Glacier Flexible Retrieval could take minutes to retrieve the objects
    + **S3 Glacier Flexible Retrieval is more suitable for objects that you access only one to two times each year**
- Although **provisioned IOPS volumes** provide consistent I/O performance, *there is no requirement to achieve a given I/O rate*
- Additionally, although **EBS volumes** that are mounted in a RAID 5 configuration would provide fault tolerance for instances individually, this configuration would not address the availability requirement
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonS3.html
- https://aws.amazon.com/s3/storage-classes/?nc=sn&loc=3
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-volume-types.html#EBSVolumeTypes_piops

# Q61
> A **web application** runs on **Amazon EC2** instances behind an **Application Load Balancer (ALB)**. The application allows users to create **custom reports** of historical weather data. Generating a report can take **up to 5 minutes**. These **long-running requests** use many of the available incoming connections, making the system unresponsive to other users.

- *How can a solutions architect make the system more responsive?*
    + use **Amazon SQS with Lambda** to generate the reports
- **increasing the idle timeout between the ALB and the EC2 instances** would not address timeouts between the client and the ALB
    + Additionally, *this solution would exacerbate the problem of long-running requests that starve other connections*
- If the company uses **Amazon SQS and Lambda** to offload the report generation, the system will no longer use resources on the web application servers to process the reports
    + *Therefore the system will no longer consume all the connections*
- Another example of an application running on the AWS cloud that utilizes Amazon Simple Queue **Service (SQS) with AWS Lambda** is a serverless image processing system
- increasing the client-side application code to increase its request timeout to 5 minutes would affect only the connection between the client and the ALB
    + *This solution would not affect the timeout between the ALB and the EC2 instances*
- Amazon CloudFront was not an attractive solution here because the reports are very customized and there would not have been enough cache hits to make CloudFront an effection solution

# Q62
> Management has decided to deploy all **AWS VPCs with IPv6 enabled**. After some time, a solutions architect tries to launch a new Amazon EC2 instance and receives an error stating that there are **not enough IP address spaces available** in the subnet to launch the instance.

- *What should the solutions architect do to fix this?*
    + **create a new IPv4 subnet with a larger range and then launch the instance**
- **There is no option for an IPv6-only VPC**
    + *VPCs can be either IPv4-only or dual-stack*
- Every instance that is launched in a dual-stack VPC has IPv4 addresses and IPv6 addresses
- When the IPv4 addresses are used up, instances will return the error that there are not enough IP addresses in the subnet
- https://docs.aws.amazon.com/vpc/latest/userguide/vpc-ip-addressing.html
- **Every instance that is launched in a dual-stack VPC has IPv4 addresses and IPv6 addresses**
- The IPv6 CIDR block is fixed in size (/64) and includes 18,446,744,073,709,551,616 addresses
- Any range of IPv4 addresses would be used up before the IPv6 address range would be used up

# Q63
> A solutions architect is designing a hybrid application using the AWS Cloud. The **network between the on-premises data center and AWS** will use an **AWS Direct Connect** (DX) connection. The application connectivity between AWS and the on-premises data center must be **highly resilient**.

- *Which DX configuration should be implemented to meet these requirements?*
    + **configure DX connections at multiple DX locations**
- *You can achieve maximum resiliency for critical workloads by using separate connections that terminate on separate devices in more than one location*
- You **CAN** establish a VPN tunnel over a Direct Connect connection
    + however the DX would still be a *single point of failure*
- even **multiple virtual interfaces** would still use the single Direct Connect connection
    - *The best solution is to remove this single point of failure by having multiple connections in multiple Direct Connect locations*

# Q64
> A development team is deploying a new product on AWS and is using **AWS Lambda** as part of the deployment. The team allocates **512 MB of memory** for one of the Lambda functions. With this memory allocation, the function is completed in 2 minutes. The **function runs millions of times monthly**, and the development team is concerned about **cost**. The team conducts tests to see **how different Lambda memory allocations affect the cost of the function**.

- *Which steps will reduce the Lambda costs for the product? (Select TWO.)*
    + **increase the memory allocation** for this Lambda function to 1024MB if this change causes the run time of each function to be less than 1 minute
    + **reduce the memory allocation for this Lambda function to 256MB** if this change causes the run time of each function to be less than 4 minutes
- if the team *increases the memory* allocation of the Lambda by 100%,  and the new run time is more than 100% faster (less than 1 minute), *a reduction in the overall costs will occur.*
- the team *reduces the memory* by 50% and the new run time is less than 200% slower (less than 4 minutes), *a reduction in the overall costs will occur*.
- Duration is calculated from the time your code begins running until it returns or otherwise terminates, rounded up to the nearest 100 milliseconds
- **The price depends on the amount of memory that you allocate to your function**
- In the Lambda resource model, you choose the amount of memory that you want for your function, and you receive proportional CPU power and other resources
- An increase in memory size *initiates an equivalent increase in CPU* that is available to your function
- for example if the team increases the memory allocation by 300%, for the change to increase cost-effectiveness, the run time would need to be *more than 300% faster* (less than 30 seconds instead of less than 1 minute).
- https://aws.amazon.com/lambda/pricing/

# Q65
> A solutions architect needs to allow developers to have SSH connectivity to web servers. The requirements are as follows:

Limit access to users originating from the corporate network.
Web servers cannot have SSH access directly from the internet.
Web servers reside in a private subnet.

- *Which combination of steps must the architect complete to meet these requirements? (Select TWO.)*
    + create a **Bastion host** with **Security Group rules** that only allow traffic from the corporate network
    + configure the **web servers' security group to allow SSH traffic from the bastion host**
- A bastion host meets the requirement to prevent direct SSH access from the internet
- A bastion host meets the requirement to prevent direct SSH access from the internet
- However, *simple authentication of users against the corporate directory would not prevent those users from logging in to the bastion host from a location outside the corporate network.*
- The addition of a security group rule that only allows SSH access from the corporate network meets the requirement to limit access accordingly
- **The IAM permissions that are assigned to a bastion host would not prevent users from logging in to the host from locations outside the corporate network**
- The configuration of the web servers' security group to only allow SSH access from the bastion host will prevent access from other systems
https://aws.amazon.com/solutions/implementations/linux-bastion/
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html
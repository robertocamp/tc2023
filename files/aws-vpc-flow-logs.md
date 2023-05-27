Create a CloudWatch Log Group and VPC Flow Logs to CloudWatch
Create a VPC Flow Log to S3
Navigate to VPC.

In the VPC dashboard, select the VPCs card.

You should see an A Cloud Guru VPC pre-provisioned for the lab.

Check the checkbox next to the A Cloud Guru VPC.

Toward the bottom of the screen, select the Flow logs tab.

On the right, click Create flow log.

Fill in the flow log details:

Name: You can leave this field blank.
Filter: Ensure that All is selected.
Maximum aggregation interval: Select 1 minute.
Destination: Select Send to an Amazon S3 bucket.
Get the S3 bucket ARN:

In a new browser tab, navigate to S3.
Select the radio button next to the provided bucket.
Click Copy ARN.
Navigate back to the VPC Management Console tab and fill in the rest of the flow log details:

S3 bucket ARN: In the text field, paste your copied S3 bucket ARN.
Log record format: Ensure that AWS default format is selected.
Leave the other fields as the default settings and click Create flow log.

Your flow log is created.

From the Your VPCs page, select the Flow logs tab.

Review the flow log details and verify that it shows an Active status.

Navigate back to the S3 Management Console tab.

Select your bucket name, and then select the Permissions tab.

Review the bucket policy and note that it is modified automatically by AWS when you create flow logs so that the flow logs can write to the bucket.

Note: It can take between 5–15 minutes for flow logs to appear. You can continue working through the other lab objectives while you wait for the flow logs to populate.

Create the CloudWatch Log Group and VPC Flow Log
In a new browser tab, navigate to CloudWatch.

In the CloudWatch sidebar menu, navigate to Logs and select Log groups.

Click Create log group.

In the Log group name field, enter VPCFlowLogs.

Click Create.

Navigate back to the VPC Management Console tab and ensure the Flow logs tab is still selected.

On the right, click Create flow log.

Fill in the flow log details:

Name: You can leave this field blank.
Filter: Ensure that All is selected.
Maximum aggregation interval: Select 1 minute.
Destination: Ensure that Send to CloudWatch Logs is selected.
Destination log group: Click into the field and select your VPCFlowLogs log group.
IAM role: Use the dropdown to select the DeliverVPCFlowLogsRole role.
Log record format: Ensure that AWS default format is selected.
Click Create flow log.

Your flow log is created.

From the Your VPCs page, ensure the Flow logs tab is selected.

Review the flow log details and verify that the new flow log shows an Active state.

Navigate back to the CloudWatch Management Console tab.

Select the VPCFlowLogs log group name.

You should see there are currently no log streams. Remember, it may take some time before the flow logs start populating data.

Generate Network Traffic
In a new browser tab, navigate to EC2.

In the Resources section of the EC2 dashboard, select Instances (running).

You should see a Web Server instance that was pre-provisioned for the lab.

Check the checkbox next to the Web Server instance.

In the instance's Details tab, copy the Public IPv4 address.

Open a terminal session and log in to the EC2 instance using the credentials provided for the lab:

ssh cloud_user@<PUBLIC-IP-ADDRESS>
Now that you have connected to the terminal successfully, the VPC flow logs will record for this connection.

Exit the terminal:

logout
Navigate back to the EC2 Management Console tab.

Update the EC2 instance security group:

Check the checkbox next to the Web Server instance, and then use the Actions dropdown to select Security > Change security groups.
In the Associated security groups section, click Remove to the right of the security group details to remove the SecurityGroupHTTPAndSSH group.
Use the search bar in the Associated security groups section to select the SecurityGroupHTTPOnly security group.
Click Add security group, and then click Save.
Navigate back to your terminal session and reconnect to the EC2 instance using the credentials provided for the lab:

cloud_user@<PUBLIC-IP-ADDRESS>
This time, your connection should time out because you removed SSH access with the security group change. This will be recorded in VPC Flow Logs as a reject record.

Press Ctrl+C to cancel the SSH command.

Navigate back to the EC2 Management Console tab.

Revert the EC2 instance security group back to SecurityGroupHTTPAndSSH:

Ensure the Web Server instance is selected, and then use the Actions dropdown to select Security > Change security groups.
In the Associated security groups section, click Remove to the right of the security group details to remove the SecurityGroupHTTPOnly group.
Use the search bar in the Associated security groups section to select the SecurityGroupHTTPAndSSH security group.
Click Add security group, and then click Save.
Navigate back to your terminal session and reconnect to the EC2 instance using the credentials provided for the lab:

ssh cloud_user@<PUBLIC-IP-ADDRESS>
This time, the connection should be accepted.

Create CloudWatch Filters and Alerts
Create a CloudWatch Log Metric Filter
Navigate back to the CloudWatch Management Console tab.

In the CloudWatch sidebar menu, navigate to Logs and select Log groups.

Select the VPCFlowLogs log group name.

You should now see a log stream. If you don't see a log stream listed yet, wait a few more minutes and refresh the page until the data appears.

Select the listed log stream name and review the data.

Use the breadcrumb along the top of the page to select VPCFlowLogs.

Select the Metric filters tab and then click Create metric filter.

In the Filter pattern field, enter the following pattern to track failed SSH attempts on port 22:

[version, account, eni, source, destination, srcport, destport="22", protocol="6", packets, bytes, windowstart, windowend, action="REJECT", flowlogstatus]
Use the Select log data to test dropdown to select Custom log data.

In the Log event messages field, replace the existing log data with the following:

2 086112738802 eni-0d5d75b41f9befe9e 61.177.172.128 172.31.83.158 39611 22 6 1 40 1563108188 1563108227 REJECT OK
2 086112738802 eni-0d5d75b41f9befe9e 182.68.238.8 172.31.83.158 42227 22 6 1 44 1563109030 1563109067 REJECT OK
2 086112738802 eni-0d5d75b41f9befe9e 42.171.23.181 172.31.83.158 52417 22 6 24 4065 1563191069 1563191121 ACCEPT OK
2 086112738802 eni-0d5d75b41f9befe9e 61.177.172.128 172.31.83.158 39611 80 6 1 40 1563108188 1563108227 REJECT OK
Click Test pattern and then review the results.

Click Next.

Fill in the metric details:

Filter name: In the text field, enter dest-port-22-rejects.
Metric namespace: In the text field, enter a name (e.g., vpcflowlogs).
Metric name: In the text field, enter SSH Rejects.
Metric value: In the text field, enter 1.
Leave the other fields blank and click Next.

Review the metric details and then click Create metric filter.

Create an Alarm Based on the Metric Filter
After the metric filter is created, ensure that the Metric filters tab is selected.

In the Metric filter details, check the checkbox to the right of the dest-port-22-reject filter.

On the right, click Create alarm.

The Alarms page opens in a new browser tab automatically.

Specify the metric conditions:

Period: Use the dropdown to select 1 minute.
Threshold type: Ensure that Static is selected.
Whenever SSH Rejects is...: Select Greater/Equal.
than...: In the text field, enter 1.
The metric will trigger an alarm whenever there is one or more reject messages within a one-minute period.

Click Next.

Configure the alarm actions:

Alarm state trigger: Ensure that In alarm is selected.
Send a notification to the following SNS topic: Select Create a new topic.
Create a new topic...: Leave the default topic name.
Email endpoints that will receive the notification...: In the text field, enter an email address (this can be your real email address or a sample address like user@example.com), and then click Create topic.
Note: If you entered your real email address, open your email inbox and click the Confirm Subscription link you received in the SNS email.

Click Next.

In the Alarm name field, enter SSH rejects.

Click Next.

Review the alarm details and then click Create alarm.

The alarm is created but will take some time to start populating data.

Generate Traffic for Alerts
Navigate back to the terminal session and reconnect to the EC2 instance using the credentials provided for the lab:

ssh cloud_user@<PUBLIC-IP-ADDRESS>
Exit the terminal:

logout
Navigate back to the EC2 Management Console tab.

Update the EC2 instance security group:

Check the checkbox next to the Web Server instance, and then use the Actions dropdown to select Security > Change security groups.
In the Associated security groups section, click Remove to the right of the security group details to remove the SecurityGroupHTTPAndSSH group.
Use the search bar in the Associated security groups section to select the SecurityGroupHTTPOnly security group.
Click Add security group, and then click Save.
Navigate back to your terminal session and reconnect to the EC2 instance using the credentials provided for the lab:

ssh cloud_user@<PUBLIC-IP-ADDRESS>
Again, this will be recorded as a reject record, since you no longer have SSH access.

Press Ctrl+C to cancel the SSH command.

Navigate back to the EC2 Management Console tab.

Revert the EC2 instance security group back to SecurityGroupHTTPAndSSH:

Ensure the Web Server instance is selected, and then use the Actions dropdown to select Security > Change security groups.
In the Associated security groups section, click Remove to the right of the security group details to remove the SecurityGroupHTTPOnly group.
Use the search bar in the Associated security groups section to select the SecurityGroupHTTPAndSSH security group.
Click Add security group, and then click Save.
Navigate back to the CloudWatch Alarms tab and refresh the alarms details.

You should see that the alarm state is now In alarm. If you attached the alarm to your email address, you should receive a notification about this alarm.

Note: If the alarm state still shows Insufficient data, wait another moment or two and then refresh the alarms details again.

Use CloudWatch Logs Insights
In the CloudWatch sidebar menu, navigate to Logs and select Logs Insights.

Use the Select log group(s) search bar to select VPCFlowLogs.

In the right-hand pane, select Queries.

In the Sample queries section, expand VPC Flow Logs and then expand Top 20 source IP addresses with highest number of rejected requests.

Click Apply and note the changes applied in the query editor.

Click Run query.

After a few moments, you'll see some data start to populate.

Analyze VPC Flow Logs Data in Athena
Create the Athena Table
Navigate back to the S3 browser tab and then navigate to your Buckets.
Select the provisioned bucket name to open it.
Select the AWSLogs/ folder, and then continue opening the subfolders until you reach the <DAY> folder containing the logs.
In the top right, click Copy S3 URI.
Paste the URI into a text file, as you'll need it shortly.
In a new browser tab, navigate to Athena.
On the right, click Launch query editor.
Select the Settings tab and then click Manage.
In the Location of query result field, paste your copied S3 URI.
Click Save.
Create Partitions and Analyze the Data
Select the query editor's Editor tab.

In the Query 1 editor, paste the following query, replacing {your_log_bucket} and {account_id} with your log bucket and account ID details (you can pull these from the S3 URI path you copied):

CREATE EXTERNAL TABLE IF NOT EXISTS default.vpc_flow_logs (
  version int,
  account string,
  interfaceid string,
  sourceaddress string,
  destinationaddress string,
  sourceport int,
  destinationport int,
  protocol int,
  numpackets int,
  numbytes bigint,
  starttime int,
  endtime int,
  action string,
  logstatus string
)
PARTITIONED BY (dt string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ' '
LOCATION 's3://{your_log_bucket}/AWSLogs/{account_id}/vpcflowlogs/us-east-1/'
TBLPROPERTIES ("skip.header.line.count"="1");
Click Run.

You should see a message indicating that the query was successful.

On the right, click the + icon to open a new query editor.

In the editor, paste the following query, replacing {Year}-{Month}-{Day} with the current date, and replacing the existing location with your copied S3 URI:

ALTER TABLE default.vpc_flow_logs
    ADD PARTITION (dt='{Year}-{Month}-{Day}')
    location 's3://{your_log_bucket}/AWSLogs/{account_id}/vpcflowlogs/us-east-1/{Year}/{Month}/{Day}/';
Click Run.

You should see a message indicating that the query was successful.

On the right, click the + icon to open a new query editor.

In the editor, paste the following query:

SELECT day_of_week(from_iso8601_timestamp(dt)) AS
     day,
     dt,
     interfaceid,
     sourceaddress,
     destinationport,
     action,
     protocol
   FROM vpc_flow_logs
   WHERE action = 'REJECT' AND protocol = 6
   order by sourceaddress
   LIMIT 100;
Click Run.

Your partitioned data should display in the query results.
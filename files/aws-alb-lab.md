Use Application Load Balancers for Web Servers
Introduction
Load balancing automatically distributes your incoming traffic across multiple targets, such as EC2 instances, containers, and IP addresses, in one or more Availability Zones. In this lab, we configure an Application Load Balancer to distribute network traffic to two EC2 instances. We then enable stickiness, so that once a server is contacted, the user is always sent to that server. This ensures our legacy application continues to work despite not supporting distributed logins. By the end of this lab, the user will understand how to create an Application Load Balancer and enable sticky sessions.

Solution
Log in to the live AWS environment using the credentials provided. Use an incognito or private browser window to ensure you're using the lab account rather than your own.

Make sure you're in the N. Virginia (us-east-1) region throughout the lab.

Observe the Provided EC2 Website and Create a Second Server
Navigate to EC2.

Click Instances (running).

Select the box next to webserver-01.

Copy its Public IPv4 address.

In a new browser tab, paste in the public IP address you just copied. You should see the load balancer demo page.

Back in the EC2 console, at the top, click Launch instances.

Under Name and Tags, enter "webserver2".

Under Application and OS Images (Amazon Machine Image), select Ubuntu and Ubuntu Server 22.04 LTS.

Under Instance Type, select t3.micro.

Under Key pair (login), in the dropdown, select Proceed without a key pair.

Under Network settings, click Edit and set Auto-assign Public IP to Enable.

Under Network settings > Firewall (security groups), click Select existing security group and select the one with EC2SecurityGroup in its name (not the default security group).

Under Advanced Details, in the User Data box, enter the following bootstrap script:

#!/bin/bash
sudo apt-get update -y
sudo apt-get install apache2 unzip -y
echo '<html><center><body bgcolor="black" text="#39ff14" style="font-family: Arial"><h1>Load Balancer Demo</h1><h3>Availability Zone: ' > /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/placement/availability-zone >> /var/www/html/index.html
echo '</h3> <h3>Instance Id: ' >> /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/instance-id >> /var/www/html/index.html
echo '</h3> <h3>Public IP: ' >> /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/public-ipv4 >> /var/www/html/index.html
echo '</h3> <h3>Local IP: ' >> /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/local-ipv4 >> /var/www/html/index.html
echo '</h3></html> ' >> /var/www/html/index.html
Click Launch Instance.

Click the Instance ID (This will start with i-).

Once it's in the Running state, copy the Public IPv4 address.

In a new browser tab, paste in the public IP address you just copied. You should see the load balancer demo page again, which means the legacy clone is successfully running. This time, though, it will have a different instance ID, public IP, and local IP listed.

Create an Application Load Balancer
Back in the EC2 console, click Load Balancers in the left-hand menu.
Click Create Load Balancer.
From the Application Load Balancer card, click Create.
For Load balancer name, enter LegacyALB.
Under Network mapping, click the VPC dropdown, and select the listed VPC.
When the Availability Zones list pops up, select each one (us-east-1a, us-east-1b, and us-east-1c).
Under Security groups, deselect the default security group listed, and select the one from the dropdown with EC2SecurityGroup in its name.
Under Listeners and routing, ensure that the Protocol is set to HTTP and the Port is 80. Then, under Default action, click Create target group This will open a new tab. Keep this first tab open to complete later.
For Target group name, enter TargetGroup.
Click Next.
Under Available instances, select both targets that are listed.
Click Include as pending below.
Click Create target group.
Back in the first tab, under Default action, click the refresh button (looks like a circular arrow), and in the dropdown, select the TargetGroup you just created.
Click Create load balancer.
On the next screen, click View load balancer.
Wait a few minutes for the load balancer to finish provisioning and enter an active state.
Copy its DNS name, and paste it into a new browser tab. You should see the load balancer demo page again. The local IP lets you know which instance you were sent (or "load balanced") to.
Refresh the page a few times. You should see the other instance's local IP listed, meaning it's successfully load balancing between the two EC2 instances.
Enable Sticky Sessions
Back on the EC2 > Load Balancers page, select the Listeners tab.
Click the TargetGroup link in the Rules column, which opens the target group.
Click the only link to open TargetGroup.
Select the Attributes tab.
Click Edit.
Check the box next to Stickiness to enable it.
Leave Stickiness type set to Load balancer generated cookie.
Leave Stickiness duration set to 1 days.
Click Save changes.
Refresh the tab where you navigated to the load balancer's public IP. This time, no matter how many times you refresh, it will stay on the same instance (noted by the local IP).

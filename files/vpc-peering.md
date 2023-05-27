Build Solutions across VPCs with Peering
Introduction
A VPC peering connection is a networking connection between two VPCs that enables you to route traffic between them using private IPv4 addresses or IPv6 addresses. In this lab, you will create a new VPC for your WordPress blog to run from. You will then create a VPC peering connection between the new VPC and an existing database VPC. By the end of this lab, you will understand how to create a new VPC from scratch, attach internet gateways, edit routing tables, and peer multiple VPCs together.

Solution
Log in to the AWS Management Console using the credentials provided on the lab instructions page. Make sure you're in the N. Virginia (us-east-1) Region throughout the lab.

Create Web_VPC Subnets and Attach a New Internet Gateway
Create a VPC
Use the top search bar to look for and navigate to VPC.
Under Resources by Region, click VPCs.
Use the top search bar to look for and navigate to RDS in a new tab.
Click DB Instances, and observe the instance created for this lab.
Note: Keep this tab open for use later on in the lab.

Go back to your VPC tab, and click Create VPC.
Ensure the VPC only option is selected.
Set the following values:
Name tag: Enter Web_VPC.
IPv4 CIDR block: Enter 192.168.0.0/16.
Leave the rest of the settings as their defaults, and click Create VPC.
Create a Subnet
On the left menu under VIRTUAL PRIVATE CLOUD, select Subnets.
Click Create subnet.
For VPC ID, select the newly created Web_VPC.
Under Subnet settings, set the following values:
Subnet name: Enter WebPublic.
Availability Zone: Select us-east-1a.
IPv4 CIDR block: Enter 192.168.0.0/24.
Click Create subnet.
Create an Internet Gateway
On the left menu, select Internet Gateways.
Click Create internet gateway.
For Name tag, enter WebIG.
Click Create internet gateway.
In the green notification at the top of the page, click Attach to a VPC.
In Available VPCs, select the Web_VPC and click Attach internet gateway.
On the left menu, select Route Tables.
Select the checkbox for the Web_VPC.
Underneath, select the Routes tab and click Edit routes.
Click Add route.
Set the following values:
Destination: Enter 0.0.0.0/0.
Target: Select Internet Gateway, and select the internet gateway that appears in the list.
Click Save changes.
Create a Peering Connection
On the left menu, select Peering Connections.
Click Create peering connection.
Set the following values:
Name: Enter DBtoWeb.
VPC (Requester): Select the DB_VPC.
VPC (Accepter): Select the Web_VPC.
Click Create peering connection.
At the top of the page, click Actions > Accept request.
Click Accept request.
On the left menu, select Route Tables.
Select the checkbox for the Web_VPC.
Underneath, select the Routes tab, and click Edit routes.
Click Add route.
Set the following values:
Destination: Enter 10.0.0.0/16.
Target: Select Peering Connection, and select the peering connection that appears in the list.
Click Save changes.
Go back to Route Tables, and select the checkbox for the DB_VPC instance with a Main column value of Yes.
Underneath, select the Routes tab, and click Edit routes.
Click Add route.
Set the following values:
Destination: Enter 192.168.0.0/16.
Target: Select Peering Connection, and select the peering connection that appears in the list.
Click Save changes.
Create an EC2 Instance and Configure WordPress
In a new browser tab, navigate to EC2.

Click Launch instance > Launch instance.

Scroll down and under Quick Start, select the Ubuntu image box. (You can skip the Name field before this.)

Under Amazon Machine Image (AMI), click the dropdown and select Ubuntu Server 20.04 LTS.

Under Instance type, click the dropdown and select t3.micro.

For Key pair, click the dropdown and select Proceed without a key pair.

In the Network settings section, click the Edit button.

Set the following values:

VPC: Select the Web_VPC.
Subnet: Ensure the WebPublic subnet is selected.
Auto-assign public IP: Select Enable.
Under Firewall (security groups), ensure Create security group is selected (the default value).

Scroll down and click Add security group rule.

Set the following values for the new rule (i.e., Security group rule 2):

Type: Select HTTP.
Source: Select 0.0.0.0/0.
Scroll to the bottom, and expand Advanced details.

At the bottom, under User data, copy and paste the following bootstrap script:

#!/bin/bash
sudo apt update -y
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip perl mysql-server apache2 libapache2-mod-php php-mysql -y
wget https://github.com/ACloudGuru-Resources/course-aws-certified-solutions-architect-associate/raw/main/lab/5/wordpress.tar.gz
tar zxvf wordpress.tar.gz
cd wordpress
wget https://raw.githubusercontent.com/ACloudGuru-Resources/course-aws-certified-solutions-architect-associate/main/lab/5/000-default.conf
cp wp-config-sample.php wp-config.php
perl -pi -e "s/database_name_here/wordpress/g" wp-config.php
perl -pi -e "s/username_here/wordpress/g" wp-config.php
perl -pi -e "s/password_here/wordpress/g" wp-config.php
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php
mkdir wp-content/uploads
chmod 775 wp-content/uploads
mv 000-default.conf /etc/apache2/sites-enabled/
mv /wordpress /var/www/
apache2ctl restart
At the bottom, click Launch Instance.

Note: It may take a few minutes for the new instance to launch.

From the green box that appears after the instance launches, open the link for the instance in a new browser tab.

Observe the Instance state column, and check to ensure it is Running before you proceed.

Select the checkbox for the new instance and click Connect.

Click Connect.

Note: The startup script for the instance may take a few minutes to complete and you may need to wait for it to complete before proceeding with the next step.

To confirm WordPress installed correctly, view the configuration files:

cd /var/www/wordpress
ls
To configure WordPress, open wp-config.php:

sudo vim wp-config.php
Go back to your browser tab with RDS.

Click the link to open the provisioned RDS instance.

Under Connectivity & security, copy the RDS Endpoint.

Go back to the tab with the terminal, and scroll down to /** MySQL hostname */.

Press i to enter Insert mode.

Replace localhost with the RDS endpoint you just copied. Ensure it remains wrapped in single quotes.

Press ESC followed by :wq, and press Enter. Leave this tab open.

Modify the RDS Security Groups to Allow Connections from the Web_VPC VPC
Go back to your RDS browser tab.
In Connectivity & security, click the active link under VPC security groups.
At the bottom, select the Inbound rules tab.
Click Edit inbound rules.
Click Add rule.
Under Type, search for and select MYSQL/Aurora.
Under Source, search for and select 192.168.0.0/16.
Click Save rules.
Return to the terminal page.
Below the terminal window, copy the public IP address of your server.
Open a new browser tab and paste the public IP address in the address bar. You should now see the WordPress installation page.
Set the the following values:
Site Title: Enter A Blog Guru.
Username: Enter guru.
Your Email: Enter test@test.com.
Click Install WordPress.
Reload the public IP address in the address bar to view your newly created WordPress blog.
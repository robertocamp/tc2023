Set Up a WordPress Site Using EC2 and RDS
Introduction
Amazon Relational Database Service (Amazon RDS) allows users to easily create, operate, and scale a relational database in the cloud. In this lab, we create an RDS database, install a web server and configure WordPress to connect to the RDS database. We then run the final configuration through the web browser and are presented with a working WordPress blog. By the end of this lab, the user will understand how to create an RDS database and configure WordPress to use it to store data.

Solution
Log in to the AWS Management Console using the credentials provided on the lab instructions page. Make sure you're using the us-east-1 region.

Create RDS Database
In the AWS management console, enter "RDS" into the search bar on top.
From the results, select RDS.
Click Create database.
On the Create database page, set the following parameters:
Select Standard create.
Under Engine options, select MySQL.
Select Version: MySQL 8.0.28.
Under Templates, select Free tier
Under DB instance identifier, enter "wordpress" and copy this into your clipboard.
Use "wordpress" as the username and the password.
Under DB instance class, select db.t2.micro.
Under Connectivity, select the existing VPC and leave the Don't connect to an EC2 compute resource selected.
Under VPC security group, select the non-default security group from the dropdown menu and remove the default security group.
Under Availability zone, select us-east-1a.
Expand Additional configuration and, under Initial database name, enter "wordpress".
Under Backups, uncheck the Enable automatic backups option.
Click Create database.
While the database is created, enter "EC2" in the search bar on top.
From the results, right-click EC2 and open it in a new browser window or tab.
Under Resources, click Instances (running).
Click the checkbox next to webserver-01.
In the top right, click Connect.
Click Connect.
Install Apache and Dependencies
In the terminal, install the Apache 2 web server, libraries, PHP, and PHP MySQL:

sudo apt install apache2 libapache2-mod-php php-mysql -y
When prompted, press Y for yes and hit Enter.

Go into the newly created /var/www directory:

cd /var/www
View the contents of the directory:

ls
Put wordpress into its own folder in the /var/www directory that we're currently in:

sudo mv /wordpress .
View the contents of the directory:

ls
Move into the wordpress directory:

cd wordpress
Move the Apache configuration file into /etc/apache2/sites-enabled/ to enable the WordPress website to work from /var/www/wordpress:

sudo mv 000-default.conf /etc/apache2/sites-enabled/
Restart the Apache 2 configuration:

sudo apache2ctl restart
Open the WordPress config PHP file for editing:

sudo nano wp-config.php
Return to the browser window or tab that has the RDS Databases open.

Click the wordpress database.

In the Connectivity & security tab, under Endpoint, copy the endpoint provided into your clipboard.

Return to your terminal.

Change the line define('DB_HOST', 'localhost'); to read:

define('DB_HOST', '<INSERT ENDPOINT HERE>');
Save and exit by pressing Control + X, followed by Y, and hitting Enter.

Modify Security Groups
Return to your browser window or tab with the EC2 Connect to instance page open.
In the left-hand navigation menu, under Networks & Security, click Security Groups.
Click the checkmark next to the non-default security group among those provided in the lab.
Click the Inbound rules tab.
Click the Edit inbound rules button.
Click the Add rule button.
For the new rule, from the Type dropdown menu, select MYSQL/Aurora.
In the dropdown menu to the right of the Source column for the new rule, find and select the non-default security group.
Click Save rules.
Complete Wordpress Installation and Test
Return to the terminal.
At the bottom of the screen on the white bar, copy the public IP being shown after Public IPs.
Open a new browser window or tab, and paste it there.
On the WordPress installation page, enter in the following information for each field:
Site Title: "A Cloud Guru"
Username: "guru"
Password: Select a strong password to use here, and make sure to copy it in your clipboard for later.
Your Email: "test@test.com"
Click Install WordPress.
Click Log in.
Enter "guru" for the Username or email and paste in the password that you copied earlier.
To view the website you just created, click A Cloud Guru in the top right corner of the page..
Click Visit Site to visit your newly created WordPress site.
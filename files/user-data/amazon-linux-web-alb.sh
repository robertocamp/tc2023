#!/bin/bash
sudo yum update -y
sudo yum install -y httpd unzip

sudo echo '<html><center><body bgcolor="black" text="#39ff14" style="font-family: Arial"><h1>Load Balancer Demo</h1><h3>Availability Zone: ' > /var/www/html/index.html
sudo curl http://169.254.169.254/latest/meta-data/placement/availability-zone >> /var/www/html/index.html
sudo echo '</h3> <h3>Instance Id: ' >> /var/www/html/index.html
sudo curl http://169.254.169.254/latest/meta-data/instance-id >> /var/www/html/index.html
sudo echo '</h3> <h3>Public IP: ' >> /var/www/html/index.html
sudo curl http://169.254.169.254/latest/meta-data/public-ipv4 >> /var/www/html/index.html
sudo echo '</h3> <h3>Local IP: ' >> /var/www/html/index.html
sudo curl http://169.254.169.254/latest/meta-data/local-ipv4 >> /var/www/html/index.html
sudo echo '</h3></html> ' >> /var/www/html/index.html

sudo service httpd start
sudo chkconfig httpd on

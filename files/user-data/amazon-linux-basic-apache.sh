#!/bin/bash
sudo yum update -y
sudo yum install -y httpd unzip
sudo service httpd start
sudo chkconfig httpd on
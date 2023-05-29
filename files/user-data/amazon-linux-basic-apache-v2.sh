#!/bin/bash

# Install Apache web server
yum install -y httpd

# Start Apache web server
systemctl start httpd

# Enable Apache web server to start on boot
systemctl enable httpd

# Install AWS SSM agent
yum install -y amazon-ssm-agent
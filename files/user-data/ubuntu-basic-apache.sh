#!/bin/bash
sudo apt-get update -y
sudo apt-get install apache2 unzip -y
sudo echo "Hello World from $(hostname -f)" /var/www/html/index.html

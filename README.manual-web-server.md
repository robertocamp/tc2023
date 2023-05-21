

## Apache splash page
- `sudo apt-get update && sudo apt-get upgrade -y`
-  `sudo apt-get install apache2 -y`

## AWS CLI
- `sudo apt-get install unzip -y`
- `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`
- `unzip awscliv2.zip`
- `sudo ./aws/install`
- `aws --version`
- `sudo chmod 777 /var/www/html/index.html`

## instance metadata
`curl http://169.254.169.254/latest/meta-data/placement/availability-zone`

## index.html file from instance metadata
```
echo '<html><h1>Bootstrap Demo</h1><h3>Availability Zone: ' > /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/placement/availability-zone >> /var/www/html/index.html
echo '</h3> <h3>Instance Id: ' >> /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/instance-id >> /var/www/html/index.html
echo '</h3> <h3>Public IP: ' >> /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/public-ipv4 >> /var/www/html/index.html
echo '</h3> <h3>Local IP: ' >> /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/local-ipv4 >> /var/www/html/index.html
echo '</h3></html> ' >> /var/www/html/index.html
```

## mysql
`sudo apt-get install mysql-server -y`

## user data
#!/bin/bash
sudo apt-get update -y
sudo apt-get install apache2 unzip -y
sudo systemctl enable apache2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
echo '<html><h1>Bootstrap Demo</h1><h3>Availability Zone: ' > /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/placement/availability-zone >> /var/www/html/index.html
echo '</h3> <h3>Instance Id: ' >> /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/instance-id >> /var/www/html/index.html
echo '</h3> <h3>Public IP: ' >> /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/public-ipv4 >> /var/www/html/index.html
echo '</h3> <h3>Local IP: ' >> /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/local-ipv4 >> /var/www/html/index.html
echo '</h3></html> ' >> /var/www/html/index.html
sudo apt-get install mysql-server -y
sudo systemctl enable mysql

## checkout and troubleshooting
`sudo systemctl status apache2`
`curl http://169.254.169.254/latest/user-data`
`systemctl status mysql`
`sudo apt-get install mysql-server`
`aws --version`

## EC2 Roles and Instance Profiles

`aws iam create-role --role-name DEV_ROLE --assume-role-policy-document file://trust_policy_ec2.json`
`aws iam create-policy --policy-name DevS3ReadAccess --policy-document file://dev_s3_read_access.json`
`aws iam attach-role-policy --role-name DEV_ROLE --policy-arn "arn:aws:iam::755889206436:policy/DevS3ReadAccess"`
`aws iam list-attached-role-policies --role-name DEV_ROLE`

- **create instance profile**
- `aws iam create-instance-profile --instance-profile-name DEV_PROFILE`
- **add role to profile**
`aws iam add-role-to-instance-profile --instance-profile-name DEV_PROFILE --role-name DEV_ROLE`
- **verify the instance profile**
`aws iam add-role-to-instance-profile --instance-profile-name DEV_PROFILE --role-name DEV_ROLE`

- **attach a Profile to an Instance**
`aws ec2 associate-iam-instance-profile --instance-id i-051f7cc4765ddd166 --iam-instance-profile Name="DEV_PROFILE"`
`aws ec2 describe-instances --instance-ids i-051f7cc4765ddd166`

- **verify the the instance is assuming the DEV_ROLE**
`aws sts get-caller-identity`

## EFS mounts
- `sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 10.0.0.225:/ /efs`
- `lsblk`
- `df -h` 
- 
#Project 6: Exploring AWS Identity and Access Management (IAM) aws iam list-users

aws iam list-groups

aws iam get-user --user-name user-1
aws iam get-user --user-name user-2
aws iam get-user --user-name user-3

aws iam get-group --group-name S3-Supprt 
aws iam get-group --group-name EC2-Support
aws iam get-group --group-name EC2-Admin


aws iam list-attached-group-policies --group-name S3-Support
aws iam list-attached-group-policies --group-name Ec2-Support
aws iam list-attached-group-policies --group-name EC2-Admin

aws iam get-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess
aws iam get-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess


aws iam add-user-to-group --user-name User-1 --group-name S3-Support
aws iam add-user-to-group --user-name User-2 --group-name EC2-Support
aws iam add-user-to-group --user-name User-3 --group-name EC2-Admin

aws iam get-group --group-name S3-Supprt 
aws iam get-group --group-name EC2-Support
aws iam get-group --group-name EC2-Admin

#############################################################################################
#Project 7: Creating an Amazon Virtual Private Cloud (VPC)

aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value="Lab VPC"}]'

aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=Lab VPC}]"

aws ec2 modify-vpc-attribute --vpc-id vpc-0950a6d0127f968c4 --enable-dns-support

aws ec2 modify-vpc-attribute --vpc-id vpc-0950a6d0127f968c4 --enable-dns-hostnames

aws ec2 create-subnet --vpc-id vpc-0950a6d0127f968c4 --cidr-block 10.0.0.0/24 --availability-zone us-east-1a --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=Public Subnet}]"

aws ec2 create-subnet --vpc-id vpc-0950a6d0127f968c4 --cidr-block 10.0.2.0/23 --availability-zone us-east-1a --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=Private Subnet}]"

aws ec2 modify-subnet-attribute --subnet-id subnet-0948afb12034ea524 --map-public-ip-on-launch

aws ec2 create-internet-gateway --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=Lab IGW}]"

aws ec2 create-route-table --vpc-id vpc-0950a6d0127f968c4 --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=Public Route Table}]"

aws ec2 create-route --route-table-id rtb-0ddff7ef59dc3fdf4 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-05b8c2fbbefa24a52

aws ec2 associate-route-table --subnet-id subnet-0948afb12034ea524 --route-table-id rtb-0ddff7ef59dc3fdf4

aws ec2 create-security-group --group-name App-SG --description "Security group for app server" --vpc-id vpc-0950a6d0127f968c4

aws ec2 authorize-security-group-ingress --group-id sg-0abe956cf3a5e755c --protocol tcp --port 80 --cidr 0.0.0.0/0

aws ec2 run-instances --image-id ami-0fff1b9a61dec8a5f --count 1 --instance-type t2.micro --key-name vockey --security-group-ids sg-0abe956cf3a5e755c --subnet-id subnet-0948afb12034ea524 --tag-specifications 

aws ec2 run-instances --image-id ami-0fff1b9a61dec8a5f --count 1 --instance-type t2.micro --key-name vockey --security-group-ids sg-0abe956cf3a5e755c --subnet-id subnet-0948afb12034ea524 --tag-specifications
##############################################################################################
#Project 8: Creating an Amazon RDS Database 

#!/bin/bash

# Describe DB Subnet Groups
aws rds describe-db-subnet-groups

# Create DB Instance
aws rds create-db-instance \
    --db-instance-identifier inventory-db \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --allocated-storage 20 \
    --master-username admin \
    --master-user-password lab-password \
    --backup-retention-period 7 \
    --no-multi-az \
    --vpc-security-group-ids sg-0898542b4a50f7c32 \
    --db-subnet-group-name lab-db-subnet-group \
    --storage-type gp2 \
    --db-name inventory \
    --publicly-accessible 
# Describe DB Instances
aws rds describe-db-instances --db-instance-identifier inventory-db

# Describe Events for the DB Instance
aws rds describe-events --source-identifier inventory-db --source-type db-instance

# Describe secret in Secrets Manager
aws secretsmanager describe-secret --secret-id inventory-db-secret

# Add a secret to Secrets Manager
aws secretsmanager create-secret \
    --name inventory-db-secret \
    --secret-string '{"username":"admin","password":"lab-password","database":"inventory","endpoint":"inventory-db.crwxbgqad61a.rds.amazonaws.com"}'

# Update the secret in Secrets Manager
aws secretsmanager update-secret \
    --secret-id inventory-db-secret \
    --secret-string '{"username":"admin","password":"lab-password","database":"inventory","endpoint":"inventory-db.crwxbgqad61a.rds.amazonaws.com"}'









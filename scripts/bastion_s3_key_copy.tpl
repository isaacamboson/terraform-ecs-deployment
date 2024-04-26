#!/bin/bash

sudo su - ec2-user
# sudo su -

#Downloading PEM Key from S3
aws s3 cp s3://${s3_bucket}/${pem_key} /home/ec2-user/${pem_key}
# aws s3 cp s3://${s3_bucket}/${pem_key} /root/${pem_key}

#changing permission of pem key
chmod 400 /home/ec2-user/${pem_key}
# chmod 400 /root/${pem_key}

sudo yum update -y
# sudo yum install -y nfs-utils

load_balancer_dns=${LB_DNS}

#updating rds instance / database with the new load balancer dns from terraform output
rds_mysql_endpoint=${rds_mysql_ept}
rds_mysql_user=${rds_mysql_usr}
rds_mysql_password=${rds_mysql_pwd}
rds_mysql_database=${rds_mysql_db}

mysql -h $rds_mysql_endpoint -u $rds_mysql_user -p$rds_mysql_password -D $rds_mysql_database <<EOF
UPDATE wp_options SET option_value = "$load_balancer_dns" WHERE option_id = '1';
UPDATE wp_options SET option_value = "$load_balancer_dns" WHERE option_id = '2';
EOF
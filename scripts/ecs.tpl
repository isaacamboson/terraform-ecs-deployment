#!/bin/bash

## Configure cluster name using the template variable ${ecs_cluster_name}
echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config

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
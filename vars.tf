variable "AWS_REGION" {
  default     = "us-east-1"
  description = "AWS region where our resources are going to be deployed"
}

variable "environment" {
  default = "dev"
}

variable "OwnerEmail" {
  default = "isaacamboson@gmail.com"
}

variable "system" {
  default = "Retail Reporting"
}

variable "backup" {
  default = "yes"
}

variable "subsystem" {
  default = "CliXX"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-stack-1.0"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}

variable "device_names" {
  default = ["/dev/sdb", "/dev/sdc", "/dev/sdd", "/dev/sde", "/dev/sdf"]
}

variable "app_image" {
  default     = "767398027423.dkr.ecr.us-east-1.amazonaws.com/clixx-repository:latest"
  description = "docker image to run in this ECS cluster"
}

variable "app_port" {
  default     = "80"
  description = "portexposed on the docker image"
}

# variable "ec2_cpu" {
#   default     = "10"
#   description = "ec2 instance CPU units to provision, my requirement 1 vcpu so gave 1024"
# }

# variable "ec2_memory" {
#   default     = "512"
#   description = "ec2 instance memory to provision (in MiB) not MB"
# }

variable "stack_controls" {
  type = map(string)
  default = {
    ec2_create = "Y"
    rds_create = "Y"
  }
}

variable "EC2_Components" {
  type = map(string)
  default = {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = "true"
    instance_type         = "t2.medium"
  }
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "project_name" {
  type    = string
  default = "manga1"
}

variable "availability_zone" {
  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = [
    "10.1.2.0/23", # 510 hosts   - bastion, load balancer
    "10.1.4.0/23"  # 510 hosts   - bastion, load balancer
  ]
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = [
    "10.1.0.0/24", # 254 hosts   - Application Server
    "10.1.1.0/24", # 254 hosts   - Application Server
    "10.1.8.0/22", # 1022 hosts  - RDS
    "10.1.12.0/22" # 1022 hosts  - RDS
  ]
}

variable "server_count" {
  description = "number of servers to be built"
  default     = 4
}

variable "bastion_server_count" {
  description = "number of bastion servers to be built"
  default     = 2
}

variable "access_ports_public" {
  description = "various ingress ports allowed on the security group for load balancer and bastion"
  type        = list(number)
  default     = [22, 80, 443, 8080]
}

variable "app_sg_access_ports" {
  type    = list(number)
  default = [22, 80, 443, 8080]
}

variable "ecs_sg_access_ports" {
  type    = list(number)
  default = [22, 80, 443, 8080]
}

variable "rds_sg_access_ports" {
  type    = list(number)
  default = [3306]
}

variable "efs_sg_access_ports" {
  type    = list(number)
  default = [2049]
}

variable "TG_Components" {
  type = map(string)
  default = {
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 15
    matcher             = "200"
    path                = "/"
    traffic_port        = "traffic-port"
  }
}

variable "ASG_Components" {
  type = map(string)
  default = {
    desired_capacity = 4
    max_size         = 6
    min_size         = 4
  }
}

variable "ECS_Service_Components" {
  type = map(string)
  default = {
    desired_count                      = 4
    deployment_minimum_healthy_percent = 50
    deployment_maximum_percent         = 100
    port                               = 80
  }
}

variable "ECS_Capacity_Components" {
  type = map(string)
  default = {
    maximum_scaling_step_size = 5
    minimum_scaling_step_size = 1
    target_capacity           = 100
  }
}

variable "ECS_Appautoscaling_Components" {
  type = map(string)
  default = {
    max_capacity               = 10
    min_capacity               = 2
    target_value_cpu_policy    = 70
    target_value_memory_policy = 80
  }
}

variable "DB_Components" {
  type = map(string)
  default = {
    instance_class       = "db.m6gd.large"
    allocated_storage    = 20
    iops                 = 3000
    engine               = "mysql"
    engine_version       = "8.0.28"
    parameter_group_name = "default.mysql8.0"
    skip_final_snapshot  = true
    publicly_accessible  = true
  }
}

variable "identifier" {
  type = string
  # default = "wordpressdbclixx"
  default = "wordpressdbclixxjenkins"
}

variable "snapshot_identifier" {
  type = string
  # default = "arn:aws:rds:us-east-1:767398027423:snapshot:wordpressdbclixx-snapshot"
  default = "arn:aws:rds:us-east-1:767398027423:snapshot:wordpressdbclixxjenkins-snapshot"
}

variable "route53_name" {
  type    = string
  default = "dev.clixx"
}

variable "route53_type" {
  type    = string
  default = "A"
}

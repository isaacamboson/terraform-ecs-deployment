# variable "AWS_ACCESS_KEY" {}

# variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
  default     = "us-east-1"
  description = "AWS region where our resources are going to be deployed"
}

variable "ecs_task_execution_role" {
  default     = "myECSTaskExecutionRole"
  description = "ECS task execution role name"
}

variable "app_image" {
  default     = "767398027423.dkr.ecr.us-east-1.amazonaws.com/clixx-repository:latest"
  description = "docker image to run in this ECS cluster"
}

variable "availability_zone" {
  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "app_port" {
  default     = "80"
  description = "portexposed on the docker image"
}

variable "health_check_path" {
  default = "/"
}

variable "ec2_cpu" {
  default     = "10"
  description = "ec2 instance CPU units to provision, my requirement 1 vcpu so gave 1024"
}

variable "ec2_memory" {
  default     = "512"
  description = "ec2 instance memory to provision (in MiB) not MB"
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = [
    "10.1.2.0/23",
    "10.1.4.0/23"
  ]
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = [
    "10.1.0.0/24",
    "10.1.16.0/24",
    "10.1.1.0/24",
    "10.1.17.0/24"
  ]
}

variable "environment" {
  default = "dev"
}

variable "OwnerEmail" {
  default = "isaacamboson@gmail.com"
}

variable "device_names" {
  default = ["/dev/sdb", "/dev/sdc", "/dev/sdd", "/dev/sde", "/dev/sdf"]
}

#controls / conditionals
variable "stack_controls" {
  type = map(string)
  default = {
    ec2_create = "Y"
    # ec2_create_clixx = "Y"
    # ec2_create_blog  = "Y"
    rds_create_clixx = "Y"
    # rds_create_blog  = "Y"
  }
}

#components for EC2 instances
variable "EC2_Components" {
  type = map(string)
  default = {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = "true"
    instance_type         = "t2.micro"
  }
}


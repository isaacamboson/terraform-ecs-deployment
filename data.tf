data "aws_ami" "stack_ami" {
  owners      = ["self"]
  name_regex  = "^ami-stack*"
  most_recent = true

  filter {
    name   = "name"
    values = ["ami-stack-*"]
  }
}

data "aws_ami" "ecs-optimized" {

  owners = ["767397882686"]
  name_regex = "^ami-stack-activiti-ecs-1.0*"
  most_recent = true

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

data "aws_secretsmanager_secret_version" "creds" {
  # fill in the name you gave the secret
  secret_id = "creds"
}

data "aws_route53_zone" "stack_isaac_zone" {
  name         = "stack-isaac.com." # Notice the dot!!!
  private_zone = false
}
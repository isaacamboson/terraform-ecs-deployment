locals {
  ServerPrefix = "Bastion_Server"

  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

# module call
module "CORE-INFO" {
  # source = "../../../MODULES/CORE-INFO"
  source                    = "github.com/isaacamboson/terraform-modules/MODULES/CORE-INFO"
  required_tags             = {
    Environment             = var.environment,
    OwnerEmail              = var.OwnerEmail,
    System                  = var.system,
    Backup                  = var.backup,
    Region                  = var.AWS_REGION
  }
}

module "VPC-BASE" {
  # source = "../../../MODULES/VPC-BASE"
  source                      = "github.com/isaacamboson/terraform-modules/MODULES/VPC-BASE"
  project_name                = var.project_name
  vpc_cidr                    = var.vpc_cidr
  availability_zone           = var.availability_zone
  public_subnet_cidrs         = var.public_subnet_cidrs
  private_subnet_cidrs        = var.private_subnet_cidrs
}

module "SECURITY-BASE" {
  # source = "../../../MODULES/SECURITY-BASE"
  source                      = "github.com/isaacamboson/terraform-modules/MODULES/SECURITY-BASE"
  project_name                = var.project_name
  vpc_main_id                 = module.VPC-BASE.vpc_main_id
  access_ports_public         = var.access_ports_public
  app_sg_access_ports         = var.app_sg_access_ports
  ecs_sg_access_ports         = var.ecs_sg_access_ports
  rds_sg_access_ports         = var.rds_sg_access_ports
  efs_sg_access_ports         = var.efs_sg_access_ports
  resource_tags               = module.CORE-INFO.all_resource_tags
}

module "ALB-BASE" {
  # source                      = "../../../MODULES/ALB-BASE"
  source                        = "github.com/isaacamboson/terraform-modules/MODULES/ALB-BASE"
  project_name                  = var.project_name
  pub_subnets                   = module.VPC-BASE.public_subnets_id
  lb_security_group             = module.SECURITY-BASE.alb_bastion_sg_id
  TG_Components                 = var.TG_Components
  vpc_main_id                     = module.VPC-BASE.vpc_main_id
}

module "ASG-BASE" {
  # source                        = "../../../MODULES/ASG-BASE"
  source                        = "github.com/isaacamboson/terraform-modules/MODULES/ASG-BASE"
  project_name                  = var.project_name
  server_count                  = var.server_count
  ASG_Components                = var.ASG_Components
  asg_private_subnets_id        = module.VPC-BASE.asg_private_subnets_id
  EC2_Components                = var.EC2_Components
  stack_controls                = var.stack_controls
  image_id                      = data.aws_ami.ecs-optimized.image_id #ECS Optimized
  ecs_user_data                 = base64encode(data.template_file.ecs_user_data.rendered)
  ecs_sg_id                     = module.SECURITY-BASE.ecs_sg_id
  device_names                  = var.device_names
  aws_db_instance_depends_on    = module.RDS-BASE.aws_db_instance
  aws_lb_target_group_arn       = module.ALB-BASE.aws_lb_target_group_arn
  ec2_instance_role_profile_arn = module.ECS-BASE.ec2_instance_role_profile_arn
  resource_tags                 = module.CORE-INFO.all_resource_tags
}

module "BASTION-BASE" {
  # source = "../../../MODULES/EC2-BASE"
  source                        = "github.com/isaacamboson/terraform-modules/MODULES/EC2-BASE"
  server_count                  = var.bastion_server_count
  ami_id                        = data.aws_ami.stack_ami.id
  stack_controls                = var.stack_controls
  EC2_Components                = var.EC2_Components
  user_data_bootstrap           = data.template_file.bastion_s3_cp_bootstrap.rendered
  alb_bastion_sg_id             = module.SECURITY-BASE.alb_bastion_sg_id
  env                           = var.environment
  public_subnets_id             = module.VPC-BASE.public_subnets_id
  resource_tags                 = module.CORE-INFO.all_resource_tags
}

module "ECS-BASE" {
  # source                      = "../../../MODULES/ECS-BASE"
  source                        = "github.com/isaacamboson/terraform-modules/MODULES/ECS-BASE"
  project_name                  = var.project_name
  environment                   = var.environment
  container_definitions         = data.template_file.clixx-app.rendered
  ECS_Service_Components        = var.ECS_Service_Components
  aws_lb_target_group_arn       = module.ALB-BASE.aws_lb_target_group_arn
  aws_db_instance_depends_on    = module.RDS-BASE.aws_db_instance
}

module "ECS-CAPACITY-BASE" {
  # source                        = "../../../MODULES/ECS-CAPACITY-BASE"
  source                        = "github.com/isaacamboson/terraform-modules/MODULES/ECS-CAPACITY-BASE"
  project_name                  = var.project_name
  environment                   = var.environment
  autoscaling_grp_arn           = module.ASG-BASE.autoscaling_grp_arn
  aws_ecs_cluster_name          = module.ECS-BASE.aws_ecs_cluster_name
  aws_ecs_service_name          = module.ECS-BASE.aws_ecs_service_name
  ECS_Capacity_Components       = var.ECS_Capacity_Components
  ECS_Appautoscaling_Components = var.ECS_Appautoscaling_Components
}

module "RDS-BASE" {
  # source                 = "../../../MODULES/RDS-BASE"
  source                        = "github.com/isaacamboson/terraform-modules/MODULES/RDS-BASE"
  project_name                  = var.project_name
  environment                   = var.environment
  stack_controls                = var.stack_controls
  DB_Components                 = var.DB_Components
  identifier                    = var.identifier
  snapshot_identifier           = var.snapshot_identifier
  rds_security_group_ids        = module.SECURITY-BASE.rds_sg_id
  rds_private_subnets_id        = module.VPC-BASE.rds_private_subnets_id
}

module "route53" {
  # source          = "../../../MODULES/ROUTE53-BASE"
  source                        = "github.com/isaacamboson/terraform-modules/MODULES/ROUTE53-BASE"
  zone_id                       = data.aws_route53_zone.stack_isaac_zone.id
  route53_name                  = var.route53_name
  route53_type                  = var.route53_type
  alb_lb_dns_name               = module.ALB-BASE.alb_lb_dns_name
  alb_lb_zone_id                = module.ALB-BASE.alb_lb_zone_id
}


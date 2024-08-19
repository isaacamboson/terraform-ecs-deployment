# #creating the ECS cluster 
# resource "aws_ecs_cluster" "clixx-cluster" {
#   name = "${local.ApplicationPrefix}-app-cluster"

#   # lifecycle {
#   #   create_before_destroy = true
#   # }

#   tags = {
#     Name = "${local.ApplicationPrefix}-app-cluster"
#   }
# }

# #creating the ECS task definition
# resource "aws_ecs_task_definition" "clixx-def" {
#   family             = "${local.ApplicationPrefix}-app-task-def"
#   execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn      = aws_iam_role.ecs_task_iam_role.arn
#   requires_compatibilities = ["EC2"]
#   container_definitions = data.template_file.clixx-app.rendered

#   runtime_platform {
#     cpu_architecture        = "X86_64"
#     operating_system_family = "LINUX"
#   }

#   tags = {
#     Name = "${local.ApplicationPrefix}-app-container"
#   }
# }

# #creating the ECS service
# resource "aws_ecs_service" "clixx-service" {
#   name                               = "${local.ApplicationPrefix}-app-service"
#   iam_role                           = aws_iam_role.ecs_service_role.arn
#   cluster                            = aws_ecs_cluster.clixx-cluster.id
#   task_definition                    = aws_ecs_task_definition.clixx-def.arn
#   desired_count                      = 4   #How many ECS tasks should run in parallel  #How many percent of a service must be running to still execute a safe deployment
#   deployment_minimum_healthy_percent = 50  #How many percent of a service must be running to still execute a safe deployment
#   deployment_maximum_percent         = 100 #How many additional tasks are allowed to run (in percent) while a deployment is executed

#   load_balancer {
#     target_group_arn = aws_lb_target_group.clixx-app-tg.arn
#     #Name of the container to associate with the load balancer (as it appears in a container definition)
#     container_name = "${local.ApplicationPrefix}-app-container"
#     container_port = var.app_port
#   }

#   # Spread tasks evenly accross all Availability Zones for High Availability
#   ordered_placement_strategy {
#     type  = "spread"
#     field = "attribute:ecs.availability-zone"
#   }

#   # Make use of all available space on the Container Instances
#   ordered_placement_strategy {
#     type  = "binpack"
#     field = "memory"
#   }

#   # Do not update desired count again to avoid a reset to this number on every deployment
#   # lifecycle {
#   #   ignore_changes = [desired_count]
#   # }

#   # depends_on = [aws_lb_listener.clixx-app, aws_iam_role_policy_attachment.ecs_task_execution_role_policy]
# }

# #############################################################################################
# # this security group for ecs - Traffic to the ECS cluster should only come from the LB
# resource "aws_security_group" "ecs_sg" {
#   name        = "ecs-tasks-security-group"
#   description = "allow inbound access from the LB only for EC2 in cluster"
#   vpc_id      = aws_vpc.vpc_main.id

#   ingress {
#     description     = "Allow ingress traffic from ALB on HTTP port 80"
#     protocol        = "tcp"
#     from_port       = var.app_port
#     to_port         = var.app_port
#     security_groups = [aws_security_group.lb-sg.id, aws_security_group.bastion-sg.id]
#   }

#   ingress {
#     description     = "Allow ingress traffic from ALB on HTTP on ephemeral ports"
#     protocol        = "tcp"
#     from_port       = 1024
#     to_port         = 65535
#     security_groups = [aws_security_group.lb-sg.id, aws_security_group.bastion-sg.id]
#   }

#   ingress {
#     description     = "Allow SSH ingress traffic from bastion host"
#     protocol        = "tcp"
#     from_port       = 22
#     to_port         = 22
#     security_groups = [aws_security_group.lb-sg.id, aws_security_group.bastion-sg.id]
#   }

#   ingress {
#     description     = "Allow icmp ingress traffic from bastion host"
#     protocol        = "icmp"
#     from_port       = -1
#     to_port         = -1
#     security_groups = [aws_security_group.lb-sg.id, aws_security_group.bastion-sg.id]
#   }

#   egress {
#     description = "Allow all egress traffic"
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

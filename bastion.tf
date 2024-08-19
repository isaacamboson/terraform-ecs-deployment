# # Bastion AWS instance
# resource "aws_instance" "bastion-host" {
#   count                       = var.stack_controls["ec2_create"] == "Y" ? 2 : 0
#   ami                         = data.aws_ami.stack_ami.id
#   instance_type               = var.EC2_Components["instance_type"]
#   vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
#   key_name                    = "bastion_kp"
#   subnet_id                   = element(aws_subnet.pub_subnets.*.id, count.index)
#   associate_public_ip_address = "true"
#   iam_instance_profile        = "ec2_to_s3_admin"
#   user_data                   = data.template_file.bastion_s3_cp_bootstrap.rendered

#   tags = {
#     Name        = "Bastion"
#     Environment = var.environment
#     OwnerEmail  = var.OwnerEmail
#   }

#   depends_on = [aws_db_instance.clixx_app_db_instance]
# }

# #creating security group for bastion - this allows traffic from 0.0.0.0/0
# resource "aws_security_group" "bastion-sg" {
#   name        = "bastion-sg"
#   description = "Bastion host Security Group"
#   vpc_id      = aws_vpc.vpc_main.id

#   ingress {
#     description = "Allow SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] ## The IP range could be limited to the developers IP addresses if they are fix
#   }

#   ingress {
#     description = "Allow ICMP"
#     from_port   = -1
#     to_port     = -1
#     protocol    = "icmp"
#     cidr_blocks = ["0.0.0.0/0"] ## The IP range could be limited to the developers IP addresses if they are fix
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

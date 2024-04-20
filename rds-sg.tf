#----------------------------------------------------------------------
#creating security group for rds instance
#----------------------------------------------------------------------
resource "aws_security_group" "rds-sg" {
  vpc_id      = aws_vpc.vpc_main.id
  name        = "rds-sg"
  description = "Security Group for rds instance in private subnet"
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_ssh_rds_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.ecs_sg.id
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_ssh_rds_fb_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "ingress" security group rules for http
resource "aws_security_group_rule" "ingress_http_rds_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.ecs_sg.id
}

#declaring "ingress" security group rules for http
resource "aws_security_group_rule" "ingress_http_rds_fb_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_https_rds_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.ecs_sg.id
}

#declaring "ingress" security group rules for ssh
resource "aws_security_group_rule" "ingress_https_rds_fb_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "ingress" security group rules for MySQL
resource "aws_security_group_rule" "ingress_mysql_rds_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.ecs_sg.id
}

#declaring "ingress" security group rules for MySQL
resource "aws_security_group_rule" "ingress_mysql_rds_fb_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "ingress" security group rules for ICMP
resource "aws_security_group_rule" "ingress_icmp_rds_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "icmp"
  from_port                = -1
  to_port                  = -1
  source_security_group_id = aws_security_group.ecs_sg.id
}

#declaring "ingress" security group rules for ICMP
resource "aws_security_group_rule" "ingress_icmp_rds_fb_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "ingress"
  protocol                 = "icmp"
  from_port                = -1
  to_port                  = -1
  source_security_group_id = aws_security_group.bastion-sg.id
}

#declaring "egress" security group rules for ssh
resource "aws_security_group_rule" "egress_allow_all_rds_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "egress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = aws_security_group.ecs_sg.id
}

#declaring "egress" security group rules for ssh
resource "aws_security_group_rule" "egress_allow_all_rds_fb_sg" {
  security_group_id        = aws_security_group.rds-sg.id
  type                     = "egress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = aws_security_group.bastion-sg.id
}
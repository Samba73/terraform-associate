terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.22.0"
    }
  }
}

locals {
    http_port    = 8080
    any_port     = 0
    any_protocol = "-1"
    tcp_protocol = "tcp"
    all_ips      = ["0.0.0.0/0"]
    ssh_port     = 22
}
resource "aws_security_group" "instance_SG" {
  name        = "${var.environ}-SG"
  description = "Security Group for Ubuntu EC2 instance"
}
resource "aws_security_group_rule" "httpinbound" {
  type              = "ingress"
  from_port         = local.http_port
  to_port           = local.http_port
  protocol          = local.tcp_protocol
  cidr_blocks       =  local.all_ips
  security_group_id = aws_security_group.instance_SG.id
}
resource "aws_security_group_rule" "sshinbound" {
  type              = "ingress"
  from_port         = local.ssh_port
  to_port           = local.ssh_port
  protocol          = local.tcp_protocol
  cidr_blocks       =  local.all_ips
  security_group_id = aws_security_group.instance_SG.id
}

resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = local.any_port
  to_port           = local.any_port
  protocol          = local.any_port
  cidr_blocks       =  local.all_ips
  security_group_id = aws_security_group.instance_SG.id
}

data "aws_ami" "ubuntu" {

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20231025"]
  }
}
data "aws_vpc" "vpc" {
  default = true
}
data "aws_subnets" "sn" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

resource "aws_launch_configuration" "ec2_launch" {
  image_id = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  security_groups = [aws_security_group.instance_SG.id]
//}
/*
resource "aws_instance" "EC2_instance" {
  ami           = "ami-03caf91bb3d81b843"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance_SG.id]
*/
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from Terraform" > index.html
              nohup busybox httpd -f -p ${local.http_port} &
              EOF
 // user_data_replace_on_change = true            

 // tags = {
 //   Name = "EC2-Instance"
 // }
 lifecycle {
   create_before_destroy = true
 }
}
resource "aws_autoscaling_group" "ec2-scale" {
  launch_configuration = aws_launch_configuration.ec2_launch.name
  //availability_zones = ["ap-southeast-1a"]
  vpc_zone_identifier = data.aws_subnets.sn.ids
  
  target_group_arns = [aws_lb_target_group.ec2-alb-tg.arn]
  health_check_type = "ELB"

  min_size = var.max_size
  max_size = var.max_size

  tag {
    key = "Name"
    value = "${var.environ}-asg"
    propagate_at_launch = true
  }
}

resource "aws_lb" "ec2-alb" {
  name                = "${var.environ}-alb"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.instance_SG.id]
  subnets             = data.aws_subnets.sn.ids
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ec2-alb.arn
  port = 8080
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ec2-alb-tg.arn
  }
  
}

resource "aws_lb_listener_rule" "http-asg-rule" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }  
  }
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ec2-alb-tg.arn
  }
}

resource "aws_lb_target_group" "ec2-alb-tg" {
  name = "${var.environ}-tg"
  port = local.http_port
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = data.aws_vpc.vpc.id

  health_check {
    path = "/"
    protocol = "HTTP"
    port = local.http_port
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

output "alb_dns_name" {
  value = aws_lb.ec2-alb.dns_name
}
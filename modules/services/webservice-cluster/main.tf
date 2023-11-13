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
              nohup busybox httpd -f -p ${var.port} &
              EOF
 // user_data_replace_on_change = true            

 // tags = {
 //   Name = "EC2-Instance"
 // }
 lifecycle {
   create_before_destroy = true
 }
}

# data "template_file" "user_data" {
#     template = "${file("${path.module}/user-data.sh")}"

#     vars {
#         server_port = var.port

#     }
# }
resource "aws_autoscaling_group" "ec2-scale" {
  launch_configuration = aws_launch_configuration.ec2_launch.name
  //availability_zones = ["ap-southeast-1a"]
  vpc_zone_identifier = data.aws_subnets.sn.ids
  
  target_group_arns = [aws_lb_target_group.ec2-alb-tg.arn]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size

  tag {
    key = "Name"
    value = var.cluster-name
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance_SG" {
  name        = "allow 8080"
  description = "Security Group for Ubuntu EC2 instance"

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      from_port = ingress.value.port
      to_port = ingress.value.port
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = ingress.value.description
    }
  }
 egress  {
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 }
}
data "aws_ami" "ubuntu" {
  //most_recent = true
  //owners = ["802051300684"]
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




resource "aws_lb" "ec2-alb" {
  name                = "ec2-alb-asg"
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
  name = "ec2-alb-tg"
  port = var.port
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = data.aws_vpc.vpc.id

  health_check {
    path = "/"
    protocol = "HTTP"
    port = var.port
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}
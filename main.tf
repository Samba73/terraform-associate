/*
resource "aws_instance" "my-server" {
  ami           = "ami-0556fb70e2e8f34b7"
  instance_type = var.instance_type

  tags = {
    Name    = "my-server-${local.name}"
  }
}
*/
/*
resource "aws_instance" "my-server-2" {
  ami           = "ami-0556fb70e2e8f34b7"
  instance_type = "t2.micro"

  tags = {
    Name    = "my-server-2"
  }
}
*/
/*
module "global" {
  source = "./modules/eu"
    
}
*/
resource "aws_security_group" "instance_SG" {
  name        = "allow 8080"
  description = "Security Group for Ubuntu EC2 instance"

  ingress = [{
    description = "allow 8080 for webserver"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  },
  {
    description = "allow SSH for webserver"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]
 
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
resource "aws_autoscaling_group" "ec2-scale" {
  launch_configuration = aws_launch_configuration.ec2_launch.name
  //availability_zones = ["ap-southeast-1a"]
  vpc_zone_identifier = data.aws_subnets.sn.ids
  min_size = 2
  max_size = 5

  tag {
    key = "Name"
    value = "tf-asg-example"
    propagate_at_launch = true
  }
}
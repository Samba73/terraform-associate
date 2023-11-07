provider "aws" {
  region = "ap-southeast-1"
}
terraform {
    backend "s3"{
        key = "tf-state"
    }
}
resource "aws_security_group" "instance_SG" {
  name        = "allow 8080"
  description = "Security Group for Ubuntu EC2 instance"

  ingress = [{
    description = "allow 8080 for webserver"
    from_port   = 8080
    to_port     = 8080
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
 egress  {
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = ["0.0.0.0/0"]
 }
}
data "terraform_remote_state" "bucket" {
  backend = "s3"

  config = {
    bucket = "tf-backend-samba-07nov2023"
    key = "env:/global/tf-tfstate"
    region = "ap-southeast-1"

  }
}
resource "aws_instance" "my-server-2" {
  ami           = "ami-03caf91bb3d81b843"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance_SG.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from Terraform" > index.html
              echo ${data.terraform_remote_state.bucket.outputs.bucketname} >> index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    Name    = "dev-1"
  }
}
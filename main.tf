terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.22.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

variable "instance_type" {
  type = string
}
locals{
  name = "sk"
}
resource "aws_instance" "my-server" {
  ami           = "ami-0556fb70e2e8f34b7"
  instance_type = var.instance_type

  tags = {
    Name    = "my-server-${local.name}"
  }
}
/*
resource "aws_instance" "my-server-2" {
  ami           = "ami-0556fb70e2e8f34b7"
  instance_type = "t2.micro"

  tags = {
    Name    = "my-server-2"
  }
}
*/

output "instance_ip_addr" {
  value = aws_instance.my-server.public_ip
}
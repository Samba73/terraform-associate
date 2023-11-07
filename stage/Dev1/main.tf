provider "aws" {
  region = "ap-southeast-1"
}
terraform {
    backend "s3"{
        key = "tf-state"
    }
}

resource "aws_instance" "my-server-2" {
  ami           = "ami-0556fb70e2e8f34b7"
  instance_type = "t2.micro"

  tags = {
    Name    = "dev-1"
  }
}
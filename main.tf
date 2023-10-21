resource "aws_instance" "my-server" {
  ami           = "ami-0556fb70e2e8f34b7"
  instance_type = var.instance_type

   provisioner "local-exec" {
    command = "echo The servers IP address is ${self.private_ip}"
  }
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
/*
module "global" {
  source = "./modules/eu"
    
}
*/
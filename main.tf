# resource "aws_instance" "my-server" {
#   ami           = "ami-0556fb70e2e8f34b7"
#   instance_type = var.instance_type

#   tags = {
#     Name    = "my-server-${local.name}"
#   }
# }
/*
resource "aws_instance" "my-server-2" {
  ami           = "ami-0556fb70e2e8f34b7"
  instance_type = "t2.micro"

  tags = {
    Name    = "my-server-2"
  }
}
*/
# module "webserver-cluster" {
#   source = "./modules/services/webservice-cluster"

#   instance_type = var.instance_type
#   port = var.port  
# }

# resource "aws_iam_user" "users" {
#   #count = 3
#   #name = "user${count.index}"
#   #count = length(var.users)
#   #name  = var.users[count.index]

#   # for_each = var.users
#   # name = each.value
#   # tags = {
#   #   Name = each.key
#   # }
# }
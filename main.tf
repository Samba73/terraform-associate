data "aws_iam_policy_document" "assume-role"{
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "instance" {
  name = "instance_role"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}
data "aws_iam_policy_document" "permission_policy"{
  statement {
    effect = "Allow"
    actions = ["ec2:*"]
    resources = ["*"]
  }
}
resource "aws_iam_role_policy" "instance_role" {
  role = aws_iam_role.instance.id
  policy = data.aws_iam_policy_document.permission_policy.json
}
resource "aws_iam_instance_profile" "instance_profile" {
  role = aws_iam_role.instance.name
}
resource "aws_instance" "my-server" {
  ami           = "ami-0556fb70e2e8f34b7"
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
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
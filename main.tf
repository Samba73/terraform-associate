/*
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
data "aws_caller_identity" "self" {}
/*
data "aws_iam_policy_document" "cmk_admin_policy" {
  statement {
    effect = "Allow"
    actions = ["kms:*"]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [data.aws_caller_identity.self.arn]
    }
  }
} 

resource "aws_kms_key" "cmk" {
  policy = data.aws_iam_policy_document.cmk_admin_policy.json
}

resource "aws_kms_alias" "cmk" {
  name = "alias/kms-cmk-2"
  target_key_id = aws_kms_key.cmk.id
}


data "aws_kms_secrets" "creds" {
  secret {
    name = "test"
    payload = file("${path.module}/creds.yml.encrypted")
    key_id = aws_kms_alias.cmk.target_key_id
  }
  
}
locals {
  creds = yamldecode(data.aws_kms_secrets.creds.plaintext["test"])
}

output "username" {
  value = local.creds.username
  sensitive = true
}
output "password" {
  value = local.creds.password
  sensitive = true
}
*/
/*
data "aws_secretsmanager_secret" "creds" {
  name = "creds"
}
data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.creds.id
}
locals {
  creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
}

output "username" {
  value = local.creds.username
  sensitive = true
}
output "password" {
  value = local.creds.password
  sensitive = true
  
}
*/

data "aws_caller_identity" "parent" {
  provider = aws.parent
}

data "aws_caller_identity" "child" {
  provider = aws.child
}
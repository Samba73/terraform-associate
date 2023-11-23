terraform {
  # cloud {
  #   organization = "terraform-associate-samba07"

  #   workspaces {
  #     name = "certification"
  #   }
  # } 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.22.0"
    }
  }
}

# provider "aws" {
#   region = "ap-southeast-1"
# }
provider "aws" {
  region = "ap-southeast-1"
  alias = "parent"
  
}
provider "aws" {
  region = "ap-southeast-1"
  alias = "child"

  assume_role {
    role_arn = "arn:aws:iam::515401293737:role/OrganizationAccountAccessRole"
  }
}
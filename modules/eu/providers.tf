terraform {
  /*
  cloud {
    organization = "terraform-associate-samba07"

    workspaces {
      name = "certification"
    }
  }   
  */
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.22.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  alias  = "eu"
}
terraform {
 # backend "local" {}
   backend "s3" {
    bucket = "samba07-tf-statefile-25oct"
    key = "statefile/terraform.tfstate"
    region = "ap-southeast-1"
  }
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
  region = "ap-southeast-1"
}

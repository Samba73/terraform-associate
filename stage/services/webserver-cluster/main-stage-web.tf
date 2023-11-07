terraform {
  backend "s3" {
    key = "stage/terraform-tfstate"

  }
}

provider "aws" {
    region = "ap-southeast-1"
}

module "webserver" {
  source = "github.com/Samba73/terraform-associate//services/webserver-cluster?ref=0.2.1"

  environ       = var.environ
  instance_type = var.instance_type
  min_size      = var.min_size
  max_size      = var.max_size
  
}
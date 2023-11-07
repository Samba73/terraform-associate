terraform {
  backend "s3" {
    key = "stage/terraform-tfstate"

  }
}

provider "aws" {
    region = "ap-southeast-1"
}

module "webserver" {
  source = "/workspace/terraform-associate/modules/services/webserver-cluster"

  environ       = var.environ
  instance_type = var.instance_type
  min_size      = var.min_size
  max_sixe      = var.max_size
  
}
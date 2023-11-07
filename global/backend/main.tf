terraform {
  backend "s3" {
    key = "global/tf-tfstate"

  }
}

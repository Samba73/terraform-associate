module "primary" {
    source = "/workspace/terraform-associate/modules/data-store/mysql"

    providers = {
      aws = aws.primary
    }
    db_name = "primary_db"
    user_name = var.user_name
    password = var.password

    retention_period = 1


}

module "replica" {
  source = "/workspace/terraform-associate/modules/data-store/mysql"

  providers = {
    aws = aws.replica
  }

  replicate_sourc_db = module.primary.db_arn
}
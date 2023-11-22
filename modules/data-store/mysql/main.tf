resource "aws_db_instance" "mysql" {
   identifier_prefix = "terraform-associate"
   allocated_storage = 10
   instance_class = "db.t2.micro"
   skip_final_snapshot = true

   backup_retention_period = var.retention_period

   replicate_source_db = var.replicate_sourc_db

   engine = var.replicate_sourc_db == null ? "mysql" : null
   db_name = var.replicate_sourc_db == null ? var.db_name : null
   username = var.replicate_sourc_db == null ? var.user_name : null
   password = var.replicate_sourc_db == null ? var.password : null
}
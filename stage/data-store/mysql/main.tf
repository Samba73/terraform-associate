resource "aws_db_instance" "mysql" {
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t2.micro"
    db_name = "mysqlstage"
    username = var.user_name
    password = var.password
    skip_final_snapshot = true
}
/*
output "instance_ip_addr" {
  value = aws_instance.EC2_instance.public_ip
}
*/
output "all_users" {
  value = "%{ for i, user in var.users_list }(${i})${user},%{ endfor }"
}
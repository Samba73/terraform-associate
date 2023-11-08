# output "instance_ip_addr" {
#   value = aws_instance.my-server.public_ip
# }
# output "users" {
#   value = aws_iam_user.users[*].name
# }
output "all_users" {
  value = values(aws_iam_user.users)[*].name
}

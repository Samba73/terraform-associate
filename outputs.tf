# output "instance_ip_addr" {
#   value = aws_instance.my-server.public_ip
# }
# output "lb_dns" {
#   value = module.webserver-cluster.alb_dns_name
# }
output "all_users" {
  #value = values(aws_iam_user.users)[*].name
  value = <<EOF
        %{~ for i, user in var.users ~}
        ${user}%{ if i < length(var.users) -1 }, %{ else }. %{ endif }
        %{~ endfor ~}
        EOF
}
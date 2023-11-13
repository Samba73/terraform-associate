# output "instance_ip_addr" {
#   value = aws_instance.my-server.public_ip
# }
output "lb_dns" {
  value = module.webserver-cluster.alb_dns_name
}

output "alb-dns-name" {
  value = aws_lb.ec2-alb.dns_name
}
output "security_group_id" {
  value = aws_security_group.instance_SG.id
}
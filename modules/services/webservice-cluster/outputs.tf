output "alb_dns_name" {
  value = aws_lb.ec2-alb.dns_name
}
output "instance_SG_id" {
  value = aws_security_group.instance_SG.id
}
output "asg_name" {
  value = aws_autoscaling_group.ec2-scale.name
}
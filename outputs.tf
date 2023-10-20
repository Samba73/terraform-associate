output "instance_ip_addr" {
  value = aws_instance.my-server.public_ip
}
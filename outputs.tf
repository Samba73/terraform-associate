/*
output "public_ip" {
  value = aws_instance.my-server.public_ip
}
*/
output "module1-publicIP" {
  value = module.mod1.mod1-publicIP
}
output "module2-publicIP" {
  value = module.mod2.mod2-publicIP
}
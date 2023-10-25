variable "instance_type" {
  type = string
}
locals {
  ingress_rules =[{
    port = 80
    description = "Port 80 for app server"
  },
  {
    port = 22
    description ="Port 22 for SSH"
  }]
}
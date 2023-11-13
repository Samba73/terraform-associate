variable "instance_type" {
  type = string
}
locals{
  name = "sk"
}
variable "port" {
  type = string
  default = "8080"
}
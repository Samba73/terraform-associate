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
variable "users" {
  type = list(string)
  default = ["Sam", "Pam", "Tam"]
}
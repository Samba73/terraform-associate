variable "instance_type" {
  type = string
}
locals{
  name = "sk"
}
variable "users" {
  type = list(string)
  default = [ "user1", "user2", "user3" ]
}
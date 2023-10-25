variable "instance_type" {
  type = string
}
locals {
  name = "sk"
}
variable "users_list" {
  description = "IAM users"
  type = list(string)
  default = [ "user1", "user2", "user3" ]
  
}
/*locals {
  keys = keys(var.users_list)
}
*/
variable "tfstatebucket" {
  type = string
}
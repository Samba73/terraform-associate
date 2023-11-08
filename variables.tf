variable "instance_type" {
  type = string
}
locals{
  name = "sk"
}
variable "users" {
  type = map(string)
  default = {
    "user1": "Sam",
    "user2": "Pam",
    "user3": "Tam"
  }
}
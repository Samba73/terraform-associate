variable "db_name" {
  type = string
  default = null
}
variable "user_name" {
  type = string
  sensitive = true
  default = null
}
variable "password" {
  type = string
  sensitive = true
  default = null
}
variable "retention_period" {
  type = number
  default = null
}
variable "replicate_sourc_db" {
  type = string
  default = null
}




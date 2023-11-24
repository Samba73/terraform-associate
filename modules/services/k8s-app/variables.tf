variable "name" {
  type = string
}
variable "image" {
  type = string
}
variable "container_port" {
  type = number
}
variable "replicas" {
  type = number
}
variable "env_variables" {
  type = map(string)
  default = {}
}
locals {
    pod_lables = {
        app = var.name
    }
}
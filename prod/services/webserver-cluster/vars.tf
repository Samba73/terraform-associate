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
variable "min_size" {
  type = number
}
variable "max_size" {
  type = number
}
variable "cluster-name" {
  type = string
}
variable "enable_autoschedule" {
  type = bool
  description = "send boolean value to enable ASG schedule"
}
variable "server_text" {
  type = string
}
variable "port" {
  type = string
}
variable "instance_type" {
  type = string
}

locals  {
    ingress_rules = [{
        port = 8080
        description = "port for webserver"
        protocol = "tcp"
    },
    {
        port = 22
        description = "port for ssh"
        protocol = "tcp"
    }
    ]
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
}
variable "server_text" {
  type = string
}
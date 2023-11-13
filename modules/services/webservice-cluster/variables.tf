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
    },
    {
        port = 22
        description = "port for ssh"
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
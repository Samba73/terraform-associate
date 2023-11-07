variable "instance_type" {
    type            = string
    description     = "instance type for the EC2"
  
}
variable "environ" {
  type          = string
  description   = "environment in which the infrastructure is deployed"
}
variable "min_size" {
  type          = number
  description   = "Min number of EC2 in ASG"  
}
variable "max_size" {
  type          = number
  description   = "Max number of EC2 in ASG"  
}
module "webserver-cluster" {
  source = "../../../modules/services/webservice-cluster"

  instance_type = var.instance_type
  port = var.port  
  min_size = var.min_size
  max_size = var.max_size
  cluster-name = "cluster-stage"
}

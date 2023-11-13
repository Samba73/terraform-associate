module "webserver-cluster" {
  source = "../../../modules/services/webservice-cluster"

  instance_type = var.instance_type
  port = var.port  
  min_size = var.min_size
  max_size = var.max_size
  cluster-name = "cluster-stage"
  enable_autoschedule = false
  server_text = var.server_text
}

resource "aws_security_group_rule" "ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.webserver-cluster.instance_SG_id
}

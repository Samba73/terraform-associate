module "eks_cluster" {
  source = "/workspace/terraform-associate/modules/services/eks_cluster"

  cluster_name = var.cluster_name

  min_size = 1
  max_size = 2
  desired_size = 1
  instance_types = ["t3.small"]
}



module "simple_webapp" {
  source = "/workspace/terraform-associate/modules/services/k8s-app"

  name = var.app_name
  image = "training/webapp"
  replicas = 2
  container_port = 5000
  env_variables =  {
    PROVIDER = "K8s in EKS"
  }
  depends_on = [ module.eks_cluster ]
}
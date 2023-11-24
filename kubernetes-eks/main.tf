module "eks_cluster" {
  source = "/workspace/terraform-associate/modules/eks_cluster"

  name = "cluster-eks"
  min_size = 1
  max_sixe = 2
  desired_size = 1
  instance_type = ["t3.small"]
}
terraform {
  required_providers {
    kubernetes = {
        source = "hashicorp/kubernetes"
        version = "2.23.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.22.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_eks_cluster_auth" "cluster_auth" {
    name = module.eks_cluster.cluster_name
}
provider "kubernetes" {
    host = module.eks_cluster.cluster_ep
    cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority[0].data)
    token = data.aws_eks_cluster_auth.cluster_auth.token
}
data "aws_eks_cluster_auth" "cluster_auth" {
    name = module.eks_cluster.cluster_name
}
provider "kubernetes" {
    host = module.eks_cluster.cluster_ep
    cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority[0].data)
    token = data.aws_eks_cluster_auth.cluster_auth.token
}
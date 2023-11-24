output "cluster_ep" {
    value = module.eks_cluster.cluster_ep
}
output "service_ep" {
  value = module.simple_webapp.service_ep
}
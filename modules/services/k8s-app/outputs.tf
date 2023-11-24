locals {
    status = kubernetes_service.webapp.status
}
output "service_ep" {
  value = try(
    "http://${local.status[0]["load_balancer"][0]["ingress"][0]["hostname"]}","(error parsing hostname from status)"
  )
}
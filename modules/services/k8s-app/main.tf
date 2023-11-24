# K8s deployment
resource "kubernetes_deployment" "webapp" {
    metadata {
        name = var.name
    }
    spec {
        replicas = 2
        selector {
            match_labels = local.pod_lables
        }
    
        template {
            metadata {
                labels = local.pod_lables
            }
            spec {
                container {
                    name = var.name
                    image = var.image
                    port {
                        container_port = var.container_port
                    }
                    dynamic "env" {
                        for_each = var.env_variables
                        content {
                            name = env.key
                            value = env.value
                        }
                    }
                }
            }
        }
    }
}
# K8s Service
resource "kubernetes_service" "webapp" {
  metadata {
    name = var.name
  }
  spec {
    type = "LoadBalancer"
    selector = local.pod_lables
    port {
        port = 80
        target_port = var.container_port
        protocol = "TCP"
    }
  }
}
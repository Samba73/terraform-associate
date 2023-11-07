output "stage-alb-dns" {
  value = module.webserver.alb_dns_name
}
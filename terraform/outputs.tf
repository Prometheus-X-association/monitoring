output "monitoring_service_ip" {
  value = kubernetes_service.monitoring.status[0].load_balancer[0].ingress[0].ip
}

output "monitoring_namespace" {
  value = kubernetes_namespace.monitoring.metadata[0].name
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_secret" "env_vars" {
  metadata {
    name      = "env-vars"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    PROM_PORT                         = base64encode("9090")
    ALERT_PORT                        = base64encode("9093")
    GRAFANA_PORT                      = base64encode("3006")
    GRAFANA_ADMIN_USER                = base64encode("admin")
    GRAFANA_ADMIN_PWD                 = base64encode("test")
    CONSENT_MANAGER                   = base64encode("monitoring:8887")
    CONTRACT_MANAGER                  = base64encode("contract-manager:8888")
    CATALOG                           = base64encode("catalog-api:4040")
    CATALOG_REGISTRY                  = base64encode("catalog-registry:3000")
  }
}

resource "kubernetes_deployment" "monitoring" {
  metadata {
    name      = "monitoring"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "monitoring"
      }
    }

    template {
      metadata {
        labels = {
          app = "monitoring"
        }
      }

      spec {
        container {
          image = "grafana/loki:master"
          name  = "loki"

          port {
            container_port = 3100
          }
        }

        container {
          image = "grafana/promtail:master"
          name  = "promtail"

          port {
            container_port = 9080
          }
        }

        container {
          image = "google/cadvisor:v0.33.0"
          name  = "cadvisor"

          port {
            container_port = 8080
          }
        }

        container {
          image = "prom/prometheus:latest"
          name  = "prometheus"

          port {
            container_port = 9090
          }

          env {
            name  = "PROM_PORT"
            value = var.prom_port
          }
        }

        container {
          image = "prom/alertmanager:latest"
          name  = "alert-manager"

          port {
            container_port = 9093
          }

          env {
            name  = "ALERT_PORT"
            value = var.prom_port
          }
        }

        container {
          image = "grafana/grafana:6.0.0"
          name  = "grafana"

          port {
            container_port = 3000
          }

          env {
            name  = "GF_SECURITY_ADMIN_USER"
            value = var.grafana_admin_user
          }

          env {
            name  = "GF_SECURITY_ADMIN_PASSWORD"
            value = var.grafana_admin_pwd
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "loki" {
  metadata {
    name      = "loki"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    selector = {
      app = "loki"
    }

    port {
      port        = 3100
      target_port = 3100
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "promtail" {
  metadata {
    name      = "promtail"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    selector = {
      app = "promtail"
    }

    port {
      port        = 9080
      target_port = 9080
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "cadvisor" {
  metadata {
    name      = "cadvisor"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    selector = {
      app = "cadvisor"
    }

    port {
      port        = 8080
      target_port = 8080
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    selector = {
      app = "prometheus"
    }

    port {
      port        = 9090
      target_port = 9090
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    selector = {
      app = "grafana"
    }

    port {
      port        = 3000
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}
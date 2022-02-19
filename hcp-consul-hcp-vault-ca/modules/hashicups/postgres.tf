resource "kubernetes_service" "postgres" {
  metadata {
    name = "postgres"
    labels = {
      app = "postgres"
    }
  }
  spec {
    type = "ClusterIP"
    port {
      port = 5432
      target_port = 5432
    }
    selector = {
      app = "postgres"
    }
  }
}

resource "kubernetes_manifest" "service_defaults" {

  manifest = {
    apiVersion = "consul.hashicorp.com/v1alpha1"
    kind = "ServiceDefaults"
    metadata = {
      name = "postgres"
    }
    spec = {
      protocol = "tcp"
    }
  }
}

resource "kubernetes_service_account" "postgres" {
  metadata {
    name = "postgres"
  }
  automount_service_account_token = true
}

resource "kubernetes_deployment" "postgres_deployment" {
  metadata {
    name = "postgres"
  }
  spec {
    replicas = "1"
    selector {
      match_labels = {
        service = "postgres"
        app = "postgres"
      }
    }
    template {
      metadata {
        labels = {
          service = "postgres"
          app = "postgrs"
        }
        annotations = {
          prometheus.io/scrape = 'true'
          prometheus.io/port = '9102'
          consul.hashicorp.com/connect-inject = 'true'
        }
      }
      spec {
        service_account_name = "postgres"
        container {
          name = "postgres"
          image = "hashicorpdemoapp/product-api-db:v0.0.13"

        }
      }
    }
  }
}

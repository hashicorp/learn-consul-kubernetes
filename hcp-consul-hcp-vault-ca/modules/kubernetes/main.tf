:w
resource "kubernetes_deployment" "workingEnvironment" {
  metadata {
    name = var.tutorial_name
    labels = {
      app = var.tutorial_name
    }
  }
  spec {
    replicas = var.pod_replicas
    selector {
      match_labels = {
        app = var.tutorial_name
      }
    }
    template {
      metadata {
        name = var.tutorial_name
        labels = {
          app = var.tutorial_name
        }
      }
      spec {
        volume {
          name = var.startup_script_options.volume_name
          config_map {
            name = var.startup_script_options.config_map_name
            default_mode = var.startup_script_options.file_permissions
          }
        }
        volume {
          name = var.kubeconfig_cm.volume_name
          config_map {
            name = var.kubeconfig_cm.config_map_name
            default_mode = var.kubeconfig_cm.file_permissions
          }
        }
        container {
          env {
            name = "CONSUL_CA"
            value = var.consul_ca
          }
          env {
            name = "CONSUL_HTTP_TOKEN"
            value = var.consul_http_token
          }
          env {
            name = "CONSUL_CONFIG"
            value = var.consul_config
          }
          env {
            name = "CONSUL_HTTP_ADDR"
            value = var.consul_http_addr
          }
          env {
            name = "CONSUL_K8S_API_AWS"
            value = var.consul_k8s_api_aws
          }
          env {
            name = "CONSUL_ACCESSOR_ID"
            value = var.consul_accessor_id
          }
          env {
            name = "CONSUL_SECRET_ID"
            value = var.consul_secret_id
          }
          env {
            name = "VAULT_TOKEN"
            value = var.vault_token
          }
          env {
            name = "VAULT_ADDR"
            value = var.vault_addr
          }
          env {
            name = "VAULT_NAMESPACE"
            value = var.vault_namespace
          }
          name = var.tutorial_name
          image = var.versions.amazonlinux
          volume_mount {
            mount_path = var.startup_script_options.mount_path
            name       = var.startup_script_options.volume_name
          }
          volume_mount {
            mount_path = var.kubeconfig_cm.mount_path
            name       = var.kubeconfig_cm.volume_name
          }
          command = ["/startup/startup.sh"]
        }
      }
    }
  }
  depends_on = [kubernetes_config_map.startup_script, kubernetes_config_map.kubeconfig]
}


resource "kubernetes_config_map" "startup_script" {
  metadata {
    name = var.startup_script_options.config_map_name
  }
  data = {
    (var.startup_script_options.config_map_file_name) = templatefile("${path.module}/${var.startup_script_options.template_file_name}", {

      kubectl_version = var.versions.kubectl_version
      helm_version = var.versions.helm_version
      consul_version = var.versions.consul_version
      consul_k8s_version = var.versions.consul_k8s_version
    })
  }
}

resource "kubernetes_config_map" "kubeconfig" {
  metadata {
    name = var.kubeconfig_cm.config_map_name
  }
  data = {
    (var.kubeconfig_cm.config_map_filename) = var.kubeconfig
    }
}
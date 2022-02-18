resource "kubernetes_config_map" "environment_variables" {
  metadata {
    name = var.environment_variables_file.config_map_name
  }
  data = {
    (var.environment_variables_file.config_map_file_name) = templatefile("${path.module}/${var.environment_variables_file.template_file_name}", {
      consul_ca = var.consul_ca
      consul_http_token = var.consul_http_token
      consul_config = var.consul_config
      consul_http_addr = var.consul_http_addr
      consul_k8s_api_aws = var.consul_k8s_api_aws
      consul_accessor_id = var.consul_accessor_id
      consul_secret_id = var.consul_secret_id
      vault_addr = var.vault_addr
      vault_token = var.vault_token
      vault_namespace = var.vault_namespace
    })
  }
  depends_on = [kubernetes_config_map.startup_script]
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
          name = var.environment_variables_file.volume_name
          config_map {
            name = var.environment_variables_file.config_map_name
            default_mode = var.environment_variables_file.file_permissions
          }
        }
        container {
          name = var.tutorial_name
          image = var.versions.amazonlinux
          volume_mount {
            mount_path = var.startup_script_options.mount_path
            name       = var.startup_script_options.volume_name
          }
          volume_mount {
            mount_path = var.environment_variables_file.mount_path
            name       = var.environment_variables_file.volume_name
          }
          command = ["/startup/startup.sh", "&&", "source /environment/envVars.sh"]
        }
      }
    }
  }
}
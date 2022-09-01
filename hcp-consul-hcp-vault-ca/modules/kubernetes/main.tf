# ConfigMap for the Pod's startup script
resource "kubernetes_config_map" "startup_script" {
  metadata {
    name = var.startup_script_options.config_map_name
  }
  data = {
    (var.startup_script_options.config_map_file_name) = templatefile("${path.module}/${var.startup_script_options.template_file_name}", {

      kubectl_version    = var.versions.kubectl_version
      helm_version       = var.versions.helm_version
      consul_version     = var.versions.consul_version
      consul_k8s_version = var.versions.consul_k8s_version
      yq_version         = var.versions.yq_version
      aws_region         = var.cluster_region
      cluster_name       = var.cluster_name
    })
  }
}

# AWS Credentials file that uses IAM Role and references the profile created below.
resource "kubernetes_config_map" "aws_cred_profile" {
  metadata {
    name = var.aws_creds_options.config_map_name
  }
  data = {
    (var.aws_creds_options.config_map_filename) = templatefile("${path.module}/${var.aws_creds_options.template_file_name}", {
      profile_name = var.profile_name
      role_arn     = var.role_arn
    })
  }
}

# ConfigMap for aws Config file with profile definition
resource "kubernetes_config_map" "aws_profile_config" {
  metadata {
    name = var.aws_profile_config_options.config_map_name
  }
  data = {
    (var.aws_profile_config_options.config_map_filename) = templatefile("${path.module}/${var.aws_profile_config_options.template_file_name}", {
      profile_name = var.profile_name
      region       = var.cluster_region
    })
  }
}

resource "kubernetes_config_map" "consul_values" {
  metadata {
    name = "consul-values.yaml"
  }
  data = {
    "consul-values.yaml" = templatefile("${path.module}/template_scripts/consul-values.tftpl", {
      vault_addr = var.vault_addr
      hcp_consul_addr = var.consul_http_addr
      kube_control_plane = var.consul_k8s_api_aws
    })
  }
}

# Create a service account for this pod
resource "kubernetes_service_account" "tutorial" {
  metadata {
    name = var.cluster_service_account_name
    annotations = {
      "eks.amazonaws.com/role-arn" = var.role_arn
    }
  }
}

# Create a cluster role binding for the service account
resource "kubernetes_cluster_role_binding" "tutorial" {
  metadata {
    name = var.cluster_service_account_name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"

  }
  subject {
    kind      = "ServiceAccount"
    name      = var.cluster_service_account_name
    namespace = "kube-system"
  }
  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind = "Group"
    name = "system:authenticated"
  }
}

# Deploy the pod
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
        annotations = {
          "consul.hashicorp.com/connect-inject"  = true
          "consul.hashicorp.com/connect-service" = "tutorial"
          "eks.amazonaws.com/role-arn"           = var.role_arn
        }
      }

      spec {
        service_account_name            = var.cluster_service_account_name
        automount_service_account_token = true
        volume {
          name = var.startup_script_options.volume_name
          config_map {
            name         = var.startup_script_options.config_map_name
            default_mode = var.startup_script_options.file_permissions
          }
        }
        volume {
          name = var.aws_creds_options.volume_name
          config_map {
            name         = var.aws_creds_options.config_map_name
            default_mode = var.aws_creds_options.file_permissions
          }
        }
        volume {
          name = "consul-values"
          config_map {
            name         = "consul-values.yaml"
            default_mode = "0755"
          }
        }
        volume {
          name = var.aws_profile_config_options.volume_name
          config_map {
            name         = var.aws_profile_config_options.config_map_name
            default_mode = var.aws_profile_config_options.file_permissions
          }
        }
        container {
          port {
            container_port = 8080
          }
          env {
            name  = "CONSUL_CA"
            value = var.consul_ca
          }
          env {
            name  = "CONSUL_HTTP_TOKEN"
            value = var.consul_http_token
          }
          env {
            name  = "CONSUL_CONFIG"
            value = var.consul_config
          }
          env {
            name  = "CONSUL_HTTP_ADDR"
            value = var.consul_http_addr
          }
          env {
            name  = "CONSUL_K8S_API_AWS"
            value = var.consul_k8s_api_aws
          }
          env {
            name  = "CONSUL_ACCESSOR_ID"
            value = var.consul_accessor_id
          }
          env {
            name  = "CONSUL_SECRET_ID"
            value = var.consul_secret_id
          }
          env {
            name  = "VAULT_TOKEN"
            value = var.vault_token
          }
          env {
            name  = "VAULT_ADDR"
            value = var.vault_addr
          }
          env {
            name  = "VAULT_NAMESPACE"
            value = var.vault_namespace
          }
          env {
            name  = "AWS_PROFILE"
            value = var.profile_name
          }
          name  = var.tutorial_name
          image = var.versions.amazonlinux
          volume_mount {
            mount_path = var.startup_script_options.mount_path
            name       = var.startup_script_options.volume_name
          }
          volume_mount {
            mount_path = var.aws_creds_options.mount_path
            name       = var.aws_creds_options.volume_name
            sub_path   = var.aws_creds_options.config_map_filename
            read_only  = true
          }
          volume_mount {
            mount_path = "/root/consul-values.yaml"
            name       = "consul-values"
            sub_path   = "consul-values.yaml"
            read_only  = false
          }
          volume_mount {
            mount_path = var.aws_profile_config_options.mount_path
            name       = var.aws_profile_config_options.volume_name
            sub_path   = var.aws_profile_config_options.config_map_filename
            read_only  = true
          }
          command = [var.startup_script_options.startup_command]
        }
      }
    }
  }
  depends_on = [kubernetes_config_map.startup_script, kubernetes_config_map.aws_cred_profile, kubernetes_config_map.aws_profile_config]
}

# Render the IAM role file partial to add to the aws-auth configmap
resource "local_file" "add_iam_role" {
  content = templatefile("${path.module}/template_scripts/aws-auth.yaml.tftpl", {
    role_arn                = var.role_arn
    cluster_service_account = var.cluster_service_account_name
  })
  filename = "./aws_auth.yaml"
}

# Add the IAM role to the aws-auth configmap
resource "null_resource" "add_iam_role" {

  provisioner "local-exec" {
    command = "bash ${path.module}/template_scripts/add_iam_role.sh"
  }
  depends_on = [local_file.add_iam_role]

}

# Upload the hashicups planfiles to a configmap, so the reader doesn't have to do this step.
resource "null_resource" "hashicups_to_cm" {
  provisioner "local-exec" {
    command = "kubectl create configmap hashicups --from-file=${path.module}/../../hashicups -o yaml"
  }
}

# The pod is immediately available, but not all tools are initialized. This gives the terraform project some time
# to let the pod startup finish.
resource "null_resource" "wait_for_pod" {
  provisioner "local-exec" {
    command = "bash ${path.module}/template_scripts/wait.sh"
  }
}
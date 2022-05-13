locals {
  #template_path            = "${path.module}/template_scripts"
#  iam_role_template_path   = "${path.module}/tem/aws-auth.yaml.tftpl"
#  pod_wait_str             = "bash ${local.template_path}/wait.sh"
#  add_iam_role_command_str = "bash ${local.template_path}/add_iam_role.sh"
  #iam_role_output_filename =  "./aws-auth.yaml"
  hashicups_config_map_str = "kubectl create configmap hashicups --from-file=${path.module}/../../hashicups -o yaml"
  add_iam_role_command_str = "bash ${path.module}/template_scripts/add_iam_role.sh"
  pod_wait_str = "bash ${path.module}/template_scripts/wait.sh"
  iam_role_template_path = "${path.module}/template_scripts/aws-auth.yaml.tftpl"
}


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
    api_group = var.kubernetes_cluster_role_binding.api_group#"rbac.authorization.k8s.io"
    kind      = var.kubernetes_cluster_role_binding.kind #"ClusterRole"
    name      = var.kubernetes_cluster_role_binding.name#"cluster-admin"

  }
  subject {
    kind      = var.kubernetes_cluster_role_binding.subjects.service_account.name#"ServiceAccount"
    name      = var.cluster_service_account_name
    namespace = var.kubernetes_cluster_role_binding.subjects.service_account.namespace#"kube-system"
  }
  subject {
    kind      = var.kubernetes_cluster_role_binding.subjects.groups.masters.kind#"Group"
    name      = var.kubernetes_cluster_role_binding.subjects.groups.masters.name#"system:masters"
    api_group = var.kubernetes_cluster_role_binding.api_group#"rbac.authorization.k8s.io"
  }
  subject {
    kind = var.kubernetes_cluster_role_binding.subjects.groups.authenticated.kind#"Group"
    name = var.kubernetes_cluster_role_binding.subjects.groups.authenticated.name#"system:authenticated"
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
          "consul.hashicorp.com/connect-inject"  = var.enable_connect_inject #true
          "consul.hashicorp.com/connect-service" = var.tutorial_name #"tutorial"
          "eks.amazonaws.com/role-arn"           = var.role_arn
        }
      }

      spec {
        service_account_name            = var.cluster_service_account_name
        automount_service_account_token = var.automount_service_account_token #true
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
          name = var.aws_profile_config_options.volume_name
          config_map {
            name         = var.aws_profile_config_options.config_map_name
            default_mode = var.aws_profile_config_options.file_permissions
          }
        }
        container {
          port {
            container_port = var.workbench_container_port #8080
          }
          env {
            name  = var.environment_variable_names.consul_ca #"CONSUL_CA"
            value = var.consul_ca
          }
          env {
            name  = var.environment_variable_names.consul_http_token #CONSUL_HTTP_TOKEN"
            value = var.consul_http_token
          }
          env {
            name  = var.environment_variable_names.consul_config #"CONSUL_CONFIG"
            value = var.consul_config
          }
          env {
            name  = var.environment_variable_names.consul_http_addr#"CONSUL_HTTP_ADDR"
            value = var.consul_http_addr
          }
          env {
            name  = var.environment_variable_names.consul_k8s_api#"CONSUL_K8S_API_AWS"
            value = var.consul_k8s_api_aws
          }
          env {
            name  = var.environment_variable_names.consul_accessor_id #"CONSUL_ACCESSOR_ID"
            value = var.consul_accessor_id
          }
          env {
            name  = var.environment_variable_names.consul_secret_id #"CONSUL_SECRET_ID"
            value = var.consul_secret_id
          }
          env {
            name  = var.environment_variable_names.vault_token #"VAULT_TOKEN"
            value = var.vault_token
          }
          env {
            name  = var.environment_variable_names.vault_addr #"VAULT_ADDR"
            value = var.vault_addr
          }
          env {
            name  = var.environment_variable_names.vault_namespace#"VAULT_NAMESPACE"
            value = var.vault_namespace
          }
          env {
            name  = var.environment_variable_names.aws_profile #"AWS_PROFILE"
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
            read_only  = var.volume_read_only
          }
          volume_mount {
            mount_path = var.aws_profile_config_options.mount_path
            name       = var.aws_profile_config_options.volume_name
            sub_path   = var.aws_profile_config_options.config_map_filename
            read_only  = var.volume_read_only
          }
          command = [var.startup_script_options.startup_command]
        }
      }
    }
  }
  depends_on = [kubernetes_config_map.startup_script, kubernetes_config_map.aws_cred_profile, kubernetes_config_map.aws_profile_config]
}

# Render the IAM role-file partial to add to the aws-auth configmap
resource "local_file" "add_iam_role" {
    content = templatefile(local.iam_role_template_path, {
    #content = templatefile("${path.module}/template_scripts/aws-auth.yaml.tftpl", {
    role_arn                = var.role_arn
    cluster_service_account = var.cluster_service_account_name
  })
  # Keep the string value of filename here. If set to variable, terraform seems to lose track of where the module is
  # invoked, causing downstream resources to not find this file.
  filename = "./aws_auth.yaml"
}


# Add the IAM role to the aws-auth configmap
resource "null_resource" "add_iam_role" {

  provisioner "local-exec" {
    command = local.add_iam_role_command_str #"bash ${path.module}/template_scripts/add_iam_role.sh"
  }
  depends_on = [local_file.add_iam_role]

}

# Upload the hashicups planfiles to a configmap, so the reader doesn't have to do this step.
resource "null_resource" "hashicups_to_cm" {
  provisioner "local-exec" {
    command = local.hashicups_config_map_str #"kubectl create configmap hashicups --from-file=${path.module}/../../hashicups -o yaml"
  }
}

# The pod is immediately available, but not all tools are initialized. This gives the terraform project some time
# to let the pod startup finish.
resource "null_resource" "wait_for_pod" {
  provisioner "local-exec" {
    command = local.pod_wait_str #"bash ${path.module}/template_scripts/wait.sh"
  }
}
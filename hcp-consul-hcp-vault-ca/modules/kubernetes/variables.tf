# Values with default options set from L1:L59
variable "versions" {
  type        = any
  description = "Versions of software used in the startup script"
  default = {
    kubectl_version    = "v1.22.4"
    helm_version       = "v3.7.1"
    consul_version     = "1.11.4+ent"
    consul_k8s_version = "0.40.0"
    amazonlinux        = "amazonlinux:2"
    yq_version         = "v4.20.2"
  }
}

variable "startup_script_options" {
  type        = any
  description = "Configuration settings for the kube configmap for the startup script"
  default = {
    file_permissions     = "0744"
    config_map_name      = "tutorial-startup-scripts"
    config_map_file_name = "startup.sh"
    mount_path           = "/startup"
    startup_command      = "/startup/startup.sh"
    volume_name          = "startup"
    template_file_name   = "template_scripts/startup-script.tftpl"
  }
}

variable "aws_creds_options" {
  type        = any
  description = "Creates the AWS credentials file which is directed towards the IAM Role associated with the Pod. Does not use password or token based authentication"
  default = {
    config_map_name     = "aws-credentials"
    config_map_filename = "credentials"
    mount_path          = "/root/.aws/credentials"
    volume_name         = "aws-credentials"
    template_file_name  = "template_scripts/aws-credentials.tftpl"
    file_permissions    = "0755"
  }
}

variable "aws_profile_config_options" {
  type        = any
  description = "Creates the configmap settings for the config that includes a profile for the aws credentials file"
  default = {
    config_map_name     = "aws-profile"
    config_map_filename = "config"
    mount_path          = "/root/.aws/config"
    volume_name         = "aws-profile"
    template_file_name  = "template_scripts/aws-profile-config.tftpl"
    file_permissions    = "0755"
  }
}

variable "pod_replicas" {
  type = string
  description = "Number of pod replicas for the working environment"
  default     = "1"
}

variable "tutorial_name" {
  type = string
  description = "Name of tutorial working environment"
  default     = "tutorial"
}

variable "enable_connect_inject" {
  type = bool
  description = "Whether or not Connect Inject is enabled for the **client** pod annotation"
  default = true
}

variable "automount_service_account_token" {
  type = bool
  description = "Whether or not the Kube Service account token is mounted into the pod"
  default = true
}

variable "workbench_container_port" {
  type = number
  description = "The port number for the workbench container"
  default = 8080
}

variable "volume_read_only" {
  type = bool
  description = "Whether or not the Kubernetes volume mount is read only"
  default = true
}

variable "environment_variable_names" {
  type = map(string)
  description = "The names of the environment variables to set in the workbench"
  default = {
    consul_ca = "CONSUL_CA"
    consul_http_token = "CONSUL_HTTP_TOKEN"
    consul_config = "CONSUL_CONFIG"
    consul_http_addr = "CONSUL_HTTP_ADDR"
    consul_k8s_api = "CONSUL_K8S_API_AWS"
    consul_accessor_id = "CONSUL_ACCESSOR_ID"
    consul_secret_id = "CONSUL_SECRET_ID"
    vault_token = "VAULT_TOKEN"
    vault_addr = "VAULT_ADDR"
    vault_namespace = "VAULT_NAMESPACE"
    aws_profile = "AWS_PROFILE"
  }
}

variable "kubernetes_cluster_role_binding" {
  type = any
  default = {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "cluster-admin"
    subjects = {
      service_account = {
        name = "ServiceAccount"
        namespace = "kube-system"
      }
      groups = {
        masters = {
          kind = "Group"
          name = "system:masters"
        }
        authenticated = {
          kind = "Group"
          name = "system:authenticated"
        }
      }
    }
  }
  description = "Options for setting the Kubernetes Cluster Role Binding for the workbench deployment"
}

# Variables from here to end of the doc do not set default values.

variable "consul_ca" {
  type        = string
  description = "Consul CA File"
}

variable "consul_http_token" {
  type        = string
  description = "Consul HTTP Token for CLI/API access"
}

variable "consul_config" {
  type        = string
  description = "Consul Config file, base64 encoded"
}

variable "consul_http_addr" {
  type        = string
  description = "HCP Consul Cluster endpoint"
}

variable "consul_k8s_api_aws" {
  type        = string
  description = "Kubernetes cluster endpoint URL"
}

variable "consul_accessor_id" {
  type        = string
  description = "Accessor ID for token"
}

variable "consul_secret_id" {
  type        = string
  description = "Secret ID for token"
}

variable "vault_token" {
  type        = string
  description = "Vault token"
}

variable "vault_addr" {
  type        = string
  description = "Vault endpoint"
}

variable "vault_namespace" {
  type        = string
  description = "Default Namespace in HCP Vault"
}

variable "profile_name" {
  type        = string
  description = "Name of the AWS Profile"
}

variable "role_arn" {
  type        = string
  description = "ARN of the IAM Role mapping to a Kubernetes service account"
}

variable "cluster_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account mapping to an IAM Role."
}

variable "cluster_region" {
  type        = string
  description = "AWS Region where the EKS cluster is located."
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS Cluster."
}

variable "kube_context" {
  type        = string
  description = "Name of the context to set in kubeconfig file for kubectl"
}


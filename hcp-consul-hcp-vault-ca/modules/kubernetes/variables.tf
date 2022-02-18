variable "versions" {
  default = {
    kubectl_version = "v1.22.4"
    helm_version = "v3.7.1"
    consul_version = "1.11.3+ent"
    consul_k8s_version = "0.40.0"
    amazonlinux = "amazonlinux:2"
  }
}

variable "consul_ca" {
  type = string
}
variable "consul_http_token" {
  type = string
}
variable "consul_config" {
  type = string
}
variable "consul_http_addr" {
  type = string
}
variable "consul_k8s_api_aws" {
  type = string
}
variable "consul_accessor_id" {
  type = string
}
variable "consul_secret_id" {
  type = string
}
variable "vault_token" {
  type = string
}
variable "vault_addr" {
  type = string
}
variable "vault_namespace" {
  type = string
}
variable "pod_replicas" {
  default = "1"
}

variable "tutorial_name" {
  description = "Name of tutorial working environment"
  default = "tutorial"
}

variable "startup_script_options" {
  default = {
    file_permissions = "0744"
    config_map_name = "tutorial-startup-scripts"
    config_map_file_name = "startup.sh"
    mount_path = "/startup"
    startup_command = "/startup/startup.sh"
    volume_name = "startup"
    template_file_name = "startup-script.tftpl"

  }
}

variable "environment_variables_file" {
  default = {
    config_map_name = "tutorial-env-vars"
    file_permissions = "0744"
    mount_path = "/environment"
    config_map_file_name = "env.sh"
    template_file_name = "env.tftpl"
    volume_name = "environment"
    startup_command = "/environment/envVars.sh"
  }
}
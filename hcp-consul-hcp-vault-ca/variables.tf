variable "region" {
  default     = "us-east-1"
  description = "Region in which to run this terraform code for the AWS Provider"
}
variable "node_group_configuration" {

  default = {
    ami_type       = "AL2_x86_64"
    instance_types = ["m5.large"]
    disk_size_gigs = 50
  }
}

variable "availability_zones" {
  description = "AZs"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to pass to AWS resources"
  default = {
    github = "hashicorp/learn-consul-kubernetes"
  }
}

# Set hcp_client_id and hcp_client_secret values. Configured with TF_VAR environment variables.
variable "hcp_client_id" {
  description = "The Client ID of the HCP Service Principal"
}
variable "hcp_client_secret" {
  description = "The Client Secret of the HCP Service Principal"
}

variable "aws_cidr_block" {
  description = "CIDR block for AWS"
  default = {
    allocation = "172.16.0.0/19"
    subnets = {
      private = ["172.16.2.0/24", "172.16.3.0/24"]
      public  = ["172.16.4.0/24", "172.16.5.0/24"]
    }
  }
}

variable "hcp_hvn_config" {
  description = "CIDR block for HCP"
  default = {
    allocation = "10.100.0.0/19"
    name       = "hcpTutorial"
  }
}

variable "hcp_peering_identifier" {
  type    = string
  default = "hcp-consul-vault-tutorial"
}

variable "hcp_region" {
  type    = string
  default = "us-east-1"
}

variable "cloud_provider" {
  default = "aws"
}

variable "hcp_consul_datacenter_name" {
  description = "name of datacenter"
  default     = "dc1"
  type        = string
}

variable "hcp_vault_cluster_name" {
  description = "name of vault cluster"
  default     = "vault-cluster"
  type        = string
}

variable "cluster_info" {
  default = {
    region = "us-east-1"
    name = "tutorialCluster"
    vpc_name = "hcpTutorialAwsVpc"
  }
}

variable "hcp_vault_default_namespace" {
  default = "admin"
  type = string
}
variable "region" {
  description = "AWS Region to deploy this terraform code"
  validation {
    condition = contains([
      "eu-north-1",
      "ap-south-1",
      "eu-west-3",
      "eu-west-2",
      "eu-west-1",
      "ap-northeast-3",
      "ap-northeast-2",
      "ap-northeast-1",
      "sa-east-1",
      "ca-central-1",
      "ap-southeast-1",
      "ap-southeast-2",
      "eu-central-1",
      "us-east-1",
      "us-east-2",
      "us-west-1",
      "us-west-2"
    ], var.region)
    error_message = "The name of the region you entered is invalid. Please try again. \n Reference: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html ."
  }
}

variable "node_group_configuration" {
  description = "Settings for the EKS Node Groups to pass to the EKS Module in main.tf"
  type        = any
  default = {
    ami_type          = "AL2_x86_64"
    instance_types    = ["m5.large"]
    disk_size_gigs    = 50
    min_instances     = 2
    max_instances     = 2
    desired_instances = 2
  }
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to pass to AWS resources"
  default = {
    github = "hashicorp/learn-consul-kubernetes"
  }
}

variable "aws_cidr_block" {
  description = "CIDR block for AWS VPC"
  default = {
    allocation = "172.16.0.0/19"
    subnets = {
      private = ["172.16.2.0/24", "172.16.3.0/24"]
      public  = ["172.16.4.0/24", "172.16.5.0/24"]
    }
  }
}

variable "hcp_hvn_config" {
  description = "CIDR block for HCP HVN"
  default = {
    allocation  = "10.100.0.0/19"
    name        = "hcpTutorial"
    vault_tier  = "starter_small"
    consul_tier = "standard"
  }
}

variable "hcp_peering_identifier" {
  type        = string
  description = "Name of the peering connection as displayed in the AWS API and Management Console"
  default     = "hcp-consul-vault-tutorial"
}

variable "hcp_region" {
  description = "HCP region for HCP-created resources"
  type        = string
}

variable "cloud_provider" {
  default     = "aws"
  type        = string
  description = "HCP Default Cloud Provider"
}

variable "hcp_consul_datacenter_name" {
  description = "Name of Consul datacenter"
  default     = "dc1"
  type        = string
}

variable "hcp_vault_cluster_name" {
  description = "name of HCP Vault cluster"
  default     = "vault-cluster"
  type        = string
}

variable "cluster_and_vpc_info" {
  default = {
    name               = "tutorialCluster"
    vpc_name           = "hcpTutorialAwsVpc"
    policy_name        = "workingenvironmentpolicy"
    policy_description = "Grant the cluster access to describe itself and assume an IAM Role."
    stage              = "dev"
  }
  type        = any
  description = "EKS Cluster Configuration Details"
}

variable "hcp_vault_default_namespace" {
  default     = "admin"
  type        = string
  description = "HCP Vault's Default Namespace. Must be specified when running Vault Enterprise"
}

variable "run_cleanup" {
  description = "Whether or not to run the cleanup script. False by default, set to True in the tutorial content as environment variable"
  type        = bool
  default     = false
}

variable "profile_name" {
  description = "Profile Name for the AWS Credentials in the working environment pod"
  type        = string
  default     = "kubeUser"
}

variable "kube_service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account that maps to an IAM Role"
  default     = "tutorial"
}

variable "kube_namespace" {
  type        = string
  description = "Which kubernetes namespace to use in this tutorial"
  default     = "default"
}
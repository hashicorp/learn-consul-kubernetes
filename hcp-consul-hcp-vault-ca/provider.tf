terraform {
  required_version = ">= 1.1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.22.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = module.eks.cluster_id
}

